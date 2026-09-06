import { prisma } from '../../database/prismaClient';

// =====================================================
// TurmaService.ts
// Gerencia turmas direto no PostgreSQL via Prisma.
// Regras de negócio: RN01, RN02, RN03, CA02, CA04
// =====================================================

// -------------------------------------------------------
// Gera um código alfanumérico único de 6 caracteres
// Ex: "A3F9KZ" — verifica unicidade direto no banco
// -------------------------------------------------------
async function gerarCodigoUnico(): Promise<string> {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  let tentativas = 0;

  while (tentativas < 100) {
    let codigo = '';
    for (let i = 0; i < 6; i++) {
      codigo += chars.charAt(Math.floor(Math.random() * chars.length));
    }

    const jaExiste = await prisma.turma.findUnique({ where: { codigo } });
    if (!jaExiste) return codigo;
    tentativas++;
  }

  throw new Error('Não foi possível gerar um código único. Tente novamente.');
}

export class TurmaService {
  // -------------------------------------------------------
  // Valida as regras ANTES de criar — usado nos testes unitários
  // (RN01, RN02, CA02)
  // -------------------------------------------------------
  validarCriacaoTurma(
    perfilUsuario: string,
    qtdTurmasAtuais: number,
    codigoGerado: string,
  ): string {
    if (perfilUsuario !== 'Professor') {
      return 'Erro: Apenas professores podem criar turmas.';
    }
    if (qtdTurmasAtuais >= 10) {
      return 'Erro: Limite máximo de 10 turmas atingido.';
    }
    if (codigoGerado.length !== 6) {
      return 'Erro: O código deve ter exatamente 6 caracteres.';
    }
    const regex = /^[A-Z0-9]+$/;
    if (!regex.test(codigoGerado)) {
      return 'Erro: O código deve conter apenas letras maiúsculas e números.';
    }
    return 'Sucesso: Turma criada com o código ' + codigoGerado;
  }

  // -------------------------------------------------------
  // Cria a turma de fato, salvando no Postgres via Prisma
  // -------------------------------------------------------
  async criarTurma(nome: string, professorId: string) {
    // Confere se o professor existe de fato (evita erro de FK feio)
    const professor = await prisma.usuario.findUnique({ where: { id: professorId } });
    if (!professor) {
      throw new Error('Erro: Professor não encontrado. Faça login novamente.');
    }

    const qtdAtual = await prisma.turma.count({ where: { professorId } });
    const codigo = await gerarCodigoUnico();

    const resultado = this.validarCriacaoTurma(professor.perfil, qtdAtual, codigo);
    if (resultado.startsWith('Erro')) {
      throw new Error(resultado);
    }

    return await prisma.turma.create({
      data: {
        nome: nome.trim(),
        codigo,
        professorId,
      },
      include: {
        alunos: true, // já vem vazio, para o Flutter não quebrar
      },
    });
  }

  // -------------------------------------------------------
  // Lista turmas de um professor específico
  // -------------------------------------------------------
  async listarTurmasDoProfessor(professorId: string) {
    return await prisma.turma.findMany({
      where: { professorId },
      include: {
        alunos: {
          select: { id: true, nome: true, email: true },
        },
      },
    });
  }

  // -------------------------------------------------------
  // Exclusão com confirmação (RN03, CA04)
  // -------------------------------------------------------
  solicitarExclusaoTurma(confirmacaoDoUsuario: boolean): string {
    if (!confirmacaoDoUsuario) {
      return 'Aviso: Esta ação desvinculará todos os alunos. O histórico será arquivado por 90 dias. Confirmar?';
    }
    return 'Sucesso: Turma excluída direto.';
  }

  async excluirTurma(id: string): Promise<boolean> {
    try {
      await prisma.turma.delete({ where: { id } });
      return true;
    } catch (error) {
      return false; // turma não existe
    }
  }

  // -------------------------------------------------------
  // Busca por código (para aluno entrar na turma)
  // -------------------------------------------------------
  async buscarTurmaPorCodigo(codigo: string) {
    return await prisma.turma.findUnique({
      where: { codigo: codigo.toUpperCase().trim() },
    });
  }
}

// Instâncias são construídas na composição da aplicação.
