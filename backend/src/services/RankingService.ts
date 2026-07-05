// backend/src/services/RankingService.ts
import { prisma } from '../../database/prismaClient';
import { redis } from '../../database/redisClient';

// Formato de cada aluno no ranking
export interface RankingAluno {
  id: string;
  nome: string;
  xp: number;
  posicao: number;
}

export class RankingService {
  // -------------------------------------------------------
  // Retorna o Top 5 alunos da turma por XP, usando cache-aside no Redis
  // -------------------------------------------------------
  async buscarTop5(turmaId: string): Promise<RankingAluno[]> {
    const chaveCache = `ranking:turma:${turmaId}`;

    // 1) Tenta buscar no Redis primeiro
    const cache = await redis.get(chaveCache);
    if (cache) {
      return JSON.parse(cache);
    }

    // 2) Não achou no cache: calcula no Postgres
    const turma = await prisma.turma.findUnique({
      where: { id: turmaId },
      include: {
        alunos: {
          select: { id: true, nome: true, xp: true },
          orderBy: { xp: 'desc' },
        },
      },
    });

    if (!turma) {
      throw new Error('Turma não encontrada.');
    }

    const top5: RankingAluno[] = turma.alunos
      .slice(0, 5)
      .map((aluno, index) => ({
        id: aluno.id,
        nome: aluno.nome,
        xp: aluno.xp,
        posicao: index + 1,
      }));

    // 3) Salva no Redis por 5 minutos (300 segundos)
    await redis.setex(chaveCache, 300, JSON.stringify(top5));

    return top5;
  }

  // -------------------------------------------------------
  // Calcula a posição de um aluno específico na turma (mesmo fora do Top 5)
  // Não usa cache: sempre calcula na hora, é uma consulta simples.
  // -------------------------------------------------------
  async buscarPosicaoDoAluno(turmaId: string, alunoId: string): Promise<RankingAluno | null> {
    const turma = await prisma.turma.findUnique({
      where: { id: turmaId },
      include: {
        alunos: {
          select: { id: true, nome: true, xp: true },
          orderBy: { xp: 'desc' },
        },
      },
    });

    if (!turma) {
      throw new Error('Turma não encontrada.');
    }

    const indice = turma.alunos.findIndex((a) => a.id === alunoId);
    if (indice === -1) {
      return null; // aluno não pertence a essa turma
    }

    const aluno = turma.alunos[indice];
    return {
      id: aluno.id,
      nome: aluno.nome,
      xp: aluno.xp,
      posicao: indice + 1,
    };
  }

  // -------------------------------------------------------
  // Invalida o cache do ranking de uma turma (chamado quando o XP de alguém muda)
  // -------------------------------------------------------
  async invalidarCache(turmaId: string): Promise<void> {
    await redis.del(`ranking:turma:${turmaId}`);
  }
}

export const rankingService = new RankingService();