// Arquivo: src/CadastroService.ts

export class CadastroService {
  /**
   * Cobre as Classes: 1 (Válida) e 2 (Inválida)
   * O que faz: Remove espaços em branco nas pontas e checa se sobraram pelo menos 3 letras
   * Retorna: true (se >= 3) ou false (se < 3)
   */
  static validarNome(nome: string): boolean {
    const nomeLimpo = nome.trim(); // Remove espaços enganosos como "   "

    if (nomeLimpo.length < 3) {
      return false; // Classe Inválida 2
    }
    return true; // Classe Válida 1
  }

  /**
   * Cobre as Classes: 3 (Válida) e 4 (Inválida)
   * O que faz: Verifica se o texto possui o símbolo '@' e um formato mínimo aceitável
   * Retorna: booleano
   */
  static validarFormatoEmail(email: string): boolean {
    // Uma checagem simples para garantir que tem algo antes do @, o @ em si, e algo depois
    const regexEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if (!regexEmail.test(email)) {
      return false; // Classe Inválida 4 (Ex: sem @ ou formato quebrado)
    }
    return true; // Classe Válida 3 (Formato ok, mas ainda falta ver se é inédito)
  }

  /**
   * Cobre a Classe: 5 (Inválida - RN1)
   * O que faz: Simula a busca no banco de dados para ver se o e-mail já foi usado.
   * Retorna: booleano (true se for inédito, false se for duplicado).
   */
  static validarEmailInedito(email: string, bancoDeEmails: string[]): boolean {
    if (bancoDeEmails.includes(email)) {
      return false; // Classe Inválida 5 (E-mail já cadastrado)
    }
    return true; // E-mail liberado para uso
  }

  /**
   * Cobre as Classes: 6 (Válida), 7 (Inválida) e 8 (Inválida)
   * O que faz: Checa o tamanho mínimo e procura ativamente por letras maiúsculas e números.
   * Retorna: booleano.
   */
  static validarSenha(senha: string): boolean {
    // Checa a Classe Inválida 7 (Tamanho menor que 8)
    if (senha.length < 8) {
      return false;
    }

    const temMaiuscula = /[A-Z]/.test(senha);
    const temNumero = /[0-9]/.test(senha);

    // Checa a Classe Inválida 8 (Falta maiúscula ou número)
    if (!temMaiuscula || !temNumero) {
      return false;
    }

    return true; // Classe Válida 6 (Tem 8+ chars, maiúscula e número)
  }

  /**
   * Cobre as Classes: 9 (Válida) e 10 (Inválida)
   * O que faz: Garante que o usuário selecionou exatamente uma das opções disponíveis.
   * Retorna: booleano.
   */
  static validarPerfil(perfilSelecionado: string): boolean {
    // Se o perfil for uma string vazia ou espaço em branco, recusa.
    const perfilLimpo = perfilSelecionado.trim();

    if (perfilLimpo === "") {
      return false; // Classe Inválida 10 (Não selecionado/Em branco)
    }

    // Garante que não injetaram um perfil que não existe
    if (perfilLimpo !== "Aluno" && perfilLimpo !== "Professor") {
      return false;
    }

    return true; // Classe Válida 9
  }
}
