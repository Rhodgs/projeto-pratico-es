import { prisma } from '../../database/prismaClient';
import type { DadosNovoDesafio } from '../services/ValidacaoCriacaoDesafio';

export class PrismaCriacaoDesafioRepository {
  criar(dados: DadosNovoDesafio) {
    return prisma.desafio.create({ data: dados });
  }
}
