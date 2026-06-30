// =====================================================
// TurmaController.ts
// =====================================================

import { Request, Response } from 'express';
import { turmaService } from '../services/TurmaService';

// POST /api/turmas
export function criarTurma(req: Request, res: Response): void {
  const { nome, professorId } = req.body;

  if (!nome || typeof nome !== 'string' || nome.trim() === '') {
    res.status(400).json({ error: 'O campo "nome" é obrigatório.' });
    return;
  }

  // professorId fixo por enquanto (sem auth implementada ainda)
  const idProfessor = professorId ?? 'professor-default';

  try {
    const turma = turmaService.criarTurma(nome, idProfessor);

    res.status(201).json({
      id: turma.id,
      nome: turma.nome,
      codigo: turma.codigo,
      criadaEm: turma.criadaEm,
    });
  } catch (error: unknown) {
    const message = error instanceof Error ? error.message : 'Erro interno.';

    // RN01 e RN02 são erros de negócio → 422
    const isBusinessRule = message.startsWith('Erro:');
    res.status(isBusinessRule ? 422 : 500).json({ error: message });
  }
}

// GET /api/turmas
export function listarTurmas(req: Request, res: Response): void {
  const { professorId } = req.query;
  const id = typeof professorId === 'string' ? professorId : 'professor-default';
  const turmas = turmaService.listarTurmasDoProfessor(id);
  res.status(200).json(turmas);
}

// DELETE /api/turmas/:id
export function excluirTurma(req: Request, res: Response): void {
  const { id } = req.params;

  const removida = turmaService.excluirTurma(id as string);
  if (!removida) {
    res.status(404).json({ error: 'Turma não encontrada.' });
    return;
  }

  res.status(200).json({ message: 'Turma removida com sucesso.' });
}