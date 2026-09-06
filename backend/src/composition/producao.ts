import bcrypt from 'bcrypt';
import { prisma } from '../../database/prismaClient';
import { CadastroService } from '../services/CadastroService';
import { TurmaService } from '../services/TurmaService';
import { rankingService } from '../services/RankingService';
import { DesafiosService } from '../services/DesafiosService';
import { CriacaoDesafioFacade } from '../services/CriacaoDesafioFacade';
import { PrismaCriacaoDesafioRepository } from '../repositories/PrismaCriacaoDesafioRepository';
import { CriadorAluno, CriadorProfessor } from '../factories/CriadorUsuario';
import { montarControllers } from './controllers';
// Chamado uma vez pelo servidor. Os controllers reutilizam os serviços durante
// a vida desta aplicação; isso não impõe Singleton GoF às classes de serviço.
export function criarControllersProducao() {
    return montarControllers({
        cadastro: new CadastroService({
            db: prisma,
            senhas: {
                hash: (senha, rounds) => bcrypt.hash(senha, rounds),
                compare: (senha, hash) => bcrypt.compare(senha, hash),
            },
            criadores: { Aluno: new CriadorAluno(), Professor: new CriadorProfessor() },
        }),
        turmas: new TurmaService(),
        ranking: rankingService,
        desafio: {
            criacao: new CriacaoDesafioFacade(new PrismaCriacaoDesafioRepository()),
            desafios: new DesafiosService(),
            db: prisma,
        },
    });
}
