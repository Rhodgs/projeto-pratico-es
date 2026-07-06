import { Request, Response } from 'express';
import { DesafiosService } from '../services/DesafiosService';
import { prisma } from '../../database/prismaClient';

// Instância reativada para processar as regras de XP, inclusões e cache do Redis
const desafiosService = new DesafiosService();

export class DesafioController {
  // Criação de novos desafios (Mantido do esqueleto original do time)
  async criar(req: Request, res: Response): Promise<Response> {
    try {
      const { titulo, descricao, pontuacao, prazoLimite } = req.body;

      const tituloClean = Array.isArray(titulo) ? titulo[0] : titulo;
      const descricaoClean = Array.isArray(descricao) ? descricao[0] : descricao;

      if (!tituloClean || !descricaoClean) {
        return res.status(400).json({ error: 'Campos obrigatórios vazios.' });
      }

      const novoDesafio = await prisma.desafio.create({
        data: {
          titulo: String(tituloClean).trim(),
          descricao: String(descricaoClean).trim(),
          pontuacao: Number(pontuacao),
          prazoLimite: new Date(prazoLimite)
        }
      });

      return res.status(201).json({
        mensagem: 'Desafio cadastrado com sucesso!',
        desafio: novoDesafio
      });
    } catch (error) {
      return res.status(500).json({ error: 'Erro ao criar desafio.', details: error });
    }
  }

  // Listagem de todos os desafios (Mantido do esqueleto original do time)
  async listar(_req: Request, res: Response): Promise<Response> {
    try {
      const lista = await prisma.desafio.findMany({
        orderBy: { criadoEm: 'desc' }
      });
      return res.status(200).json(lista);
    } catch (error) {
      return res.status(500).json({ error: 'Erro ao listar desafios.' });
    }
  }

  // 2) Rota: POST /api/evidencias/:id/aprovar
  async aprovar(req: Request, res: Response): Promise<Response> {
    try {
      const id = Array.isArray(req.params.id) ? req.params.id[0] : req.params.id;
      
      // Chama o serviço que altera o status, dá XP ao aluno e limpa o cache do Redis
      const referenciaAtualizada = await desafiosService.aprovarEvidencia(id);

      return res.status(200).json({
        message: 'Evidência aprovada com sucesso! XP adicionado e ranking atualizado.',
        evidencia: referenciaAtualizada
      });
    } catch (error) {
      return res.status(500).json({ 
        error: 'Erro ao aprovar evidência.',
        details: error instanceof Error ? error.message : error 
      });
    }
  }

  // 3) Rota: POST /api/evidencias/:id/recusar
  async recusar(req: Request, res: Response): Promise<Response> {
    try {
      const id = Array.isArray(req.params.id) ? req.params.id[0] : req.params.id;
      const { justificativa } = req.body;
      const justificativaClean = Array.isArray(justificativa) ? justificativa[0] : justificativa;

      // Chama o serviço que valida a justificativa obrigatória e recusa no banco
      const referenciaRecusada = await desafiosService.recusarEvidencia(id, String(justificativaClean || ''));

      return res.status(200).json({
        message: 'Evidência recusada e justificativa registrada com sucesso.',
        evidencia: referenciaRecusada
      });
    } catch (error) {
      return res.status(400).json({ 
        error: 'Erro ao recusar microware/evidência.', 
        details: error instanceof Error ? error.message : error 
      });
    }
  }
}

// 1) Rota: GET /api/evidencias/pendentes
export async function listarEvidencias(_req: Request, res: Response): Promise<Response> {
  try {
    // Utiliza o método do serviço que já inclui os dados do Aluno e do Desafio com segurança
    const evidencias = await desafiosService.listarPendentes();
    return res.status(200).json(evidencias);
  } catch (error) {
    return res.status(500).json({ 
      error: 'Erro ao buscar evidências pendentes.',
      details: error instanceof Error ? error.message : error 
    });
  }
}

// Rota da Pessoa 2: POST /api/desafios/evidencia (Mantida intacta para o seu time)
export async function anexarEvidencia(req: Request, res: Response): Promise<Response> {
  try {
    const { desafioId, alunoId } = req.body;

    const novaEvidencia = await prisma.evidencia.create({
      data: {
        desafioId,
        alunoId,
        status: 'pendente'
      }
    });

    return res.status(201).json({
      message: 'Evidência enviada com sucesso e aguardando validação do professor.',
      evidencia: novaEvidencia
    });
  } catch (error) {
    return res.status(500).json({ 
      error: 'Erro ao anexar evidência.', 
      details: error instanceof Error ? error.message : error 
    });
  }
}