// ============================================================
// DesafioService.ts
// MVP: dados mantidos em memória (sem banco de dados real).
// ── Classe DesafiosService: validações (testes unitários)
// ── Funções exportadas: CRUD do array em memória (US4)
// ============================================================

// ── Interfaces ───────────────────────────────────────────────

export interface Evidencia {
  id: string;
  desafioId: string;
  arquivoNome: string;
  status: 'pendente' | 'aprovada' | 'recusada';
  enviadoEm: string; // ISO 8601
}

export interface Desafio {
  id: string;
  titulo: string;
  descricao: string;
  prazoLimite: string; // ISO 8601
  xpRecompensa: number;
}

// ── Dados mockados de desafios (MVP sem banco) ───────────────
const desafios: Desafio[] = [
  {
    id: 'coleta-plastico',
    titulo: 'Herói da Reciclagem',
    descricao: 'Separe 10 itens recicláveis esta semana.',
    prazoLimite: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString(),
    xpRecompensa: 150,
  },
  {
    id: 'economia-agua',
    titulo: 'Guardião da Água',
    descricao: 'Reduza o tempo de banho para 5 minutos por 3 dias.',
    prazoLimite: new Date(Date.now() + 3 * 24 * 60 * 60 * 1000).toISOString(),
    xpRecompensa: 100,
  },
];

// ── Array de evidências em memória (requisito da branch) ─────
export const evidencias: Evidencia[] = [];

// ── Helper interno ────────────────────────────────────────────
function gerarId(): string {
  return `ev_${Date.now()}_${Math.random().toString(36).slice(2, 7)}`;
}

// ============================================================
// CLASSE DE VALIDAÇÕES
// Métodos estáticos usados pelos testes unitários e pelo
// controller antes de persistir qualquer dado.
// ============================================================
export class DesafiosService {
  /**
   * Classe 1 e 2: Verifica se Título, Descrição e Classificação estão preenchidos
   * O que retorna: true (se tudo preenchido) ou false (se tem algum vazio)
   */
  static validarCamposCriacao(
    titulo: string,
    descricao: string,
    classificacao: string,
  ): boolean {
    if (!titulo.trim() || !descricao.trim() || !classificacao.trim) {
      return false; // Classe Inválida 2
    }
    return true; // Classe Válida 1
  }

  /**
   * Classe 3, 4 e 5: Verifica se o Prazo Limite definido pelo professor é futuro, passado ou presente
   * O que retorna: Uma string ('FUTURO', 'PASSADO' ou 'PRESENTE')
   */
  static validarPrazoCriacao(prazoLimite: Date, dataAtual: Date): string {
    const limiteMs = prazoLimite.getTime();
    const atualMs = dataAtual.getTime();

    if (limiteMs < atualMs) {
      return 'PASSADO';
    }
    if (Math.abs(limiteMs - atualMs) < 60000) {
      return 'PRESENTE';
    }
    return 'FUTURO';
  }

  /**
   * Classe 6 e 7: Verifica se o aluno enviou antes do cronômetro zerar
   * O que retorna: 'Aguardando Validação' ou 'Expirado'
   */
  static verificarPrazoEnvioAluno(prazoLimite: Date, dataEnvio: Date): string {
    if (dataEnvio.getTime() > prazoLimite.getTime()) {
      return 'Expirado'; // Classe Inválida 7
    }
    return 'Aguardando Validação'; // Classe Válida 6
  }

  /**
   * Classes 8 a 12: Verifica extensão (.jpg/.png) e tamanho (0 a 5MB)
   * O que retorna: booleano
   */
  static validarTamanhoEFormato(nomeArquivo: string, tamanhoMB: number): boolean {
    const nome = nomeArquivo.toLowerCase();
    const formatoValido = nome.endsWith('.jpg') || nome.endsWith('.png'); // Classe 8
    const tamanhoValido = tamanhoMB > 0 && tamanhoMB <= 5; // Classe 10

    return formatoValido && tamanhoValido;
  }

  /**
   * Classes 13 e 14: Verifica o Tipo MIME Real (Bloqueia scripts disfarçados)
   * O que retorna: booleano
   */
  static validarTipoRealMime(nomeArquivo: string, mimeTypeDetectado: string): boolean {
    const isMimeJpg =
      mimeTypeDetectado === 'image/jpeg' || mimeTypeDetectado === 'image/jpg';
    const isMimePng = mimeTypeDetectado === 'image/png';

    if (nomeArquivo.endsWith('.jpg') && !isMimeJpg) return false; // Classe Inválida 14
    if (nomeArquivo.endsWith('.png') && !isMimePng) return false;

    return true; // Classe Válida 13
  }

  /**
   * Classes 15 e 16: Verifica se o hash é inédito no banco de dados
   * O que retorna: booleano
   */
  static validarDuplicidade(hashNovo: string, bancoHashes: string[]): boolean {
    if (bancoHashes.includes(hashNovo)) {
      return false; // Classe Inválida 16
    }
    return true; // Classe Válida 15
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
): Evidencia {
  const novaEvidencia: Evidencia = {
    id: gerarId(),
    desafioId,
    arquivoNome,
    status: 'pendente',
    enviadoEm: new Date().toISOString(),
  };
  evidencias.push(novaEvidencia);
  return novaEvidencia;
}

export function listarEvidenciasPorDesafio(desafioId: string): Evidencia[] {
  return evidencias.filter((e) => e.desafioId === desafioId);
}

// Reutilizado pelo professor (US5 - Pessoa 3)
export function atualizarStatusEvidencia(
  evidenciaId: string,
  novoStatus: 'aprovada' | 'recusada',
): Evidencia | undefined {
  const ev = evidencias.find((e) => e.id === evidenciaId);
  if (ev) ev.status = novoStatus;
  return ev;
}