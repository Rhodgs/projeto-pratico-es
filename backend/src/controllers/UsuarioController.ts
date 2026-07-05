import { Request, Response } from 'express';
import { prisma } from '../../database/prismaClient';

export class UsuarioController {
  // GET /api/usuario/perfil?id=...
  async buscarPerfil(req: Request, res: Response): Promise<Response> {
    try {
      const usuarioId = req.query.id as string | undefined;
      if (!usuarioId) {
        return res.status(400).json({ error: 'Parâmetro id é obrigatório.' });
      }

      const usuario = await prisma.usuario.findUnique({
        where: { id: usuarioId },
        select: {
          id: true,
          nome: true,
          email: true,
          perfil: true,
          turmas: {
            select: { id: true, nome: true, codigo: true },
          },
        },
      });

      if (!usuario) {
        return res.status(404).json({ error: 'Usuário não encontrado.' });
      }

      return res.status(200).json({ usuario });
    } catch (error: any) {
      return res.status(500).json({ error: error.message || 'Erro ao buscar perfil.' });
    }
  }
}

export const usuarioController = new UsuarioController();