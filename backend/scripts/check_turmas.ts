import { prisma } from '../database/prismaClient';

async function main() {
  const turmas = await prisma.turma.findMany();
  console.log('TURMAS NO DB:', turmas);
}

main()
  .then(() => process.exit(0))
  .catch((e) => {
    console.error(e);
    process.exit(1);
  });
