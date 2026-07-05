import { prisma } from '../../database/prismaClient';
import bcrypt from 'bcrypt';

// Criamos uma interface para definir exatamente quais dados o serviço espera receber
interface DadosCadastro {
  nome: string;
  email: string;
  senha?: string; // opcional temporariamente para checagem se necessário
  perfil: 'Professor' | 'Aluno';
  codigoTurma?: string;
}

export class CadastroService {
  async login(email: string, senhaDigitada: string) {
    // 1. Busca o usuário pelo e-mail informado
    const usuario = await prisma.usuario.findUnique({
      where: { email }
    });

    // 2. Se não achar o usuário, lança um erro 401 (Não Autorizado)
    // Usamos uma mensagem genérica por segurança para evitar que invasores descubram e-mails válidos
    if (!usuario) {
      const erro: any = new Error('E-mail ou senha inválidos.');
      erro.statusCode = 401;
      throw erro;
    }

    // 3. Compara a senha digitada com o hash criptografado salvo no banco
    const senhaValida = await bcrypt.compare(senhaDigitada, usuario.senha);

    if (!senhaValida) {
      const erro: any = new Error('E-mail ou senha inválidos.');
      erro.statusCode = 401;
      throw erro;
    }

    // 4. Se a senha bater, retorna os dados do usuário mascarando a senha
    return {
      id: usuario.id,
      nome: usuario.nome,
      email: usuario.email,
      perfil: usuario.perfil
    };
  }
  async cadastrar({ nome, email, senha, perfil, codigoTurma }: DadosCadastro) {
    if (!senha) {
      throw new Error('A senha é obrigatória.');
    }

    if (senha.length < 8) {
      const erro: any = new Error('A senha deve ter no mínimo 8 caracteres.');
      erro.statusCode = 422;
      throw erro;
    }

    // Normaliza perfil para 'Aluno' ou 'Professor' (aceita entradas em minúsculas)
    const perfilNormalizado = perfil.charAt(0).toUpperCase() + perfil.slice(1).toLowerCase();

    // 1. Criptografar a senha com o bcrypt (10 rounds de salt é o padrão seguro)
    const senhaHash = await bcrypt.hash(senha, 10);

    // 2. Se o perfil for Aluno, precisamos validar a turma antes de criar o usuário
    if (perfilNormalizado === 'Aluno') {
      if (!codigoTurma) {
        // Retornamos um erro com um status customizado para o controller tratar como 422
        const erro: any = new Error('O código da turma é obrigatório para alunos.');
        erro.statusCode = 422;
        throw erro;
      }

      // Busca a turma no Postgres usando o Prisma pelo código de 6 caracteres
      const turmaExistente = await prisma.turma.findUnique({
        where: { codigo: codigoTurma }
      });

      // Se a turma não existir, barramos o cadastro aqui
      if (!turmaExistente) {
        const erro: any = new Error('Código de turma inválido.');
        erro.statusCode = 422;
        throw erro;
      }

      // Tenta criar o Aluno e já vincula ele na turma na mesma operação
      try {
        const novoAluno = await prisma.usuario.create({
          data: {
            nome,
            email,
            senha: senhaHash,
            perfil: perfilNormalizado,
            turmas: {
              connect: { id: turmaExistente.id } // Conecta o aluno na tabela de relação N:M
            }
          },
          select: { id: true, nome: true, email: true, perfil: true, criadoEm: true }
        });

        return novoAluno;
      } catch (error: any) {
        // Captura o erro de campo único (@unique) do Prisma para e-mail duplicado
        if (error.code === 'P2002') {
          const erro: any = new Error('Este e-mail já está cadastrado.');
          erro.statusCode = 400;
          throw erro;
        }
        throw error;
      }
    }

    // 3. Se o perfil for Professor, cria direto sem precisar de código de turma
    try {
      const novoProfessor = await prisma.usuario.create({
        data: {
          nome,
          email,
          senha: senhaHash,
          perfil: perfilNormalizado
        },
        // O select evita que a senha volte na resposta por segurança
        select: { id: true, nome: true, email: true, perfil: true, criadoEm: true }
      });

      return novoProfessor;
    } catch (error: any) {
      if (error.code === 'P2002') {
        const erro: any = new Error('Este e-mail já está cadastrado.');
        erro.statusCode = 400;
        throw erro;
      }
      throw error;
    }
  }
}