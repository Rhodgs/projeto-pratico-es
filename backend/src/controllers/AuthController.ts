
type Request = { body: any };
type Response = { status: (code: number) => Response; json: (body: any) => Response };
import { CadastroService } from '../services/CadastroService';

export class AuthController {
  
  async register(req: Request, res: Response): Promise<Response> {
    try {
      const { nome, email, senha, perfil } = req.body;
      
      const novoUsuario = CadastroService.cadastrar({ nome, email, senha, perfil });
      
      return res.status(201).json({
        message: 'Cadastro realizado com sucesso!',
        user: {
          id: novoUsuario.id,
          nome: novoUsuario.nome,
          email: novoUsuario.email,
          perfil: novoUsuario.perfil
        }
      });
    } catch (error: any) {
      // Retorna o status 400 (Bad Request) com o erro tratado das regras de negócio
      return res.status(400).json({ error: error.message });
    }
  }

  async login(req: Request, res: Response): Promise<Response> {
    try {
      const { email, senha } = req.body;
      
      const usuario = CadastroService.login(email, senha);
      
      return res.status(200).json({
        message: 'Login realizado com sucesso!',
        user: {
          id: usuario.id,
          nome: usuario.nome,
          email: usuario.email,
          perfil: usuario.perfil
        }
      });
    } catch (error: any) {
      return res.status(401).json({ error: error.message });
    }
  }
}