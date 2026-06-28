export class MissaoService {
  /**
   * Bloco que gerencia a submissão de uma missão (US09).
   * Ele analisa o tipo da missão e o status da conexão de internet.
   */
  submeterMissao(tipo: string, online: boolean): { status: number; mensagem: string; xp: number } {
    
    // Bloco que lida com falhas de rede (RN2). O aplicativo não deve travar. [cite: 20]
    // Se o aluno estiver offline, a ação é salva localmente. [cite: 21]
    if (!online) {
      return { 
        status: 202, 
        mensagem: "Você está offline. Sua missão foi salva e seus pontos serão atualizados assim que a conexão retornar.", 
        xp: 0 
      };
    }

    // Bloco para missões automatizadas (ex: quizzes) [cite: 18]
    // A recompensa é liberada e exibida imediatamente.
    if (tipo === 'automatizada') {
      return { 
        status: 200, 
        mensagem: "Feedback Instantâneo: Missão finalizada com sucesso!", 
        xp: 50 // Adição direta de Pontos de Experiência [cite: 17]
      };
    }

    // Bloco para desafios práticos que dependem de avaliação de um professor [cite: 19]
    if (tipo === 'pratica') {
      return { 
        status: 200, 
        mensagem: "Desafio enviado com sucesso! Suas recompensas serão computadas assim que o professor validar sua evidência.", 
        xp: 0 // XP não é entregue na hora
      };
    }

    // Bloco de segurança para tipos inválidos
    return { status: 400, mensagem: "Erro no envio", xp: 0 };
  }
}