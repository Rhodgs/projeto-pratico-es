import type { Request, Response } from 'express';
import type { PrismaClient } from '@prisma/client';
import type { DesafiosService } from '../services/DesafiosService';
import type { EntradaCriacaoDesafio } from '../services/ValidacaoCriacaoDesafio';
export interface DependenciasDesafio {
    criacao: {
        criar(entrada: EntradaCriacaoDesafio): Promise<unknown>;
    };
    desafios: Pick<DesafiosService, 'aprovarEvidencia' | 'recusarEvidencia' | 'listarPendentes'>;
    db: Pick<PrismaClient, 'desafio' | 'usuario' | 'evidencia'>;
}
export class DesafioController {
    private readonly deps: DependenciasDesafio;
    constructor(deps: DependenciasDesafio) { this.deps = deps; }
    async criar(req: Request, res: Response): Promise<Response> {
        try {
            const { titulo, descricao, pontuacao, prazoLimite } = req.body;
            const novoDesafio = await this.deps.criacao.criar({ titulo, descricao, pontuacao, prazoLimite });
            return res.status(201).json({
                message: 'Desafio cadastrado com sucesso e fica disponível para os alunos da turma.',
                desafio: novoDesafio
            });
        }
        catch (error: any) {
            return res.status(400).json({ error: error.message });
        }
    }
    async listar(req: Request, res: Response): Promise<Response> {
        try {
            const lista = await this.deps.db.desafio.findMany({
                orderBy: { criadoEm: 'desc' }
            });
            return res.status(200).json(lista);
        }
        catch (error: any) {
            return res.status(400).json({ error: error.message });
        }
    }
    // Aprova a evidência, dá XP ao aluno e limpa o cache do ranking (feito pela Pessoa 3)
    async aprovar(req: Request, res: Response): Promise<Response> {
        try {
            const id = Array.isArray(req.params.id) ? req.params.id[0] : req.params.id;
            const evidenciaAtualizada = await this.deps.desafios.aprovarEvidencia(id as string);
            return res.status(200).json({
                message: 'Evidência aprovada com sucesso! XP adicionado e ranking atualizado.',
                evidencia: evidenciaAtualizada
            });
        }
        catch (error: any) {
            return res.status(400).json({ error: error.message });
        }
    }
    async recusar(req: Request, res: Response): Promise<Response> {
        try {
            const id = Array.isArray(req.params.id) ? req.params.id[0] : req.params.id;
            const { justificativa } = req.body;
            const evidenciaAtualizada = await this.deps.desafios.recusarEvidencia(id as string, justificativa);
            return res.status(200).json({
                message: 'Evidência recusada e justificativa registrada com sucesso.',
                evidencia: evidenciaAtualizada
            });
        }
        catch (error: any) {
            return res.status(400).json({ error: error.message });
        }
    }
    // -------------------------------------------------------------
    // Envio de evidência com FOTO real (via multer) + Prisma — Pessoa 2
    // -------------------------------------------------------------
    async anexarEvidencia(req: Request, res: Response): Promise<Response> {
        try {
            const desafioId = Array.isArray(req.params.id) ? req.params.id[0] : req.params.id;
            // TEMPORÁRIO: substituir por req.usuario.id quando o login (Pessoa 1) estiver pronto.
            const alunoId = req.body.alunoId;
            if (!alunoId) {
                return res.status(400).json({ error: 'alunoId é obrigatório.' });
            }
            if (!req.file) {
                return res.status(400).json({ error: 'É obrigatório enviar uma foto como evidência.' });
            }
            const desafio = await this.deps.db.desafio.findUnique({ where: { id: desafioId } });
            if (!desafio) {
                return res.status(404).json({ error: 'Desafio não encontrado.' });
            }
            const aluno = await this.deps.db.usuario.findUnique({ where: { id: alunoId } });
            if (!aluno) {
                return res.status(404).json({ error: 'Aluno não encontrado.' });
            }
            const novaEvidencia = await this.deps.db.evidencia.create({
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
        }
        catch (error: any) {
            return res.status(400).json({ error: error.message });
        }
    }
    // Lista as evidências de UM desafio específico (Pessoa 2) — GET /api/desafios/:id/evidencias
    async listarEvidencias(req: Request, res: Response): Promise<Response> {
        try {
            const desafioId = Array.isArray(req.params.id) ? req.params.id[0] : req.params.id;
            const desafio = await this.deps.db.desafio.findUnique({ where: { id: desafioId } });
            if (!desafio) {
                return res.status(404).json({ error: 'Desafio não encontrado.' });
            }
            const lista = await this.deps.db.evidencia.findMany({ where: { desafioId } });
            return res.status(200).json(lista);
        }
        catch (error: any) {
            return res.status(400).json({ error: error.message });
        }
    }
    // Lista TODAS as evidências pendentes, de qualquer desafio (Pessoa 3) — GET /api/evidencias/pendentes
    async listarEvidenciasPendentes(req: Request, res: Response): Promise<Response> {
        try {
            const evidencias = await this.deps.desafios.listarPendentes();
            return res.status(200).json(evidencias);
        }
        catch (error: any) {
            return res.status(500).json({
                error: 'Erro ao buscar evidências pendentes.',
                details: error.message,
            });
        }
    }
}
