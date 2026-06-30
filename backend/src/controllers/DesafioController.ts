// backend/src/controllers/DesafioController.ts
import { Request, Response } from 'express';
import {
  DesafioService,
  buscarDesafioPorId,
  adicionarEvidencia,
  listarEvidenciasPorDesafio,
} from '../services/DesafiosService';

// 
// ESTILO 1 — CLASSE (US10/US11: criação de desafio pelo
// professor + aprovação/recusa de evidências)
// 
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
      // Renomeado de const { id } para const { evidenciaId }
      const evidenciaId = Array.isArray(req.params.evidenciaId) ? req.params.evidenciaId[0] : req.params.evidenciaId;
      const evidenciaAtualizada = DesafioService.aprovarEvidencia(evidenciaId as string);
      
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
      // Renomeado de const { id } para const { evidenciaId }
      const evidenciaId = Array.isArray(req.params.evidenciaId) ? req.params.evidenciaId[0] : req.params.evidenciaId;
      const { justificativa } = req.body;
      const evidenciaAtualizada = DesafioService.recusarEvidencia(evidenciaId as string, justificativa);
      
      return res.status(200).json({
        message: 'Missão recusada com sucesso.',
        evidencia: evidenciaAtualizada
      });
    } catch (error: any) {
      return res.status(400).json({ error: error.message });
    }
  }
}

// 
// ESTILO 2 — FUNÇÕES SOLTAS (US4: aluno anexa evidência a um
// desafio e consulta as evidências enviadas)
// 

export async function anexarEvidencia(req: Request, res: Response): Promise<Response> {
  try {
    const id = Array.isArray(req.params.id) ? req.params.id[0] : req.params.id;
    const { arquivoNome, alunoId, alunoNome } = req.body;

    const desafio = buscarDesafioPorId(id);
    if (!desafio) {
      return res.status(404).json({ error: 'Desafio não encontrado.' });
    }

    if (!arquivoNome || !arquivoNome.trim()) {
      return res.status(400).json({ error: 'Nome do arquivo é obrigatório.' });
    }

    const novaEvidencia = adicionarEvidencia(id, arquivoNome, alunoId, alunoNome);

    return res.status(201).json({
      message: 'Evidência enviada com sucesso e aguardando validação do professor.',
      evidencia: novaEvidencia
    });
  } catch (error: any) {
    return res.status(400).json({ error: error.message });
  }
}

export async function listarEvidencias(req: Request, res: Response): Promise<Response> {
  try {
    const id = Array.isArray(req.params.id) ? req.params.id[0] : req.params.id;

    const desafio = buscarDesafioPorId(id);
    if (!desafio) {
      return res.status(404).json({ error: 'Desafio não encontrado.' });
    }

    const lista = listarEvidenciasPorDesafio(id);
    return res.status(200).json(lista);
  } catch (error: any) {
    return res.status(400).json({ error: error.message });
  }
}