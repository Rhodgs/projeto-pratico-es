// backend/src/config/multerConfig.ts
import multer from 'multer';
import path from 'path';

// Configura ONDE e COM QUE NOME cada arquivo enviado vai ser salvo
const storage = multer.diskStorage({
  destination: (req, file, callback) => {
    // Pasta de destino: backend/uploads
    callback(null, path.join(__dirname, '..', '..', 'uploads'));
  },
  filename: (req, file, callback) => {
    // Nome único: timestamp + nome original (evita sobrescrever arquivos com o mesmo nome)
    const nomeUnico = `${Date.now()}-${file.originalname}`;
    callback(null, nomeUnico);
  },
});

// Filtro: só aceita imagens (jpg, jpeg, png)
const fileFilter = (req: any, file: Express.Multer.File, callback: multer.FileFilterCallback) => {
  const tiposPermitidos = ['image/jpeg', 'image/jpg', 'image/png'];
  if (tiposPermitidos.includes(file.mimetype)) {
    callback(null, true);
  } else {
    callback(new Error('Apenas arquivos JPG ou PNG são permitidos.'));
  }
};

export const uploadEvidencia = multer({
  storage,
  fileFilter,
  limits: { fileSize: 5 * 1024 * 1024 }, // 5MB máximo
});