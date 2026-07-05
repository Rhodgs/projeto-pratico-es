// backend/src/controllers/DesafioController.ts
import { Request, Response } from 'express';
import {
  DesafioService,
  buscarDesafioPorId,
  adicionarEvidencia,
  listarEvidenciasPorDesafio,
} from '../services/DesafiosService';
import { prisma } from '../../database/prismaClient';

// 
// ESTILO 1 — CLASSE (US10/US11: criação de desafio pelo
// professor + aprovação/recusa de evidências)
// 
export class DesafioController {

  async criar(req: Request, res: Response): Promise<Response> {
    try {
      const { titulo, descricao, pontuacao, prazoLimite } = req.body;

      // Validações básicas (trazidas do service para o controller)
      if (!titulo || titulo.trim() === '' || !descricao || descricao.trim() === '') {
        return res.status(400).json({ error: 'Erro: Campos obrigatórios vazios.' });
      }

      const agora = new Date();
      const prazo = new Date(prazoLimite);

      if (prazo < agora) {
        return res.status(400).json({ error: 'Erro: Prazo no passado.' });
      }

      if (Math.abs(prazo.getTime() - agora.getTime()) < 60000) {
        return res.status(400).json({ error: 'Erro: Prazo precisa dar um tempo mínimo útil de duração.' });
      }

      // Criação direta no banco via Prisma
      const novoDesafio = await prisma.desafio.create({
        data: {
          titulo: titulo.trim(),
          descricao: descricao.trim(),
          pontuacao: Number(pontuacao),
          prazoLimite: prazo,
        },
      });

      return res.status(201).json({
        message: 'Desafio cadastrado com sucesso e fica disponível para os alunos da turma.',
        desafio: novoDesafio
      });
    } catch (error: any) {
      return res.status(400).json({ error: error.message });
    }
  }

  // Novo método para listar direto do banco
  async listar(req: Request, res: Response): Promise<Response> {
    try {
      const lista = await prisma.desafio.findMany({
        orderBy: {
          criadoEm: 'desc' // Os mais novos primeiro
        }
      });
      return res.status(200).json(lista);
    } catch (error: any) {
      return res.status(400).json({ error: error.message });
    }
  }

  async aprovar(req: Request, res: Response): Promise<Response> {
    try {
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

// -------------------------------------------------------------
// REESCRITO (Pessoa 2): agora recebe a FOTO de verdade (via multer)
// e salva no Postgres via Prisma, em vez de só o nome do arquivo
// num array em memória.
// -------------------------------------------------------------
export async function anexarEvidencia(req: Request, res: Response): Promise<Response> {
  try {
    const desafioId = Array.isArray(req.params.id) ? req.params.id[0] : req.params.id;

    // TEMPORÁRIO: substituir por req.usuario.id quando o login
    // (Pessoa 1) estiver pronto. Por enquanto, o aluno manda o
    // próprio ID junto no corpo do formulário (multipart/form-data).
    const alunoId = req.body.alunoId;

    if (!alunoId) {
      return res.status(400).json({ error: 'alunoId é obrigatório.' });
    }

    // multer já processou o arquivo antes desta função rodar
    // (ver server.ts: a rota usa o middleware uploadEvidencia.single('foto'))
    if (!req.file) {
      return res.status(400).json({ error: 'É obrigatório enviar uma foto como evidência.' });
    }

    // Confirma que o desafio existe de verdade no banco
    const desafio = await prisma.desafio.findUnique({ where: { id: desafioId } });
    if (!desafio) {
      return res.status(404).json({ error: 'Desafio não encontrado.' });
    }

    // Confirma que o aluno existe de verdade no banco
    const aluno = await prisma.usuario.findUnique({ where: { id: alunoId } });
    if (!aluno) {
      return res.status(404).json({ error: 'Aluno não encontrado.' });
    }

    // Salva a evidência no Postgres, com o caminho do arquivo salvo em disco
    const novaEvidencia = await prisma.evidencia.create({
      data: {
        desafioId,
        alunoId,
        arquivoUrl: req.file.path,
        status: 'pendente',
      },
    });

    return res.status(201).json({
      message: 'Evidência enviada com sucesso e aguardando validação do professor.',
      evidencia: novaEvidencia,
    });
  } catch (error: any) {
    return res.status(400).json({ error: error.message });
  }
}

export async function listarEvidencias(req: Request, res: Response): Promise<Response> {
  try {
    const desafioId = Array.isArray(req.params.id) ? req.params.id[0] : req.params.id;

    const desafio = await prisma.desafio.findUnique({ where: { id: desafioId } });
    if (!desafio) {
      return res.status(404).json({ error: 'Desafio não encontrado.' });
    }

    const lista = await prisma.evidencia.findMany({ where: { desafioId } });
    return res.status(200).json(lista);
  } catch (error: any) {
    return res.status(400).json({ error: error.message });
  }
}