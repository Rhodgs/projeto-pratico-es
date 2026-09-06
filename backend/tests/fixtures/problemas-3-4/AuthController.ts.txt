
import { Request, Response } from 'express';
import { CadastroService } from '../services/CadastroService';

const cadastroService = new CadastroService();

export class AuthController {
  // ... (mantenha o método register que já fizemos)

  async login(req: Request, res: Response): Promise<Response> {
    try {
      const { email, senha } = req.body;

      // Executa a validação chamando o serviço que acabamos de atualizar
      const dadosUsuario = await cadastroService.login(email, senha);

      // Retorna os dados do usuário com sucesso
      return res.status(200).json({
        mensagem: 'Login realizado com sucesso!',
        usuario: dadosUsuario
      });

    } catch (error: any) {
      const statusCode = error.statusCode || 500;
      return res.status(statusCode).json({
        erro: error.message || 'Erro interno no servidor ao realizar login.'
      });
    }
  }
  async register(req: Request, res: Response): Promise<Response> {
    try {
      // Capturamos 'role' (como enviado pelo Flutter) em vez de 'perfil'
      const { nome, email, senha, role, codigoTurma } = req.body;

      // Repassamos para o service mapeando 'role' para o campo 'perfil' que o Prisma espera
      const novoUsuario = await cadastroService.cadastrar({
        nome,
        email,
        senha,
        perfil: role, // Aqui é feita a ponte!
        codigoTurma,
      });

      return res.status(201).json({
        mensagem: 'Usuário cadastrado com sucesso!',
        usuario: novoUsuario
      });
      
    } catch (error: any) {
      const statusCode = error.statusCode || 500;
      return res.status(statusCode).json({
        erro: error.message || 'Erro interno no servidor ao realizar cadastro.'
      });
    }
  }

  // O método de Login (POST /auth/login) ficará aqui logo em seguida! 
}