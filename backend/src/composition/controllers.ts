import { AuthController } from '../controllers/AuthController';
import { TurmaController } from '../controllers/TurmaController';
import { AlunoController } from '../controllers/alunoController';
import { DesafioController } from '../controllers/DesafioController';
export interface ServicosControllers {
    cadastro: ConstructorParameters<typeof AuthController>[0];
    turmas: ConstructorParameters<typeof TurmaController>[0];
    ranking: ConstructorParameters<typeof AlunoController>[0];
    desafio: ConstructorParameters<typeof DesafioController>[0];
}
// Composition root dos controllers deste escopo; não é Factory Method GoF.
export function montarControllers(servicos: ServicosControllers) {
    return {
        authController: new AuthController(servicos.cadastro),
        turmaController: new TurmaController(servicos.turmas),
        alunoController: new AlunoController(servicos.ranking),
        desafioController: new DesafioController(servicos.desafio),
    };
}
