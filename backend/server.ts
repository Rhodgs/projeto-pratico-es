import express from 'express';
import cors from 'cors';
import * as TurmaController from './src/controllers/TurmaController';
import * as PreferenciasController from './src/controllers/PreferenciasController';
import { DesafioController, anexarEvidencia, listarEvidencias } from './src/controllers/DesafioController';
import { exec } from 'child_process';

// Inicializa o aplicativo Express
const app = express();
const PORT = 3000;

// Middlewares
app.use(cors());
app.use(express.json());

// ==========================================
// ROTA DE TESTE
// ==========================================
app.get('/', (req, res) => {
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
app.put("/api/usuario/preferencias", PreferenciasController.salvarPreferencias);
app.get("/api/usuario/preferencias", PreferenciasController.buscarPreferencias);

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
// LIGANDO O SERVIDOR
// ==========================================
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
  console.log(`Acesse: http://localhost:${PORT}`);

  // Caminho exato do seu ADB
  const possiveisCaminhos = [
    '"C:\\Users\\Rhuan\\AppData\\Local\\Android\\Sdk\\platform-tools\\adb"',
    'adb', // se o adb estiver no PATH do sistema
  ];

  // Executa o comando silenciosamente assim que o servidor liga
  exec(`${possiveisCaminhos[1]} reverse tcp:3000 tcp:3000`, (error) => {
    if (error) {
      console.log('Aviso: Túnel USB não ativado (celular não conectado ou adb não encontrado).');
    } else {
      console.log('Túnel USB ativado! Celular tem acesso ao backend.');
    }
  });
});