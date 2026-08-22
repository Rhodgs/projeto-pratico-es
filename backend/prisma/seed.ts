import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcryptjs'; 

const prisma = new PrismaClient();

// Atende a regra: mínimo 8 caracteres e ao menos 1 letra maiúscula
const SENHA_PADRAO = 'Teste123!';

function gerarCodigoTurma(): string {
  const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // sem caracteres ambíguos (O, 0, I, 1)
  let codigo = '';
  for (let i = 0; i < 6; i++) {
    codigo += chars[Math.floor(Math.random() * chars.length)];
  }
  return codigo;
}

const NOMES_PROFESSORES = [
  'Ana Beatriz Souza',
  'Carlos Eduardo Lima',
  'Fernanda Oliveira',
  'Marcos Vinicius Alves',
  'Juliana Costa Ferreira',
];

const NOMES_ALUNOS = [
  'Pedro Henrique', 'Maria Clara', 'Lucas Gabriel', 'Ana Julia', 'João Vitor',
  'Beatriz Santos', 'Gustavo Rocha', 'Isabela Martins', 'Rafael Almeida', 'Larissa Pereira',
  'Thiago Nunes', 'Camila Ribeiro', 'Bruno Cardoso', 'Amanda Teixeira', 'Diego Barbosa',
  'Sophia Carvalho', 'Matheus Correia', 'Yasmin Duarte', 'Felipe Moraes', 'Giovanna Pires',
  'Vinicius Castro', 'Laura Mendes', 'Enzo Vieira', 'Alice Farias', 'Davi Monteiro',
  'Manuela Rezende', 'Arthur Freitas', 'Helena Batista', 'Gabriel Nogueira', 'Valentina Lopes',
  'Miguel Azevedo', 'Sarah Cavalcanti', 'Bernardo Dias', 'Livia Andrade', 'Theo Ramos',
  'Cecilia Borges', 'Heitor Pinto', 'Luiza Campos', 'Samuel Cunha', 'Elisa Marques',
  'Nicolas Melo', 'Alicia Guimaraes', 'Benjamin Reis', 'Isadora Fonseca', 'Lorenzo Teles',
  'Antonella Xavier', 'Emanuel Brito', 'Melissa Siqueira', 'Anthony Rocha', 'Agatha Prado',
];

async function limparBanco() {
  console.log('🧹 Limpando dados existentes...');
  // A ordem importa para evitar erros de Foreign Key (chaves estrangeiras)
  await prisma.evidencia.deleteMany();
  await prisma.desafio.deleteMany();
  await prisma.preferencias.deleteMany();
  await prisma.turma.deleteMany();
  await prisma.usuario.deleteMany();
}

async function criarUsuario(nome: string, email: string, perfil: 'Professor' | 'Aluno') {
  const senhaHash = await bcrypt.hash(SENHA_PADRAO, 10);
  return prisma.usuario.create({
    data: {
      nome,
      email,
      senha: senhaHash,
      perfil,
      xp: perfil === 'Aluno' ? Math.floor(Math.random() * 200) : 0,
      preferencias: {
        create: {
          modoEscuro: false,
          modoDaltonismo: false,
          tamanhoFonte: 16,
        },
      },
    },
  });
}

async function main() {
  await limparBanco();
  console.log(' Semeando novos dados...\n');

  const resumo: { turma: string; codigo: string; professor: string; alunos: string[] }[] = [];
  let alunoIndex = 0;

  for (let i = 0; i < 5; i++) {
    // 1. Criar Professor
    const nomeProfessor = NOMES_PROFESSORES[i];
    const emailProfessor = `professor${i + 1}@teste.com`;
    const professor = await criarUsuario(nomeProfessor, emailProfessor, 'Professor');

    // 2. Criar Turma
    const codigo = gerarCodigoTurma();
    const turma = await prisma.turma.create({
      data: {
        nome: `Turma ${i + 1}`,
        codigo,
        professorId: professor.id,
      },
    });

    const qtdAlunos = 9 + Math.floor(Math.random() * 7); // 9 a 15 alunos
    const alunosEmails: string[] = [];

    // 3. Criar Alunos e vincular à Turma
    for (let j = 0; j < qtdAlunos; j++) {
      const nomeAluno = NOMES_ALUNOS[alunoIndex % NOMES_ALUNOS.length];
      alunoIndex++;
      const emailAluno = `aluno${alunoIndex}@teste.com`;
      
      const aluno = await criarUsuario(nomeAluno, emailAluno, 'Aluno');

      await prisma.turma.update({
        where: { id: turma.id },
        data: { alunos: { connect: { id: aluno.id } } },
      });

      alunosEmails.push(emailAluno);
    }

    resumo.push({ turma: turma.nome, codigo, professor: emailProfessor, alunos: alunosEmails });
  }

  // Log detalhado para você saber com quem testar o login
  console.log('RESUMO DO SEED');
  console.log(` Senha de todos os usuários: ${SENHA_PADRAO}\n`);
  for (const r of resumo) {
    console.log(` ${r.turma} | Código: ${r.codigo} | Professor: ${r.professor}`);
    console.log(` Alunos (${r.alunos.length}): ${r.alunos.join(', ')}`);
    console.log('--------------------------------------------------');
  }
  console.log(' Banco limpo e populado com sucesso!');
}

main()
  .catch((e) => {
    console.error(' Erro durante o seed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });