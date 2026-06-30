// backend/src/controllers/DesafioController.ts
import { Request, Response } from 'express';
import { DesafioService } from '../services/DesafiosService';

export class DesafioController {

  async criar(req: Request, res: Response): Promise<Response> {
    try {
      const { titulo, descricao, pontuacao, prazoLimite } = req.body;
      const novoDesafio = DesafioService.criarDesafio({ titulo, descricao, pontuacao, prazoLimite });
      
      return res.status(201).json({
        message: 'Desafio cadastrado com sucesso e fica disponível para os alunos da turma.',
        desafio: novoDesafio
      });
    } catch (error: any) {
      return res.status(400).json({ error: error.message });
    }
  }

  async aprovar(req: Request, res: Response): Promise<Response> {
    try {
      const id = Array.isArray(req.params.id) ? req.params.id[0] : req.params.id;
      const evidenciaAtualizada = DesafioService.aprovarEvidencia(id);
      
      return res.status(200).json({
        message: 'Todo o fluxo funciona, a justificativa é cobrada e os pontos da missão aprovada vão para o saldo do aluno.',
        evidencia: evidenciaAtualizada
      });
    } catch (error: any) {
      return res.status(400).json({ error: error.message });
    }
  }

  async recusar(req: Request, res: Response): Promise<Response> {
    try {
      const id = Array.isArray(req.params.id) ? req.params.id[0] : req.params.id;
      const { justificativa } = req.body;
      const evidenciaAtualizada = DesafioService.recusarEvidencia(id, justificativa);
      
      return res.status(200).json({
        message: 'Missão recusada com sucesso.',
        evidencia: evidenciaAtualizada
      });
    } catch (error: any) {
      return res.status(400).json({ error: error.message });
    }
  }
}