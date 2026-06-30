import { Request, Response } from 'express';
import * as DesafioService from '../services/DesafioService';

// POST /api/desafios/:id/evidencias
export function anexarEvidencia(req: Request, res: Response): void {
  const { id } = req.params;
  const { arquivoNome } = req.body;

  if (!arquivoNome || typeof arquivoNome !== 'string' || !arquivoNome.trim()) {
    res.status(400).json({ error: 'O campo "arquivoNome" é obrigatório.' });
    return;
  }

  const desafio = DesafioService.buscarDesafioPorId(id);
  if (!desafio) {
    res.status(404).json({ error: `Desafio "${id}" não encontrado.` });
    return;
  }

  const evidencia = DesafioService.adicionarEvidencia(id, arquivoNome.trim());

  res.status(201).json({
    mensagem: 'Evidência anexada com sucesso!',
    evidencia,
  });
}

// GET /api/desafios/:id/evidencias  (útil para debug / professor)
export function listarEvidencias(req: Request, res: Response): void {
  const { id } = req.params;

  const desafio = DesafioService.buscarDesafioPorId(id);
  if (!desafio) {
    res.status(404).json({ error: `Desafio "${id}" não encontrado.` });
    return;
  }

  const evidencias = DesafioService.listarEvidenciasPorDesafio(id);
  res.status(200).json({ desafioId: id, evidencias });
}