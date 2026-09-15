const { test } = require('node:test');
const assert = require('node:assert/strict');
const path = require('node:path');
const carregar = require('./helpers/carregar-ts.cjs');
const plain = value => JSON.parse(JSON.stringify(value));

async function service(nome, prisma = {}, redis = {}) {
  const ns = await carregar(path.resolve(__dirname, '../src/services', `${nome}.ts`), {
    mocks: { 'prismaClient.ts': { prisma }, 'redisClient.ts': { redis } },
  });
  return new ns[nome]();
}

for (const [perfil, quantidade, codigo, esperado] of [
  ['Aluno', 0, 'ABC123', /Apenas professores/],
  ['Professor', 10, 'ABC123', /Limite máximo/],
  ['Professor', 9, 'ABC123', /^Sucesso/],
  ['Professor', 0, 'ABC12', /6 caracteres/],
  ['Professor', 0, 'abc123', /maiúsculas/],
]) {
  test(`turmas reais: ${perfil}, ${quantidade} turmas, código ${codigo}`, async () => {
    const s = await service('TurmaService');
    assert.match(s.validarCriacaoTurma(perfil, quantidade, codigo), esperado);
  });
}

test('criação real de turma resolve colisão de código e normaliza nome', async () => {
  let consultas = 0;
  let salvo;
  const s = await service('TurmaService', {
    usuario: { findUnique: async () => ({ perfil: 'Professor' }) },
    turma: {
      count: async () => 9,
      findUnique: async () => ++consultas === 1 ? { id: 'existente' } : null,
      create: async args => { salvo = plain(args); return args.data; },
    },
  });
  await s.criarTurma('  Ecologia  ', 'p1');
  assert.equal(consultas, 2);
  assert.equal(salvo.data.nome, 'Ecologia');
  assert.equal(salvo.data.professorId, 'p1');
  assert.match(salvo.data.codigo, /^[A-Z0-9]{6}$/);
});

test('turma sem professor existente não grava nem consulta códigos', async () => {
  const s = await service('TurmaService', { usuario: { findUnique: async () => null } });
  await assert.rejects(s.criarTurma('A', 'inexistente'), /Professor não encontrado/);
});

test('ranking usa cache sem consultar o banco', async () => {
  const esperado = [{ id: 'a1', nome: 'Ana', xp: 100, posicao: 1 }];
  const s = await service('RankingService', {}, {
    get: async chave => { assert.equal(chave, 'ranking:turma:t1'); return JSON.stringify(esperado); },
  });
  assert.deepEqual(plain(await s.buscarTop5('t1')), esperado);
});

test('ranking sem cache limita top 5, numera posições e salva por 300 segundos', async () => {
  const alunos = Array.from({ length: 7 }, (_, i) => ({ id: `a${i}`, nome: `Aluno ${i}`, xp: 700 - i * 100 }));
  let cache;
  const s = await service('RankingService', { turma: { findUnique: async args => {
    assert.equal(args.where.id, 't1');
    assert.equal(args.include.alunos.orderBy.xp, 'desc');
    return { alunos };
  } } }, { get: async () => null, setex: async (...args) => { cache = args; } });
  const resultado = plain(await s.buscarTop5('t1'));
  assert.deepEqual(resultado, alunos.slice(0, 5).map((aluno, i) => ({ ...aluno, posicao: i + 1 })));
  assert.deepEqual(cache, ['ranking:turma:t1', 300, JSON.stringify(resultado)]);
});

test('ranking de turma inexistente rejeita sem salvar cache', async () => {
  const s = await service('RankingService', { turma: { findUnique: async () => null } }, { get: async () => null });
  await assert.rejects(s.buscarTop5('inexistente'), /Turma não encontrada/);
});

test('posição individual inclui aluno fora do top 5 e retorna null para não integrante', async () => {
  const alunos = Array.from({ length: 6 }, (_, i) => ({ id: `a${i}`, nome: 'Aluno', xp: 60 - i }));
  const s = await service('RankingService', { turma: { findUnique: async () => ({ alunos }) } });
  assert.equal((await s.buscarPosicaoDoAluno('t1', 'a5')).posicao, 6);
  assert.equal(await s.buscarPosicaoDoAluno('t1', 'outro'), null);
});

test('aprovação concede pontuação e invalida ranking de todas as turmas', async () => {
  const chamadas = [];
  const s = await service('DesafiosService', {
    evidencia: {
      findUnique: async () => ({ alunoId: 'a1', desafio: { pontuacao: 150 } }),
      update: async args => { chamadas.push(plain(args)); return args.data; },
    },
    usuario: {
      update: async args => { chamadas.push(plain(args)); },
      findUnique: async () => ({ turmas: [{ id: 't1' }, { id: 't2' }] }),
    },
  }, { del: async chave => { chamadas.push(chave); } });
  assert.equal((await s.aprovarEvidencia('e1')).status, 'aprovada');
  assert.deepEqual(chamadas, [
    { where: { id: 'e1' }, data: { status: 'aprovada' } },
    { where: { id: 'a1' }, data: { xp: { increment: 150 } } },
    'ranking:turma:t1', 'ranking:turma:t2',
  ]);
});

test('aprovação inexistente rejeita antes de conceder XP', async () => {
  const s = await service('DesafiosService', { evidencia: { findUnique: async () => null } });
  await assert.rejects(s.aprovarEvidencia('e1'), /Evidência não encontrada/);
});

for (const justificativa of ['', '   ', undefined]) {
  test(`recusa sem justificativa válida: ${JSON.stringify(justificativa)}`, async () => {
    const s = await service('DesafiosService');
    await assert.rejects(s.recusarEvidencia('e1', justificativa), /justificativa é obrigatória/);
  });
}

test('recusa preserva justificativa e não concede XP', async () => {
  const s = await service('DesafiosService', { evidencia: {
    findUnique: async () => ({ id: 'e1' }),
    update: async args => plain(args),
  } });
  assert.deepEqual(await s.recusarEvidencia('e1', 'Foto ilegível'), {
    where: { id: 'e1' }, data: { status: 'recusada', justificativa: 'Foto ilegível' },
  });
});

// Executam a expectativa correta. TODO indica defeito conhecido, não aprovação.
test('BUG-XP: aprovar a mesma evidência duas vezes concede XP apenas uma vez', { todo: 'Falta idempotência e transação na aprovação' }, async () => {
  let xp = 0;
  const evidencia = { alunoId: 'a1', status: 'pendente', desafio: { pontuacao: 150 } };
  const s = await service('DesafiosService', {
    evidencia: { findUnique: async () => evidencia, update: async () => { evidencia.status = 'aprovada'; return evidencia; } },
    usuario: { update: async args => { xp += args.data.xp.increment; }, findUnique: async () => ({ turmas: [] }) },
  });
  await s.aprovarEvidencia('e1');
  try { await s.aprovarEvidencia('e1'); } catch { /* Recusar repetição também é válido. */ }
  assert.equal(xp, 150);
});

for (const [nome, alteracao] of [
  ['prazo inválido', { prazoLimite: 'data-invalida' }],
  ['pontuação não numérica', { pontuacao: 'abc' }],
]) {
  test(`BUG-VALIDACAO: rejeitar ${nome} antes de persistir`, { todo: 'Falta validar data e número finitos' }, async () => {
    const { CriacaoDesafioFacade } = await carregar(path.resolve(__dirname, '../src/services/CriacaoDesafioFacade.ts'));
    let gravacoes = 0;
    const s = new CriacaoDesafioFacade({ criar: async dados => { gravacoes++; return dados; } }, undefined, () => new Date('2026-09-15T12:00:00Z'));
    await assert.rejects(s.criar({ titulo: 'Reciclar', descricao: 'Separar resíduos', pontuacao: 100, prazoLimite: '2026-09-16T12:00:00Z', ...alteracao }));
    assert.equal(gravacoes, 0);
  });
}
