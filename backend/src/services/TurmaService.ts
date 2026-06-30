// =====================================================
// TurmaService.ts
// Gerencia o array de turmas em memória.
// Regras de negócio: RN01, RN02, RN03, CA02, CA04
// =====================================================
 
export interface Turma {
  id: string;
  nome: string;
  codigo: string;
  professorId: string;
  alunos: string[];
  criadaEm: Date;
}
 
// "Banco de dados" em memória
const turmas: Turma[] = [];
 
// -------------------------------------------------------
// Gera um código alfanumérico único de 6 caracteres
// Ex: "A3F9KZ"  — garante CA02 (formato) e unicidade
// -------------------------------------------------------
function gerarCodigoUnico(): string {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  let tentativas = 0;
 
  while (tentativas < 100) {
    let codigo = '';
    for (let i = 0; i < 6; i++) {
      codigo += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    const jaExiste = turmas.some((t) => t.codigo === codigo);
    if (!jaExiste) return codigo;
    tentativas++;
  }
 
  throw new Error('Não foi possível gerar um código único. Tente novamente.');
}
 
export class TurmaService {
  // -------------------------------------------------------
  // Valida as regras ANTES de criar — usado nos testes
  // (mantido do seu código original: RN01, RN02, CA02)
  // -------------------------------------------------------
  validarCriacaoTurma(
    perfilUsuario: string,
    qtdTurmasAtuais: number,
    codigoGerado: string,
  ): string {
    // RN01 - Apenas professores podem criar turmas
    if (perfilUsuario !== 'Professor') {
      return 'Erro: Apenas professores podem criar turmas.';
    }
 
    // RN02 - Limite de 10 turmas ativas por professor
    if (qtdTurmasAtuais >= 10) {
      return 'Erro: Limite máximo de 10 turmas atingido.';
    }
 
    // CA02 - Código deve ter exatamente 6 caracteres
    if (codigoGerado.length !== 6) {
      return 'Erro: O código deve ter exatamente 6 caracteres.';
    }
 
    // CA02 - Código deve ser alfanumérico em caixa alta
    const regex = /^[A-Z0-9]+$/;
    if (!regex.test(codigoGerado)) {
      return 'Erro: O código deve conter apenas letras maiúsculas e números.';
    }
 
    return 'Sucesso: Turma criada com o código ' + codigoGerado;
  }
 
  // -------------------------------------------------------
  // Cria a turma de fato no array (chamado pelo controller)
  // -------------------------------------------------------
  criarTurma(nome: string, professorId: string): Turma {
    // Conta quantas turmas esse professor já tem (para RN02)
    const qtdAtual = turmas.filter((t) => t.professorId === professorId).length;
 
    const codigo = gerarCodigoUnico();
 
    // Roda as validações — lança erro se alguma falhar
    const resultado = this.validarCriacaoTurma('Professor', qtdAtual, codigo);
    if (resultado.startsWith('Erro')) {
      throw new Error(resultado);
    }
 
    const novaTurma: Turma = {
      id: Date.now().toString(),
      nome: nome.trim(),
      codigo,
      professorId,
      alunos: [],
      criadaEm: new Date(),
    };
 
    turmas.push(novaTurma);
    return novaTurma;
  }
 
  // -------------------------------------------------------
  // Lista turmas de um professor específico
  // -------------------------------------------------------
  listarTurmasDoProfessor(professorId: string): Turma[] {
    return turmas.filter((t) => t.professorId === professorId);
  }
 
  // -------------------------------------------------------
  // Exclusão com confirmação (RN03, CA04)
  // -------------------------------------------------------
  solicitarExclusaoTurma(confirmacaoDoUsuario: boolean): string {
    // CA04 - Aviso antes de confirmar
    if (!confirmacaoDoUsuario) {
      return 'Aviso: Esta ação desvinculará todos os alunos. O histórico será arquivado por 90 dias. Confirmar?';
    }
 
    // RN03 - Exclusão efetivada após confirmação
    return 'Sucesso: Turma excluída direto.';
  }
 
  excluirTurma(id: string): boolean {
    const index = turmas.findIndex((t) => t.id === id);
    if (index === -1) return false;
    turmas.splice(index, 1);
    return true;
  }
 
  // -------------------------------------------------------
  // Busca por código (para aluno entrar na turma)
  // -------------------------------------------------------
  buscarTurmaPorCodigo(codigo: string): Turma | undefined {
    return turmas.find((t) => t.codigo === codigo.toUpperCase());
  }
}
 
// Instância singleton para o controller usar
export const turmaService = new TurmaService();
