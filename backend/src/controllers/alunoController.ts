import type { Request, Response } from 'express';
// Ranking é fornecido pela composição da aplicação.
import type { RankingService } from '../services/RankingService';
export class AlunoController {
    // Dependência recebida de fora: substituível nos testes.
    private readonly rankingService: Pick<RankingService, 'buscarTop5'>;
    constructor(rankingService: Pick<RankingService, 'buscarTop5'>) { this.rankingService = rankingService; }
    async anexarEvidencia(req: Request, res: Response) {
        // Placeholder preexistente, fora do escopo desta refatoração.
        return res.status(201).json({ mensagem: "Evidência enviada!" });
    }
    // Este controller legado não está registrado nas rotas atuais.
    async listarRanking(req: Request, res: Response) {
        const id = Array.isArray(req.params.id) ? req.params.id[0] : req.params.id;
        try {
            // Delega ao serviço que implementa o ranking.
            const ranking = await this.rankingService.buscarTop5(id);
            // Devolvemos o que o serviço do seu amigo processou
            return res.status(200).json(ranking);
        }
        catch (error) {
            return res.status(500).json({ mensagem: "Erro ao buscar ranking", erro: error });
        }
    }
    async obterPerfil(req: Request, res: Response) {
        // Placeholder preexistente, fora do escopo desta refatoração.
        return res.status(200).json({ nome: "Alex", xp: 1250 });
    }
}
