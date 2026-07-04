// backend/src/controllers/RankingController.ts
import { Request, Response } from 'express';
import { rankingService } from '../services/RankingService';

export class RankingController {
  // GET /turmas/:id/ranking?alunoId=xxx
  async buscarRanking(req: Request, res: Response): Promise<Response> {
    try {
      const turmaId = Array.isArray(req.params.id) ? req.params.id[0] : req.params.id;
      const alunoId = req.query.alunoId as string | undefined;

      const top5 = await rankingService.buscarTop5(turmaId);

      // Se o front mandou o alunoId de quem está pedindo, calcula a posição dele também
      let posicaoDoAluno = null;
      if (alunoId) {
        posicaoDoAluno = await rankingService.buscarPosicaoDoAluno(turmaId, alunoId);
      }

      return res.status(200).json({
        top5,
        posicaoDoAluno,
      });
    } catch (error: any) {
      return res.status(400).json({ error: error.message });
    }
  }
}

export const rankingController = new RankingController();