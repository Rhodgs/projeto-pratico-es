import express from 'express';
import cors from 'cors';

// Inicializa o aplicativo Express
const app = express();
const PORT = 3000;

// Middlewares (Configurações importantes)
app.use(cors()); // Permite que o Flutter (em outra porta/lugar) converse com essa API
app.use(express.json()); // Diz pro servidor que ele vai receber e enviar arquivos JSON

// ==========================================
// ROTA DE TESTE (Para ver se o motor ligou)
// ==========================================
app.get('/', (req, res) => {
    res.json({ mensagem: "Servidor do Jornada Verde está online!" });
});

// AQUI ABAIXO CADA PESSOA VAI COLAR AS SUAS ROTAS!
// (A Pessoa 1 cola o login, você cola as turmas, etc.)

// ==========================================
// LIGANDO O SERVIDOR
// ==========================================
app.listen(PORT, () => {
    console.log(`🚀 Servidor rodando na porta ${PORT}`);
    console.log(`Acesse: http://localhost:${PORT}`);
});