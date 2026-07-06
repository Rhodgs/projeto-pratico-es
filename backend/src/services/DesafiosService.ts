// backend/src/services/DesafiosService.ts
import { prisma } from '../../database/prismaClient';
import { redis } from '../../database/redisClient';

export class DesafiosService {
  // Busca todas as evidências que estão aguardando aprovação do professor
  // (de qualquer desafio, usado na visão geral do professor)
  async listarPendentes() {
    return await prisma.evidencia.findMany({
      where: { status: 'pendente' },
      include: {
        aluno: { select: { id: true, nome: true } },
        desafio: true,
      },
    });
  }

  // Aprova a evidência, concede XP ao aluno e limpa o cache do ranking
  async aprovarEvidencia(evidenciaId: string) {
    const evidencia = await prisma.evidencia.findUnique({
      where: { id: evidenciaId },
      include: { desafio: true },
    });

    if (!evidencia) {
      throw new Error('Evidência não encontrada.');
    }

    const evidenciaAtualizada = await prisma.evidencia.update({
      where: { id: evidenciaId },
      data: { status: 'aprovada' },
    });

    // Soma a pontuação do desafio ao XP do aluno
    await prisma.usuario.update({
      where: { id: evidencia.alunoId },
      data: {
        xp: { increment: evidencia.desafio.pontuacao },
      },
    });

    // Limpa o cache do ranking de todas as turmas do aluno
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

  // Recusa a evidência, exigindo justificativa obrigatória
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
        justificativa,
      },
    });
  }
}