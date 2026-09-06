/// <reference types="node" />

import express, { Request, Response, RequestHandler, NextFunction } from 'express';
import { criarControllersProducao } from './src/composition/producao';

import * as PreferenciasController from './src/controllers/PreferenciasController';
import { usuarioController } from './src/controllers/UsuarioController';

import { rankingController } from './src/controllers/RankingController';
import { uploadEvidencia } from './src/config/multerConfig';
import { exec } from 'child_process';

process.on('uncaughtException', (err) => {
  console.error('!!! ERRO NÃO TRATADO (uncaughtException):', err);
});
process.on('unhandledRejection', (reason) => {
  console.error('!!! PROMISE REJEITADA SEM TRATAMENTO (unhandledRejection):', reason);
});
process.on('exit', (code) => {
  console.log(`>>> Processo Node está encerrando. Código de saída: ${code}`);
});
console.log('>>> Iniciando server.ts...');

// Inicializa o aplicativo Express
const app = express();
const { authController, turmaController, desafioController } = criarControllersProducao();
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

app.get('/', (_req: Request, res: Response) => {
  res.json({ mensagem: 'Servidor do Jornada Verde está online!' });
});

app.post('/api/turmas', (req, res) => turmaController.criarTurma(req, res));
app.get('/api/turmas', (req, res) => turmaController.listarTurmas(req, res));
app.delete('/api/turmas/:id', (req, res) => turmaController.excluirTurma(req, res));

app.get('/api/usuario/perfil', (req, res) => usuarioController.buscarPerfil(req, res));
app.put('/api/usuario/preferencias', PreferenciasController.salvarPreferencias);
app.get('/api/usuario/preferencias', PreferenciasController.buscarPreferencias);

app.post('/api/desafios/:id/evidencias', uploadEvidencia.single('foto'), (req, res) => desafioController.anexarEvidencia(req, res));
app.get('/api/desafios/:id/evidencias', (req, res) => desafioController.listarEvidencias(req, res));

app.get('/api/turmas/:id/ranking', (req, res) => rankingController.buscarRanking(req, res));


app.post('/api/desafios', (req, res) => desafioController.criar(req, res));
app.get('/api/desafios', (req, res) => desafioController.listar(req, res));
app.get('/api/evidencias/pendentes', (req, res) => desafioController.listarEvidenciasPendentes(req, res));
app.post('/api/evidencias/:id/aprovar', (req, res) => desafioController.aprovar(req, res));
app.post('/api/evidencias/:id/recusar', (req, res) => desafioController.recusar(req, res));

app.post('/api/auth/register', (req, res) => authController.register(req, res));
app.post('/api/auth/login', (req, res) => authController.login(req, res));

console.log('>>> Rotas registradas, chamando app.listen()...');

const servidor = app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
  console.log(`Acesse: http://localhost:${PORT}`);
});

servidor.on('error', (err) => {
  console.error('!!! ERRO AO INICIAR O SERVIDOR (listen):', err);
});
