import express from 'express';
import cors from 'cors';
import * as TurmaController from './src/controllers/TurmaController';
import * as PreferenciasController from './src/controllers/PreferenciasController';
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
// LIGANDO O SERVIDOR
// ==========================================
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
  console.log(`Acesse: http://localhost:${PORT}`);
// Caminho exato do seu ADB
  const adbPath = '"C:\\Users\\Rhuan\\AppData\\Local\\Android\\Sdk\\platform-tools\\adb"';
  
  // Executa o comando silenciosamente assim que o servidor liga
  exec(`${adbPath} reverse tcp:3000 tcp:3000`, (error, stdout, stderr) => {
    if (error) {
      console.log('Aviso: Celular não conectado via USB. O túnel não foi ativado, mas o PC funciona normal.');
    } else {
      console.log('Túnel USB (ADB reverse) ativado com sucesso! O celular já tem acesso ao backend.');
    }
  });
});
