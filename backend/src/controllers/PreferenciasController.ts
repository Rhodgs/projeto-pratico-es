// =====================================================
// PreferenciasController.ts
// Gerencia preferências de acessibilidade em memória.
// Rota: PUT /api/usuario/preferencias (US6)
// =====================================================

import { Request, Response } from 'express';

interface PreferenciasAcessibilidade {
  modoEscuro: boolean;
  modoDaltonismo: boolean;
  tamanhoFonte: number;
}

// "Banco de dados" em memória — preferências por usuário
const preferencias: Record<string, PreferenciasAcessibilidade> = {};

// PUT /api/usuario/preferencias
export function salvarPreferencias(req: Request, res: Response): void {
  const { modoEscuro, modoDaltonismo, tamanhoFonte } = req.body;

  // Validação dos campos obrigatórios
  if (typeof modoEscuro !== 'boolean') {
    res.status(400).json({ error: 'O campo "modoEscuro" deve ser booleano.' });
    return;
  }
  if (typeof modoDaltonismo !== 'boolean') {
    res.status(400).json({ error: 'O campo "modoDaltonismo" deve ser booleano.' });
    return;
  }
  if (typeof tamanhoFonte !== 'number' || tamanhoFonte < 12 || tamanhoFonte > 32) {
    res.status(400).json({ error: 'O campo "tamanhoFonte" deve ser um número entre 12 e 32.' });
    return;
  }

  // Salva no array em memória (fixo em 'usuario-default' sem auth)
  const usuarioId = 'usuario-default';
  preferencias[usuarioId] = { modoEscuro, modoDaltonismo, tamanhoFonte };

  res.status(200).json({
    message: 'Preferências salvas com sucesso.',
    preferencias: preferencias[usuarioId],
  });
}

// GET /api/usuario/preferencias (bônus — pra carregar ao abrir a tela)
export function buscarPreferencias(req: Request, res: Response): void {
  const usuarioId = 'usuario-default';
  const prefs = preferencias[usuarioId] ?? {
    modoEscuro: false,
    modoDaltonismo: false,
    tamanhoFonte: 16,
  };

  res.status(200).json(prefs);
}