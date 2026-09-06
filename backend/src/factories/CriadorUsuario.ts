export interface DadosBaseUsuario {
    nome: string;
    email: string;
    senha: string;
}
export interface PayloadUsuario extends DadosBaseUsuario {
    perfil: 'Aluno' | 'Professor';
    turmas?: {
        connect: {
            id: string;
        };
    };
}
// Produto comum. O mapeamento dos campos compartilhados existe uma única vez.
export abstract class UsuarioParaCadastro {
    protected readonly dados: DadosBaseUsuario;
    constructor(dados: DadosBaseUsuario) { this.dados = dados; }
    protected abstract especificos(): Pick<PayloadUsuario, 'perfil' | 'turmas'>;
    paraPersistencia(): PayloadUsuario {
        return {
            nome: this.dados.nome,
            email: this.dados.email,
            senha: this.dados.senha,
            ...this.especificos(),
        };
    }
}
export class AlunoParaCadastro extends UsuarioParaCadastro {
    private readonly turmaId: string;
    constructor(dados: DadosBaseUsuario, turmaId: string) {
        super(dados);
        this.turmaId = turmaId;
    }
    protected especificos(): Pick<PayloadUsuario, 'perfil' | 'turmas'> {
        return { perfil: 'Aluno', turmas: { connect: { id: this.turmaId } } };
    }
}
export class ProfessorParaCadastro extends UsuarioParaCadastro {
    protected especificos(): Pick<PayloadUsuario, 'perfil' | 'turmas'> {
        return { perfil: 'Professor' };
    }
}
export abstract class CriadorUsuario {
    // Factory Method: subclasses decidem qual produto concreto construir.
    abstract criarUsuario(dados: DadosBaseUsuario, turmaId?: string): UsuarioParaCadastro;
    preparar(dados: DadosBaseUsuario, turmaId?: string): PayloadUsuario {
        return this.criarUsuario(dados, turmaId).paraPersistencia();
    }
}
export class CriadorAluno extends CriadorUsuario {
    criarUsuario(dados: DadosBaseUsuario, turmaId?: string): UsuarioParaCadastro {
        if (!turmaId)
            throw new Error('Uma turma validada é necessária para criar aluno.');
        return new AlunoParaCadastro(dados, turmaId);
    }
}
export class CriadorProfessor extends CriadorUsuario {
    criarUsuario(dados: DadosBaseUsuario): UsuarioParaCadastro {
        return new ProfessorParaCadastro(dados);
    }
}
