// ============================================================
// DesafioService.ts
// MVP: dados mantidos em memória (sem banco de dados real).
// Arquivo resultante da fusão de duas branches:
//   - DesafiosService (validações / testes unitários) — Pessoa A
//   - DesafioService (CRUD com regras de negócio)      — Pessoa B
// Ambos compartilham os MESMOS arrays em memória (desafios/evidencias)
// para não haver duas "fontes da verdade" diferentes no app.
// ============================================================

// ── Interfaces unificadas ──────────────────────────────────
// Obs: prazoLimite/enviadoEm/criadoEm são `Date`. Se algum lugar do
// código precisar de string ISO (ex.: resposta JSON da API), converta
// na borda (controller) com `.toISOString()`, não aqui no model.

export type StatusEvidencia = 'pendente' | 'aprovada' | 'recusada';

export interface Desafio {
  id: string;
  titulo: string;
  descricao: string;
  pontuacao: number; // alias semântico de "xpRecompensa"
  prazoLimite: Date;
  criadoEm: Date;
}

export interface Evidencia {
  id: string;
  desafioId: string;
  alunoId?: string;
  alunoNome?: string;
  arquivoNome?: string;
  status: StatusEvidencia;
  justificativa?: string;
  enviadoEm: Date;
}

// ── Dados mockados de desafios (MVP sem banco) ───────────────
export const desafios: Desafio[] = [
  {
    id: 'coleta-plastico',
    titulo: 'Herói da Reciclagem',
    descricao: 'Separe 10 itens recicláveis esta semana.',
    pontuacao: 150,
    prazoLimite: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),
    criadoEm: new Date(),
  },
  {
    id: 'economia-agua',
    titulo: 'Guardião da Água',
    descricao: 'Reduza o tempo de banho para 5 minutos por 3 dias.',
    pontuacao: 100,
    prazoLimite: new Date(Date.now() + 3 * 24 * 60 * 60 * 1000),
    criadoEm: new Date(),
  },
];

// ── Array de evidências em memória (compartilhado) ───────────
export const evidencias: Evidencia[] = [];

// ── Helper interno ────────────────────────────────────────────
function gerarId(prefixo = 'ev'): string {
  return `${prefixo}_${Date.now()}_${Math.random().toString(36).slice(2, 7)}`;
}

// ============================================================
// CLASSE 1 — VALIDAÇÕES (usadas pelos testes unitários e antes
// de persistir qualquer dado). Métodos puros, sem efeito colateral.
// ============================================================
export class DesafiosService {
  /** Classe 1 e 2: Título, Descrição e Classificação preenchidos */
  static validarCamposCriacao(
    titulo: string,
    descricao: string,
    classificacao: string,
  ): boolean {
    if (!titulo?.trim() || !descricao?.trim() || !classificacao?.trim()) {
      return false;
    }
    return true;
  }

  /** Classe 3, 4 e 5: prazo é futuro, passado ou "presente" (muito próximo) */
  static validarPrazoCriacao(prazoLimite: Date, dataAtual: Date): string {
    const limiteMs = prazoLimite.getTime();
    const atualMs = dataAtual.getTime();

    if (limiteMs < atualMs) return 'PASSADO';
    if (Math.abs(limiteMs - atualMs) < 60000) return 'PRESENTE';
    return 'FUTURO';
  }

  /** Classe 6 e 7: aluno enviou antes do cronômetro zerar? */
  static verificarPrazoEnvioAluno(prazoLimite: Date, dataEnvio: Date): string {
    if (dataEnvio.getTime() > prazoLimite.getTime()) return 'Expirado';
    return 'Aguardando Validação';
  }

  /** Classes 8 a 12: extensão (.jpg/.png) e tamanho (0 a 5MB) */
  static validarTamanhoEFormato(nomeArquivo: string, tamanhoMB: number): boolean {
    const nome = nomeArquivo.toLowerCase();
    const formatoValido = nome.endsWith('.jpg') || nome.endsWith('.png');
    const tamanhoValido = tamanhoMB > 0 && tamanhoMB <= 5;
    return formatoValido && tamanhoValido;
  }

  /** Classes 13 e 14: Tipo MIME real (bloqueia scripts disfarçados) */
  static validarTipoRealMime(nomeArquivo: string, mimeTypeDetectado: string): boolean {
    const isMimeJpg =
      mimeTypeDetectado === 'image/jpeg' || mimeTypeDetectado === 'image/jpg';
    const isMimePng = mimeTypeDetectado === 'image/png';

    if (nomeArquivo.endsWith('.jpg') && !isMimeJpg) return false;
    if (nomeArquivo.endsWith('.png') && !isMimePng) return false;
    return true;
  }

  /** Classes 15 e 16: hash inédito? */
  static validarDuplicidade(hashNovo: string, bancoHashes: string[]): boolean {
    return !bancoHashes.includes(hashNovo);
  }
}

// ============================================================
// CLASSE 2 — REGRAS DE NEGÓCIO / CRUD (lança exceptions em vez
// de retornar boolean, usada pelo controller em produção).
// ============================================================
export class DesafioService {
  /** Cria desafio aplicando as mesmas validações da DesafiosService */
  static criarDesafio(dados: Omit<Desafio, 'id' | 'criadoEm'>): Desafio {
    if (!DesafiosService.validarCamposCriacao(dados.titulo, dados.descricao, 'ok')) {
      throw new Error('Erro: Campos obrigatórios vazios.');
    }

    const agora = new Date();
    const prazo = new Date(dados.prazoLimite);
    const statusPrazo = DesafiosService.validarPrazoCriacao(prazo, agora);

    if (statusPrazo === 'PASSADO') {
      throw new Error('Erro: Prazo no passado.');
    }
    if (statusPrazo === 'PRESENTE') {
      throw new Error('Erro: Prazo precisa dar um tempo mínimo útil de duração.');
    }

    const novoDesafio: Desafio = {
      id: 'DES-' + Math.random().toString(36).substring(2, 7).toUpperCase(),
      titulo: dados.titulo.trim(),
      descricao: dados.descricao.trim(),
      pontuacao: Number(dados.pontuacao),
      prazoLimite: prazo,
      criadoEm: agora,
    };

    desafios.push(novoDesafio);
    return novoDesafio;
  }

  static aprovarEvidencia(evidenciaId: string): Evidencia {
    const evidencia = evidencias.find((e) => e.id === evidenciaId);
    if (!evidencia) throw new Error('Evidência não encontrada.');
    evidencia.status = 'aprovada';
    return evidencia;
  }

  static recusarEvidencia(evidenciaId: string, justificativa: string): Evidencia {
    const evidencia = evidencias.find((e) => e.id === evidenciaId);
    if (!evidencia) throw new Error('Evidência não encontrada.');

    if (!justificativa || justificativa.trim() === '') {
      throw new Error('É obrigatório informar a justificativa para recusar a evidência.');
    }

    evidencia.status = 'recusada';
    evidencia.justificativa = justificativa.trim();
    return evidencia;
  }
}

// ============================================================
// FUNÇÕES DE ACESSO AO ARRAY (usadas pelo DesafioController)
// ============================================================
export function buscarDesafioPorId(id: string): Desafio | undefined {
  return desafios.find((d) => d.id === id);
}

export function adicionarEvidencia(
  desafioId: string,
  arquivoNome: string,
  alunoId?: string,
  alunoNome?: string,
): Evidencia {
  const novaEvidencia: Evidencia = {
    id: gerarId(),
    desafioId,
    arquivoNome,
    alunoId,
    alunoNome,
    status: 'pendente',
    enviadoEm: new Date(),
  };
  evidencias.push(novaEvidencia);
  return novaEvidencia;
}

export function listarEvidenciasPorDesafio(desafioId: string): Evidencia[] {
  return evidencias.filter((e) => e.desafioId === desafioId);
}

// Reutilizado pelo professor (US5 / US11)
export function atualizarStatusEvidencia(
  evidenciaId: string,
  novoStatus: 'aprovada' | 'recusada',
): Evidencia | undefined {
  const ev = evidencias.find((e) => e.id === evidenciaId);
  if (ev) ev.status = novoStatus;
  return ev;
}