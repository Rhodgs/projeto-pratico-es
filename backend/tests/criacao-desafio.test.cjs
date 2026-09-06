const { test } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const { stripTypeScriptTypes } = require('node:module');

// Executa os arquivos TypeScript reais sem instalar dependências ou abrir banco.
// Somente Prisma e o serviço de avaliação (fora deste caso de uso) são substituídos.
async function carregar(arquivo, persistir = async ({ data }) => ({ id: 'd1', ...data }), fonteInicial) {
  const context = vm.createContext({ Date });
  const cache = new Map();
  async function modulo(nome) {
    if (cache.has(nome)) return cache.get(nome);
    let mod;
    if (nome.endsWith('express.ts')) {
      mod = new vm.SyntheticModule(['Request', 'Response'], function () {}, { context });
    } else if (nome.endsWith('prismaClient.ts')) {
      mod = new vm.SyntheticModule(['prisma'], function () {
        this.setExport('prisma', { desafio: { create: persistir } });
      }, { context });
    } else if (nome.endsWith('DesafiosService.ts')) {
      mod = new vm.SyntheticModule(['DesafiosService'], function () {
        this.setExport('DesafiosService', class {});
      }, { context });
    } else {
      mod = new vm.SourceTextModule(stripTypeScriptTypes(nome === arquivo && fonteInicial !== undefined ? fonteInicial : fs.readFileSync(nome, 'utf8')), {
        context, identifier: nome,
      });
    }
    cache.set(nome, mod);
    await mod.link((specifier, parent) => modulo(path.resolve(path.dirname(parent.identifier), `${specifier}.ts`)));
    return mod;
  }
  const mod = await modulo(arquivo);
  await mod.evaluate();
  return mod.namespace;
}

const controller = path.resolve(__dirname, '../src/controllers/DesafioController.ts');
const facade = path.resolve(__dirname, '../src/services/CriacaoDesafioFacade.ts');
const antes = path.resolve(__dirname, 'fixtures/DesafioController.antes.txt');
const entrada = (prazo = '2099-01-01T00:00:00.000Z') => ({
  titulo: '  Reciclar  ', descricao: '  Separar resíduos  ', pontuacao: '150', prazoLimite: prazo,
});

async function executarController(arquivo, body, falhar = false) {
  const gravacoes = [];
  const ns = await carregar(controller, async ({ data }) => {
    gravacoes.push(data);
    if (falhar) throw new Error('Falha de persistência');
    return { id: 'd1', ...data };
  }, arquivo === antes ? fs.readFileSync(antes, 'utf8') : undefined);
  const res = { status(code) { this.code = code; return this; }, json(body) { this.body = body; return this; } };
  await new ns.DesafioController().criar({ body }, res);
  return JSON.parse(JSON.stringify({ code: res.code, body: res.body, gravacoes }));
}

for (const [nome, body, status, falhar] of [
  ['sucesso com normalização', entrada(), 201, false],
  ['título vazio', { ...entrada(), titulo: '   ' }, 400, false],
  ['descrição vazia', { ...entrada(), descricao: '' }, 400, false],
  ['prazo passado', entrada('2000-01-01T00:00:00Z'), 400, false],
  ['erro de persistência', entrada(), 400, true],
]) {
  test(`contrato HTTP antes/depois: ${nome}`, async () => {
    const anterior = await executarController(antes, body, falhar);
    const atual = await executarController(controller, body, falhar);
    assert.deepEqual(atual, anterior);
    assert.equal(atual.code, status);
    assert.equal(atual.gravacoes.length, status === 201 || falhar ? 1 : 0);
    if (status === 201) {
      assert.equal(atual.body.desafio.titulo, 'Reciclar');
      assert.equal(atual.body.desafio.pontuacao, 150);
    }
  });
}

for (const [delta, aceita] of [[-1, false], [0, false], [59999, false], [60000, true]]) {
  test(`fachada: limite temporal ${delta} ms`, async () => {
    const { CriacaoDesafioFacade } = await carregar(facade);
    const agora = new Date('2026-09-06T12:00:00Z');
    let gravacoes = 0;
    const instancia = new CriacaoDesafioFacade({ criar: async dados => { gravacoes++; return dados; } }, undefined, () => agora);
    const acao = instancia.criar(entrada(new Date(agora.getTime() + delta).toISOString()));
    if (aceita) assert.equal((await acao).pontuacao, 150);
    else await assert.rejects(acao, /Prazo/);
    assert.equal(gravacoes, aceita ? 1 : 0);
  });
}

test('fachada: propaga erro do repositório sem repetir gravação', async () => {
  const { CriacaoDesafioFacade } = await carregar(facade);
  let chamadas = 0;
  const instancia = new CriacaoDesafioFacade({ criar: async () => { chamadas++; throw new Error('indisponível'); } });
  await assert.rejects(instancia.criar(entrada()), /indisponível/);
  assert.equal(chamadas, 1);
});

