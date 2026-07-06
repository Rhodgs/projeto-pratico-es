import { prisma } from '../../database/prismaClient';
import { redis } from '../../database/redisClient';

export class DesafiosService {
  // 1) Busca todas as evidências que estão aguardando aprovação do professor
  async listarPendentes() {
    return await prisma.evidencia.findMany({
      where: {
        status: 'pendente',
      },
      include: {
        aluno: {
          select: {
            id: true,
            nome: true,
          },
        },
        desafio: true,
      },
    });
  }

  // 2) Aprova a foto enviada, concede XP ao aluno e limpa o cache do ranking
  async aprovarEvidencia(evidenciaId: string) {
    const evidencia = await prisma.evidencia.findUnique({
      where: { id: evidenciaId },
      include: { desafio: true },
    });

    if (!evidencia) {
      throw new Error('Evidência não encontrada.');
    }

    // Altera o status da evidência para aprovada no banco de dados
    const evidenciaAtualizada = await prisma.evidencia.update({
      where: { id: evidenciaId },
      data: { status: 'aprovada' },
    });

    // Soma a pontuação do desafio diretamente no perfil do aluno
    await prisma.usuario.update({
      where: { id: evidencia.alunoId },
      data: {
        xp: {
          increment: evidencia.desafio.pontuacao,
        },
      },
    });

    // Busca as turmas do aluno para limpar o cache do ranking delas no Redis
    try {
      const alunoComTurmas = await prisma.usuario.findUnique({
        where: { id: evidencia.alunoId },
        include: { turmas: true },
      });

      if (alunoComTurmas && alunoComTurmas.turmas) {
        for (const turma of alunoComTurmas.turmas) {
          await redis.del(`ranking:turma:${turma.id}`);
        }
      }
    } catch (cacheError) {
      console.error('Erro ao limpar cache do Redis:', cacheError);
    }

    return evidenciaAtualizada;
  }

  // 3) Recusa a evidência e exige uma justificativa obrigatória
  async recusarEvidencia(evidenciaId: string, justificativa: string) {
    if (!justificativa || justificativa.trim() === '') {
      throw new Error('A justificativa é obrigatória para recusar uma evidência.');
    }

    const evidencia = await prisma.evidencia.findUnique({
      where: { id: evidenciaId },
    });

    if (!evidencia) {
      throw new Error('Evidência não encontrada.');
    }

    return await prisma.evidencia.update({
      where: { id: evidenciaId },
      data: {
        status: 'recusada',
        justificativa: justificativa,
      },
    });
  }
}