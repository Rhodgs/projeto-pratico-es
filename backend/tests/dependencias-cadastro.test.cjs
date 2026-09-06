const { test } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const carregar = require('./helpers/carregar-ts.cjs');
const arquivo = rel => path.resolve(__dirname, '../src', rel);
const plain = value => JSON.parse(JSON.stringify(value));
const resposta = () => ({ status(code) { this.code = code; return this; }, json(body) { this.body = body; return this; } });
const dados = perfil => ({ nome: 'Ana', email: 'ana@example.org', senha: 'Senha123', perfil, codigoTurma: 'ABC123' });

async function cadastro(antes = false, opcoes = {}) {
  const chamadas = { criar: [], hash: [], turma: [] };
  const db = {
    usuario: {
      findUnique: async () => opcoes.usuario === undefined ? { id: 'u1', nome: 'Ana', email: 'ana@example.org', senha: 'hash', perfil: 'Aluno' } : opcoes.usuario,
      create: async args => {
        chamadas.criar.push(plain(args));
        if (opcoes.erro) throw opcoes.erro;
        const registro = { id: 'u1', ...args.data, criadoEm: '2026-09-06' };
        return Object.fromEntries(Object.keys(args.select).map(key => [key, registro[key]]));
      },
    },
    turma: { findUnique: async args => { chamadas.turma.push(plain(args)); return opcoes.semTurma ? null : { id: 't1' }; } },
  };
  const senhas = {
    hash: async (...args) => { chamadas.hash.push(args); return 'hash'; },
    compare: async () => opcoes.senhaCorreta !== false,
  };
  const target = arquivo('services/CadastroService.ts');
  const ns = await carregar(target, antes ? {
    source: fs.readFileSync(path.resolve(__dirname, 'fixtures/problemas-3-4/CadastroService.ts.txt'), 'utf8'),
    mocks: { 'prismaClient.ts': { prisma: db }, bcrypt: { default: senhas } },
  } : {});
  const f = await carregar(arquivo('factories/CriadorUsuario.ts'));
  return { service: antes ? new ns.CadastroService() : new ns.CadastroService({
    db, senhas, criadores: { Aluno: new f.CriadorAluno(), Professor: new f.CriadorProfessor() },
  }), chamadas };
}

for (const perfil of ['Aluno', 'Professor', 'aluno', 'PROFESSOR']) {
  test(`cadastro antes/depois: ${perfil}`, async () => {
    const a = await cadastro(true); const b = await cadastro();
    assert.deepEqual(plain(await b.service.cadastrar(dados(perfil))), plain(await a.service.cadastrar(dados(perfil))));
    assert.deepEqual(b.chamadas, a.chamadas);
    assert.equal(b.chamadas.criar.length, 1);
    assert.equal(b.chamadas.criar[0].select.senha, undefined);
    assert.equal(b.chamadas.criar[0].data.senha, 'hash');
  });
}
for (const perfil of ['Aluno', 'Professor']) {
  test(`P2002 traduzido uma vez: ${perfil}`, async () => {
    const c = await cadastro(false, { erro: { code: 'P2002' } });
    await assert.rejects(c.service.cadastrar(dados(perfil)), e => e.statusCode === 400 && e.message === 'Este e-mail já está cadastrado.');
    assert.equal(c.chamadas.criar.length, 1);
  });
}
for (const [nome, entrada, opcoes, status] of [
  ['senha ausente', { ...dados('Aluno'), senha: undefined }, {}, undefined],
  ['senha curta', { ...dados('Aluno'), senha: '123' }, {}, 422],
  ['código ausente', { ...dados('Aluno'), codigoTurma: undefined }, {}, 422],
  ['turma inexistente', dados('Aluno'), { semTurma: true }, 422],
]) {
  test(`validação preservada: ${nome}`, async () => {
    const a = await cadastro(true, opcoes); const b = await cadastro(false, opcoes);
    const capturar = async service => { try { await service.cadastrar(entrada); assert.fail('deveria falhar'); } catch (e) { return { message: e.message, statusCode: e.statusCode }; } };
    const atual = await capturar(b.service);
    assert.deepEqual(atual, await capturar(a.service));
    assert.equal(atual.statusCode, status);
    assert.equal(b.chamadas.criar.length, 0);
  });
}
for (const perfil of ['Administrador', '', undefined]) {
  test(`correção: perfil inválido ${String(perfil)} não é persistido`, async () => {
    const c = await cadastro();
    await assert.rejects(c.service.cadastrar(dados(perfil)), e => e.statusCode === 422);
    assert.equal(c.chamadas.criar.length, 0);
    assert.equal(c.chamadas.hash.length, 0);
  });
}
test('erro de infraestrutura é propagado sem retry', async () => {
  const erro = new Error('indisponível'); const c = await cadastro(false, { erro });
  await assert.rejects(c.service.cadastrar(dados('Professor')), e => e === erro);
  assert.equal(c.chamadas.criar.length, 1);
});
test('login preserva resultado sem hash', async () => {
  const a = await cadastro(true); const b = await cadastro();
  const result = await b.service.login('ana@example.org', 'Senha123');
  assert.deepEqual(plain(result), plain(await a.service.login('ana@example.org', 'Senha123')));
  assert.equal(result.senha, undefined);
});
for (const opcoes of [{ usuario: null }, { senhaCorreta: false }]) {
  test(`login inválido: ${JSON.stringify(opcoes)}`, async () => {
    const c = await cadastro(false, opcoes);
    await assert.rejects(c.service.login('a', 'b'), e => e.statusCode === 401);
  });
}
test('Factory Method produz tipos distintos com campos comuns', async () => {
  const f = await carregar(arquivo('factories/CriadorUsuario.ts'));
  const base = { nome: 'Ana', email: 'a', senha: 'hash' };
  const aluno = new f.CriadorAluno().criarUsuario(base, 't1');
  const professor = new f.CriadorProfessor().criarUsuario(base);
  assert.ok(aluno instanceof f.AlunoParaCadastro);
  assert.ok(professor instanceof f.ProfessorParaCadastro);
  assert.equal(aluno.paraPersistencia().turmas.connect.id, 't1');
  assert.equal(professor.paraPersistencia().turmas, undefined);
  assert.throws(() => new f.CriadorAluno().preparar(base), /turma validada/);
});

test('AuthController aceita mock por construtor e preserva mapeamento role', async () => {
  const { AuthController } = await carregar(arquivo('controllers/AuthController.ts'));
  let recebido;
  const c = new AuthController({ cadastrar: async value => { recebido = value; return { id: 'u1' }; }, login: async () => ({ id: 'u1' }) });
  const res = resposta();
  await c.register({ body: { ...dados('Aluno'), role: 'Professor' } }, res);
  assert.equal(recebido.perfil, 'Professor'); assert.equal(res.code, 201);
  const login = resposta(); await c.login({ body: { email: 'a', senha: 'b' } }, login);
  assert.equal(login.code, 200);
});
test('AuthController preserva erro de negócio injetado', async () => {
  const { AuthController } = await carregar(arquivo('controllers/AuthController.ts'));
  const c = new AuthController({ login: async () => { throw Object.assign(new Error('negado'), { statusCode: 401 }); } });
  const res = resposta(); await c.login({ body: {} }, res);
  assert.equal(res.code, 401); assert.equal(res.body.erro, 'negado');
});
test('TurmaController valida antes de chamar mock e delega operações', async () => {
  const { TurmaController } = await carregar(arquivo('controllers/TurmaController.ts'));
  let calls = 0;
  const c = new TurmaController({
    criarTurma: async () => { calls++; return { id: 't1', nome: 'A', codigo: 'ABC123' }; },
    listarTurmasDoProfessor: async id => [{ professorId: id }], excluirTurma: async () => false,
  });
  const vazio = resposta(); await c.criarTurma({ body: { nome: '' } }, vazio);
  assert.equal(vazio.code, 400); assert.equal(calls, 0);
  const criado = resposta(); await c.criarTurma({ body: { nome: 'A', professorId: 'p1' } }, criado);
  assert.equal(criado.code, 201); assert.equal(calls, 1);
  const lista = resposta(); await c.listarTurmas({ query: { professorId: 'p1' } }, lista);
  assert.equal(lista.body[0].professorId, 'p1');
  const excluido = resposta(); await c.excluirTurma({ params: { id: 'x' } }, excluido);
  assert.equal(excluido.code, 404);
});
test('AlunoController delega ranking ao serviço correto', async () => {
  const { AlunoController } = await carregar(arquivo('controllers/alunoController.ts'));
  let recebido;
  const c = new AlunoController({ buscarTop5: async id => { recebido = id; return [{ id: 'u1' }]; } });
  const res = resposta(); await c.listarRanking({ params: { id: ['t1'] } }, res);
  assert.equal(recebido, 't1'); assert.equal(res.code, 200);
});
test('DesafioController injeta fachada, avaliação e persistência', async () => {
  const { DesafioController } = await carregar(arquivo('controllers/DesafioController.ts'));
  const c = new DesafioController({
    criacao: { criar: async () => ({ id: 'd1' }) },
    desafios: { aprovarEvidencia: async id => ({ id }), recusarEvidencia: async (id, justificativa) => ({ id, justificativa }), listarPendentes: async () => [] },
    db: { desafio: { findMany: async () => [{ id: 'd1' }] } },
  });
  for (const [metodo, req, status] of [
    ['criar', { body: {} }, 201], ['aprovar', { params: { id: 'e1' } }, 200],
    ['recusar', { params: { id: 'e1' }, body: { justificativa: 'motivo' } }, 200],
    ['listarPendentes', {}, 200], ['listar', {}, 200],
  ]) {
    const res = resposta(); await c[metodo === 'listarPendentes' ? 'listarEvidenciasPendentes' : metodo](req, res);
    assert.equal(res.code, status);
  }
});
test('composição permite duas aplicações isoladas sem instâncias globais de controllers', async () => {
  const { montarControllers } = await carregar(arquivo('composition/controllers.ts'));
  const montar = id => montarControllers({ cadastro: { login: async () => ({ id }) }, turmas: {}, ranking: {}, desafio: {} });
  const a = montar('a'); const b = montar('b');
  for (const [app, id] of [[a, 'a'], [b, 'b'], [a, 'a']]) {
    const res = resposta(); await app.authController.login({ body: {} }, res);
    assert.equal(res.body.usuario.id, id);
  }
  assert.notEqual(a.authController, b.authController);
});

test('evidências movidas para classe usam o banco injetado', async () => {
  const { DesafioController } = await carregar(arquivo('controllers/DesafioController.ts'));
  const gravados = [];
  const c = new DesafioController({ db: {
    desafio: { findUnique: async () => ({ id: 'd1' }) },
    usuario: { findUnique: async () => ({ id: 'u1' }) },
    evidencia: {
      create: async ({ data }) => { gravados.push(plain(data)); return { id: 'e1', ...data }; },
      findMany: async ({ where }) => [{ desafioId: where.desafioId }],
    },
  } });
  const res = resposta();
  await c.anexarEvidencia({ params: { id: 'd1' }, body: { alunoId: 'u1' }, file: { path: 'foto.png' } }, res);
  assert.equal(res.code, 201);
  assert.deepEqual(gravados, [{ desafioId: 'd1', alunoId: 'u1', arquivoUrl: 'foto.png', status: 'pendente' }]);
  const lista = resposta(); await c.listarEvidencias({ params: { id: 'd1' } }, lista);
  assert.equal(lista.code, 200); assert.equal(lista.body[0].desafioId, 'd1');
});

test('evidência sem arquivo mantém erro 400 antes de acessar banco', async () => {
  const { DesafioController } = await carregar(arquivo('controllers/DesafioController.ts'));
  const c = new DesafioController({ db: {} });
  const res = resposta(); await c.anexarEvidencia({ params: { id: 'd1' }, body: { alunoId: 'u1' } }, res);
  assert.equal(res.code, 400);
  assert.match(res.body.error, /foto/);
});

test('servidor registra rotas nos novos métodos sem abrir porta real', async () => {
  const rotas = new Map(); const chamadas = [];
  const app = { use() {}, listen() { return { on() {} }; } };
  for (const verbo of ['get', 'post', 'put', 'delete']) {
    app[verbo] = (url, ...handlers) => rotas.set(`${verbo} ${url}`, handlers);
  }
  const express = Object.assign(() => app, { json: () => () => {} });
  const controller = nomes => Object.fromEntries(nomes.map(nome => [nome, function (req, res) {
    assert.ok(Object.values(controllers).includes(this), 'handler deve preservar o receptor do método');
    chamadas.push(nome); return res.status(200).json({ nome });
  }]));
  const controllers = {
    turmaController: controller(['criarTurma', 'listarTurmas', 'excluirTurma']),
    desafioController: controller(['criar', 'listar', 'aprovar', 'recusar', 'anexarEvidencia', 'listarEvidencias', 'listarEvidenciasPendentes']),
    authController: controller(['login', 'register']),
  };
  await carregar(path.resolve(__dirname, '../server.ts'), {
    globals: { process: { on() {} }, console: { log() {}, error() {} } },
    mocks: {
      express: { default: express, Request: undefined, Response: undefined, RequestHandler: undefined, NextFunction: undefined },
      'producao.ts': { criarControllersProducao: () => controllers },
      'PreferenciasController.ts': { salvarPreferencias() {}, buscarPreferencias() {} },
      'UsuarioController.ts': { usuarioController: { buscarPerfil() {} } },
      'RankingController.ts': { rankingController: { buscarRanking() {} } },
      'multerConfig.ts': { uploadEvidencia: { single: () => () => {} } },
      child_process: { exec() {} },
    },
  });
  for (const rota of ['post /api/turmas', 'get /api/turmas', 'delete /api/turmas/:id',
    'post /api/desafios/:id/evidencias', 'get /api/desafios/:id/evidencias', 'get /api/evidencias/pendentes']) {
    const handlers = rotas.get(rota); assert.ok(handlers, rota);
    await handlers.at(-1)({}, resposta());
  }
  assert.deepEqual(chamadas, ['criarTurma', 'listarTurmas', 'excluirTurma', 'anexarEvidencia', 'listarEvidencias', 'listarEvidenciasPendentes']);
});
