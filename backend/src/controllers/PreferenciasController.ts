// =====================================================
// PreferenciasController.ts
// Gerencia preferências de acessibilidade usando Prisma.
// Rotas:
//  PUT /api/usuario/preferencias?id=...
//  GET /api/usuario/preferencias?id=...
// =====================================================

import { Request, Response } from 'express';
import { prisma } from '../../database/prismaClient';

interface PreferenciasAcessibilidade {
  modoEscuro: boolean;
  modoDaltonismo: boolean;
  tamanhoFonte: number;
}

// PUT /api/usuario/preferencias?id=...
export async function salvarPreferencias(req: Request, res: Response): Promise<void> {
  try {
    const usuarioId = req.query.id as string | undefined;
    if (!usuarioId) {
      res.status(400).json({ error: 'Parâmetro id do usuário é obrigatório.' });
      return;
    }

    const { modoEscuro, modoDaltonismo, tamanhoFonte } = req.body as Partial<PreferenciasAcessibilidade>;

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

    const upsert = await prisma.preferencias.upsert({
      where: { usuarioId },
      update: {
        modoEscuro,
        modoDaltonismo,
        tamanhoFonte,
      },
      create: {
        usuarioId,
        modoEscuro,
        modoDaltonismo,
        tamanhoFonte,
      },
    });

    res.status(200).json({
      message: 'Preferências salvas com sucesso.',
      preferencias: upsert,
    });
  } catch (error: any) {
    res.status(500).json({ error: error.message || 'Erro ao salvar preferências.' });
  }
}

// GET /api/usuario/preferencias?id=...
export async function buscarPreferencias(req: Request, res: Response): Promise<void> {
  try {
    const usuarioId = req.query.id as string | undefined;
    if (!usuarioId) {
      res.status(400).json({ error: 'Parâmetro id do usuário é obrigatório.' });
      return;
    }

    const prefs = await prisma.preferencias.findUnique({
      where: { usuarioId },
    });

    if (!prefs) {
      // retorno padrão caso ainda não exista no DB
      res.status(200).json({
        modoEscuro: false,
        modoDaltonismo: false,
        tamanhoFonte: 16,
      });
      return;
    }

    res.status(200).json(prefs);
  } catch (error: any) {
    res.status(500).json({ error: error.message || 'Erro ao buscar preferências.' });
  }
}