import type { PrismaClient } from '@prisma/client';
import type { CriadorUsuario } from '../factories/CriadorUsuario';
export interface DadosCadastro {
    nome: string;
    email: string;
    senha?: string;
    perfil: string;
    codigoTurma?: string;
}
export interface Senhas {
    hash(senha: string, rounds: number): Promise<string>;
    compare(senha: string, hash: string): Promise<boolean>;
}
export interface DependenciasCadastro {
    db: Pick<PrismaClient, 'usuario' | 'turma'>;
    senhas: Senhas;
    criadores: Readonly<Record<'Aluno' | 'Professor', CriadorUsuario>>;
}
const camposPublicos = { id: true, nome: true, email: true, perfil: true, criadoEm: true } as const;
export class CadastroService {
    private readonly deps: DependenciasCadastro;
    constructor(deps: DependenciasCadastro) { this.deps = deps; }
    async login(email: string, senhaDigitada: string) {
        const usuario = await this.deps.db.usuario.findUnique({ where: { email } });
        if (!usuario || !await this.deps.senhas.compare(senhaDigitada, usuario.senha)) {
            throw Object.assign(new Error('E-mail ou senha inválidos.'), { statusCode: 401 });
        }
        return { id: usuario.id, nome: usuario.nome, email: usuario.email, perfil: usuario.perfil };
    }
    async cadastrar({ nome, email, senha, perfil, codigoTurma }: DadosCadastro) {
        if (!senha)
            throw new Error('A senha é obrigatória.');
        if (senha.length < 8) {
            throw Object.assign(new Error('A senha deve ter no mínimo 8 caracteres.'), { statusCode: 422 });
        }
        const perfilNormalizado = typeof perfil === 'string'
            ? perfil.charAt(0).toUpperCase() + perfil.slice(1).toLowerCase() : '';
        // Correção explícita: antes qualquer perfil diferente de Aluno era persistido.
        if (perfilNormalizado !== 'Aluno' && perfilNormalizado !== 'Professor') {
            throw Object.assign(new Error('Perfil inválido. Selecione Aluno ou Professor.'), { statusCode: 422 });
        }
        const senhaHash = await this.deps.senhas.hash(senha, 10);
        let turmaId: string | undefined;
        if (perfilNormalizado === 'Aluno') {
            if (!codigoTurma) {
                throw Object.assign(new Error('O código da turma é obrigatório para alunos.'), { statusCode: 422 });
            }
            const turma = await this.deps.db.turma.findUnique({ where: { codigo: codigoTurma } });
            if (!turma)
                throw Object.assign(new Error('Código de turma inválido.'), { statusCode: 422 });
            turmaId = turma.id;
        }
        const data = this.deps.criadores[perfilNormalizado].preparar({ nome, email, senha: senhaHash }, turmaId);
        try {
            return await this.deps.db.usuario.create({ data, select: camposPublicos });
        }
        catch (error: unknown) {
            if (typeof error === 'object' && error !== null && 'code' in error && error.code === 'P2002') {
                throw Object.assign(new Error('Este e-mail já está cadastrado.'), { statusCode: 400 });
            }
            throw error;
        }
    }
}
