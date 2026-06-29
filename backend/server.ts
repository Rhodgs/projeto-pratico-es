/// <reference types="node" />

import express, { Request, Response, RequestHandler, NextFunction } from 'express';
import { AuthController } from './src/controllers/AuthController';
import * as TurmaController from './src/controllers/TurmaController';
import * as PreferenciasController from './src/controllers/PreferenciasController';
import { exec } from 'child_process';

// Inicializa o aplicativo Express
const app = express();
const authController = new AuthController();
const PORT = 3000;
 
// Middlewares
const corsMiddleware: RequestHandler = (req: Request, res: Response, next: NextFunction) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  if (req.method === 'OPTIONS') {
    return res.sendStatus(204);
  }
  next();
};

app.use(corsMiddleware);
app.use(express.json());
 
// ==========================================
// ROTA DE TESTE
// ==========================================
app.get('/', (_req: Request, res: Response) => {
  res.json({ mensagem: 'Servidor do Jornada Verde está online!' });
});
 
// ==========================================
// ROTAS DE TURMAS (US3)
// ==========================================
app.post('/api/turmas', TurmaController.criarTurma);
app.get('/api/turmas', TurmaController.listarTurmas);
app.delete('/api/turmas/:id', TurmaController.excluirTurma);

// ==========================================
// ROTAS DE PREFERÊNCIAS DE ACESSIBILIDADE (US6)
// ==========================================
app.put('/api/usuario/preferencias', PreferenciasController.salvarPreferencias);
app.get('/api/usuario/preferencias', PreferenciasController.buscarPreferencias);

// AQUI ABAIXO CADA PESSOA VAI COLAR AS SUAS ROTAS!


 // ==========================================
// ROTAS DE AUTENTICAÇÃO E CADASTRO (US13)
// ==========================================
app.post('/auth/register', (req: Request, res: Response) => authController.register(req, res));
app.post('/auth/login', (req: Request, res: Response) => authController.login(req, res));

// ==========================================
// LIGANDO O SERVIDOR
// ==========================================
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
  console.log(`Acesse: http://localhost:${PORT}`);
  // Caminho exato do seu ADB
  const adbPath = '"C:\\Users\\asmin\\AppData\\Local\\Android\\Sdk\\platform-tools\\adb"';
  
  // Executa o comando silenciosamente assim que o servidor liga
  exec(`${adbPath} reverse tcp:3000 tcp:3000`, (error: Error | null, _stdout: string, _stderr: string) => {
    if (error) {
      console.log('Aviso: Celular não conectado via USB. O túnel não foi ativado, mas o PC funciona normal.');
    } else {
      console.log('Túnel USB (ADB reverse) ativado com sucesso! O celular já tem acesso ao backend.');
    }
  });
});
