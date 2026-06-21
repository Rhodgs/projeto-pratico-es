import { AcessibilidadeService } from '../src/AcessibilidadeService';
describe('Testes de Classes de Equivalência - US06 (Acessibilidade)', () => {
  let service: AcessibilidadeService;

  // Bloco executado antes de cada teste para garantir que o serviço esteja "limpo" e instanciado
  beforeEach(() => {
    service = new AcessibilidadeService();
  });

  // Caso 1: Teste de Caminho Feliz (Classes Válidas: 1, 3, 5, 7) 
  test('Caso 1 (Configurar - Sucesso): Usuário seleciona o Modo Daltonismo e aumenta a fonte para 150%', () => {
    // Executa a função passando dados válidos
    const resultado = service.validarConfiguracao('Modo Daltonismo', 150);
    // Valida se o sistema respondeu com sucesso
    expect(resultado.sucesso).toBe(true);
    // Valida se a mensagem de retorno bate com o Resultado Esperado da tabela 
    expect(resultado.mensagem).toBe("Paleta e tamanho mudam em menos de 1s, sem sobreposição e sem atualizar a página.");
  });

  // Caso 2: Teste de Falha por Paleta Inválida (Classes Inválidas: 2, 3, 5, 7) 
  test('Caso 2 (Configurar - Falha): Sistema tenta injetar um código de paleta de cores não mapeado', () => {
    // Executa a função passando uma paleta que não existe
    const resultado = service.validarConfiguracao('Modo Neon', 100);
    // Valida se o sistema recusou a entrada
    expect(resultado.sucesso).toBe(false);
    // Valida o comportamento de ignorar a alteração 
    expect(resultado.mensagem).toBe("O sistema ignora a paleta inválida e mantém o visual atual íntegro.");
  });

  // Caso 3: Teste de Falha por Estouro de Limite (Classes Inválidas: 1, 4, 5, 7) 
  test('Caso 3 (Configurar - Falha): Usuário tenta arrastar ou forçar a escala da fonte para 250%', () => {
    // Executa a função estourando o limite da escala
    const resultado = service.validarConfiguracao('Modo Suave', 250);
    // Valida a recusa da configuração
    expect(resultado.sucesso).toBe(false);
    // Valida a mensagem de proteção do layout 
    expect(resultado.mensagem).toBe("O sistema trava o limite máximo em 200% para evitar quebra de layout.");
  });
});