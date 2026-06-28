export class AcessibilidadeService {
  /**
   * Bloco responsável por validar as configurações de acessibilidade da US06.
   * Ele recebe a paleta desejada e o percentual da fonte.
   */
  validarConfiguracao(paleta: string, tamanhoFonte: number): { sucesso: boolean; mensagem: string } {
    
    // Define as opções exatas de contraste permitidas no sistema [cite: 4, 5, 6, 7]
    const paletasValidas = ['Modo Escuro', 'Modo Daltonismo', 'Modo Suave'];

    // Bloco que verifica se a paleta selecionada é inválida (Caso de Falha)
    if (!paletasValidas.includes(paleta)) {
      return { sucesso: false, mensagem: "O sistema ignora a paleta inválida e mantém o visual atual íntegro." };
    }

    // Bloco que trava o tamanho máximo da fonte em 200% para evitar quebra de layout [cite: 8, 23]
    if (tamanhoFonte > 200) {
      return { sucesso: false, mensagem: "O sistema trava o limite máximo em 200% para evitar quebra de layout." };
    }

    // Retorno de sucesso caso as validações passem, simulando a aplicação em menos de 1s [cite: 9, 23]
    return { sucesso: true, mensagem: "Paleta e tamanho mudam em menos de 1s, sem sobreposição e sem atualizar a página." };
  }
}