import { MissaoService } from '../src/MissaoSevice';

describe('Testes de Regras de Negócio - US09 (Recompensas)', () => {
  let service: MissaoService;

  beforeEach(() => {
    service = new MissaoService();
  });

  // Teste focado na RN1: Missões automatizadas dão recompensa na hora [cite: 18]
  test('Caso 1: Envio de missão automatizada online deve retornar XP imediato', () => {
    // Simula aluno online fazendo um quiz
    const resultado = service.submeterMissao('automatizada', true);
    
    // Espera status 200 (sucesso) [cite: 15]
    expect(resultado.status).toBe(200);
    // Espera que o XP tenha sido distribuído [cite: 17]
    expect(resultado.xp).toBe(50);
  });

  // Teste focado na RN1 (Exceção): Desafios práticos não dão recompensa na hora [cite: 19]
  test('Caso 2: Envio de desafio prático online avisa que depende de validação do professor', () => {
    // Simula aluno enviando um trabalho manual
    const resultado = service.submeterMissao('pratica', true);
    
    // O sistema avisa que a evidência será avaliada [cite: 19]
    expect(resultado.mensagem).toBe("Desafio enviado com sucesso! Suas recompensas serão computadas assim que o professor validar sua evidência.");
    // Garante que nenhum ponto foi creditado indevidamente
    expect(resultado.xp).toBe(0);
  });

  // Teste focado na RN2: Tolerância a Falhas de Rede [cite: 20]
  test('Caso 3: Perda de conexão armazena a missão localmente e exibe feedback alternativo', () => {
    // Simula instabilidade ou perda total de rede durante o envio (online = false) [cite: 20, 21]
    const resultado = service.submeterMissao('automatizada', false);
    
    // O status 202 indica que foi recebido pelo app, mas não processado no servidor final
    expect(resultado.status).toBe(202);
    // Exibe o texto exato definido na Regra de Negócio 2 [cite: 22]
    expect(resultado.mensagem).toBe("Você está offline. Sua missão foi salva e seus pontos serão atualizados assim que a conexão retornar.");
  });
});