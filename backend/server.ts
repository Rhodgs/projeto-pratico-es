/// <reference types="node" />

import express, { Request, Response, RequestHandler, NextFunction } from 'express';
import { AuthController } from './src/controllers/AuthController';
import * as TurmaController from './src/controllers/TurmaController';
import * as PreferenciasController from './src/controllers/PreferenciasController';
import { DesafioController, anexarEvidencia, listarEvidencias } from './src/controllers/DesafioController';
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
<<<<<<< HEAD
// ==========================================
// ROTAS DE DESAFIOS / EVIDÊNCIAS (US4) — aluno anexa/lista evidências
// ==========================================
app.post('/api/desafios/:id/evidencias', anexarEvidencia);
app.get('/api/desafios/:id/evidencias', listarEvidencias);

// ==========================================
// ROTAS DE DESAFIOS E EVIDÊNCIAS (US10 e US11) — professor cria desafio e avalia evidências
// ==========================================
const desafioController = new DesafioController();
app.post('/api/desafios', (req, res) => desafioController.criar(req, res));
app.post('/api/evidencias/:id/aprovar', (req, res) => desafioController.aprovar(req, res));
app.post('/api/evidencias/:id/recusar', (req, res) => desafioController.recusar(req, res));

=======


 // ==========================================
// ROTAS DE AUTENTICAÇÃO E CADASTRO (US13)
// ==========================================
app.post('/api/auth/register', (req, res) => authController.register(req, res));
app.post('/api/auth/login', (req, res) => authController.login(req, res));
>>>>>>> origin/feat/autenticacao-base
// ==========================================
// LIGANDO O SERVIDOR
// ==========================================
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
  console.log(`Acesse: http://localhost:${PORT}`);
<<<<<<< HEAD

  // Caminho exato do seu ADB
  const possiveisCaminhos = [
    '"C:\\Users\\Rhuan\\AppData\\Local\\Android\\Sdk\\platform-tools\\adb"',
    'adb', // se o adb estiver no PATH do sistema
  ];

  // Executa o comando silenciosamente assim que o servidor liga
  exec(`${possiveisCaminhos[1]} reverse tcp:3000 tcp:3000`, (error) => {
=======
  // Caminho exato do seu ADB
  const adbPath = '"C:\\Users\\asmin\\AppData\\Local\\Android\\Sdk\\platform-tools\\adb"';
  
  // Executa o comando silenciosamente assim que o servidor liga
  exec(`${adbPath} reverse tcp:3000 tcp:3000`, (error: Error | null, _stdout: string, _stderr: string) => {
>>>>>>> origin/feat/autenticacao-base
    if (error) {
      console.log('Aviso: Túnel USB não ativado (celular não conectado ou adb não encontrado).');
    } else {
      console.log('Túnel USB ativado! Celular tem acesso ao backend.');
    }
  });
});