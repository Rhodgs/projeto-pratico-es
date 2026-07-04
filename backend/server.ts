/// <reference types="node" />

import cors from 'cors';
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
app.use(cors());
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

// ==========================================
// ROTAS DE AUTENTICAÇÃO E CADASTRO (US13)
// ==========================================
// Vincula a URL /auth/register ao método register do nosso controller 

app.post('/api/auth/register', (req, res) => authController.register(req, res));
app.post('/api/auth/login', (req, res) => authController.login(req, res));

// ==========================================
// LIGANDO O SERVIDOR
// ==========================================
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
  console.log(`Acesse: http://localhost:${PORT}`);

  // Caminhos possíveis do ADB (cada dev tem o seu usuário/máquina).
  // Tenta cada um em ordem até um funcionar; se nenhum existir, cai no
  // 'adb' do PATH do sistema.
  const possiveisCaminhos = [
    '"C:\\Users\\Rhuan\\AppData\\Local\\Android\\Sdk\\platform-tools\\adb"',
    '"C:\\Users\\asmin\\AppData\\Local\\Android\\Sdk\\platform-tools\\adb"',
    'adb', // se o adb estiver no PATH do sistema
  ];

  const tentarAdb = (index: number) => {
    if (index >= possiveisCaminhos.length) {
      console.log('Aviso: Túnel USB não ativado (celular não conectado ou adb não encontrado).');
      return;
    }

    exec(`${possiveisCaminhos[index]} reverse tcp:3000 tcp:3000`, (error: Error | null) => {
      if (error) {
        tentarAdb(index + 1);
      } else {
        console.log('Túnel USB ativado! Celular tem acesso ao backend.');
      }
    });
  };

  tentarAdb(0);
});