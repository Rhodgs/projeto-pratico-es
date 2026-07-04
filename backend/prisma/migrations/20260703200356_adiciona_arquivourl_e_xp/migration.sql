-- AlterTable
ALTER TABLE "Evidencia" ADD COLUMN     "arquivoUrl" TEXT;

-- AlterTable
ALTER TABLE "Usuario" ADD COLUMN     "xp" INTEGER NOT NULL DEFAULT 0;
