
export interface Usuario {
  id: string;
  nome: string;
  email: string;
  senha: string;
  perfil: 'Aluno' | 'Professor';
  criadoEm: Date;
}

// Array global para gerenciar e persistir os usuários em memória de forma segura
export const usuarios: Usuario[] = [];

export class CadastroService {
  
  static validarNome(nome: string): boolean {
    return nome.trim().length >= 3;
  }

  static validarFormatoEmail(email: string): boolean {
    const regexEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return regexEmail.test(email);
  }

  static validarEmailInedito(email: string): boolean {
    return !usuarios.some(u => u.email.toLowerCase() === email.toLowerCase().trim());
  }

  static validarSenha(senha: string): boolean {
    // Mínimo de 8 caracteres, pelo menos uma letra maiúscula e um número
    const regexSenha = /^(?=.*[A-Z])(?=.*\d).{8,}$/;
    return regexSenha.test(senha);
  }

  static validarPerfil(perfil: string): boolean {
    if (!perfil) return false;
    const formatoPadrao = perfil.trim().charAt(0).toUpperCase() + perfil.trim().slice(1).toLowerCase();
    return formatoPadrao === 'Aluno' || formatoPadrao === 'Professor';
  }

  // Método para processar o cadastro completo atendendo a tabela de testes (Casos 1 a 7)
  static cadastrar(dados: Omit<Usuario, 'id' | 'criadoEm'>): Usuario {
    if (!this.validarNome(dados.nome)) {
      throw new Error('Erro: Aceitou nome menor que 3 caracteres.');
    }
    if (!this.validarFormatoEmail(dados.email)) {
      throw new Error('Erro: E-mail em formato incorreto.');
    }
    if (!this.validarEmailInedito(dados.email)) {
      throw new Error('Erro: Duplicidade de e-mail.');
    }
    if (!this.validarSenha(dados.senha)) {
      if (dados.senha.length < 8) {
        throw new Error('Erro: Senha com menos de 8 caracteres.');
      }
      throw new Error('Erro: Faltou letra maiúscula e número.');
    }

    // Tratamento e normalização do perfil recebido do frontend
    if (!dados.perfil || !this.validarPerfil(dados.perfil)) {
      throw new Error('Erro: Perfil não selecionado.');
    }
    const perfilFormatado = dados.perfil.trim().charAt(0).toUpperCase() + dados.perfil.trim().slice(1).toLowerCase() as 'Aluno' | 'Professor';

    const novoUsuario: Usuario = {
      id: Math.random().toString(36).substring(2, 9),
      nome: dados.nome.trim(),
      email: dados.email.trim().toLowerCase(),
      senha: dados.senha,
      perfil: perfilFormatado,
      criadoEm: new Date()
    };

    usuarios.push(novoUsuario);
    return novoUsuario;
  }

  // Rota de infraestrutura para validação e login
  static login(email: string, senha: string): Usuario {
    const emailFormatado = email.trim().toLowerCase();
    const usuario = usuarios.find(u => u.email === emailFormatado && u.senha === senha);
    
    if (!usuario) {
      throw new Error('E-mail ou senha incorretos.');
    }
    return usuario;
  }
}