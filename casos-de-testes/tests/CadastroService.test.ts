// Arquivo: tests/CadastroService.test.ts

import { CadastroService } from "../src/CadastroService";

describe("US13: Realizar Cadastro Básico no Sistema - Casos de Teste", () => {
  // Caso 1 (Sucesso): 1, 3, 6, 9
  // Usuário preenche nome com 5 letras, e-mail correto, senha forte e perfil
  test("Caso 1: Cadastro concluído com dados válidos", () => {
    expect(CadastroService.validarNome("roger")).toBe(true); // Classe 1 (Nome com 5 letras)
    expect(CadastroService.validarFormatoEmail("roger@ufam.edu.br")).toBe(true); // Classe 3 (Formato ok)
    expect(
      CadastroService.validarEmailInedito("roger@ufam.edu.br", [
        "outro@email.com",
      ]),
    ).toBe(true); // Classe 3 (Inédito)
    expect(CadastroService.validarSenha("SenhaForte123")).toBe(true); // Classe 6 (8+ chars, maiúscula, número)
    expect(CadastroService.validarPerfil("Aluno")).toBe(true); // Classe 9 (Perfil válido)
  });

  // Caso 2 (Falha): 2, 3, 6, 9
  // Usuário tenta se cadastrar digitando o nome apenas com "Zé"

  test("Caso 2: O sistema deve bloquear nome menor que 3 caracteres", () => {
    // Classe 2: Nome muito curto
    expect(CadastroService.validarNome("Zé")).toBe(false);
  });
  // Caso 3 (Falha): 1, 4, 6, 9
  // Usuário preenche os dados, mas digita o e-mail sem o símbolo @
  test("Caso 3: O sistema deve bloquear e-mail em formato incorreto", () => {
    // Classe 4: Esqueceu o @
    expect(CadastroService.validarFormatoEmail("rogernemail.com")).toBe(false);
  });
  // Caso 4 (Falha): 1, 5, 6, 9
  // Usuário preenche tudo certo, mas usa um e-mail que já está cadastrado
  test("Caso 4: O sistema deve bloquear duplicidade de e-mail", () => {
    const bancoDeEmails = ["joao@ufam.edu.br", "roger@ufam.edu.br"];

    // Classe 5: Tenta cadastrar um e-mail que o .includes() vai achar no banco
    expect(
      CadastroService.validarEmailInedito("roger@ufam.edu.br", bancoDeEmails),
    ).toBe(false);
  });

  // Caso 5 (Falha): 1, 3, 7, 9
  // Usuário digita uma senha fraca com apenas 5 caracteres

  test("Caso 5: O sistema deve bloquear senha com menos de 8 caracteres", () => {
    // Classe 7: Senha com 6 caracteres (mesmo tendo número e maiúscula, tem que falhar)
    expect(CadastroService.validarSenha("Forte1")).toBe(false);
  });

  // Caso 6 (Falha): 1, 3, 8, 9
  // Usuário cria uma senha longa, mas apenas com letras minúsculas
  test("Caso 6: O sistema deve bloquear senha sem letra maiúscula e número", () => {
    // Classe 8: Senha com 15 letras, mas tudo minúscula e sem números
    expect(CadastroService.validarSenha("senhamuitolonga")).toBe(false);
  });

  // Caso 7 (Falha): 1, 3, 6, 10
  // Usuário preenche os dados, mas deixa o Tipo de Perfil em branco
  test("Caso 7: O sistema deve bloquear cadastro se perfil não for selecionado", () => {
    // Classe 10: Perfil não selecionado (em branco)
    expect(CadastroService.validarPerfil("")).toBe(false);
  });
});
