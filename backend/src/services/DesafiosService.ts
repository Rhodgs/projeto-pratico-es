

export interface Desafio {
  id: string;
  titulo: string;
  descricao: string;
  pontuacao: number;
  prazoLimite: Date; // Armazena data e hora [cite: 37]
  criadoEm: Date;
}

export interface Evidencia {
  id: string;
  desafioId: string;
  alunoId: string;
  alunoNome: string;
  status: 'Pendente' | 'Aprovado' | 'Recusado'; // Status exigidos [cite: 113, 118]
  justificativa?: string;
  enviadoEm: Date;
}

// Bancos de dados em memória
export const desafios: Desafio[] = [];
export const evidencias: Evidencia[] = [];

export class DesafioService {

  // --- VALIDAÇÕES US4 (Criação do Desafio) ---
  
  static criarDesafio(dados: Omit<Desafio, 'id' | 'criadoEm'>): Desafio {
    // Caso 2: Campos obrigatórios vazios [cite: 52]
    if (!dados.titulo || dados.titulo.trim() === '' || !dados.descricao || dados.descricao.trim() === '') {
      throw new Error('Erro: Campos obrigatórios vazios.');
    }

    const agora = new Date();
    const prazo = new Date(dados.prazoLimite);

    // Caso 3: Data e hora definidas no passado [cite: 43]
    if (prazo < agora) {
      throw new Error('Erro: Prazo no passado.');
    }

    // Caso 4: Prazo coincide com o momento atual (precisa dar um tempo mínimo útil)
    if (Math.abs(prazo.getTime() - agora.getTime()) < 60000) { 
      throw new Error('Erro: Prazo precisa dar um tempo mínimo útil de duração.');
    }

    const novoDesafio: Desafio = {
      id: 'DES-' + Math.random().toString(36).substring(2, 7).toUpperCase(),
      titulo: dados.titulo.trim(),
      descricao: dados.descricao.trim(),
      pontuacao: Number(dados.pontuacao),
      prazoLimite: prazo,
      criadoEm: agora
    };

    desafios.push(novoDesafio);
    return novoDesafio;
  }

  // --- VALIDAÇÕES US11 (Avaliação de Evidências) ---

  static aprovarEvidencia(evidenciaId: string): Evidencia {
    const evidencia = evidencias.find(e => e.id === evidenciaId);
    if (!evidencia) {
      throw new Error('Evidência não encontrada.');
    }

    // Altera o status para aprovado [cite: 45, 114]
    evidencia.status = 'Aprovado';

    return evidencia;
  }

  static recusarEvidencia(evidenciaId: string, justificativa: string): Evidencia {
    const evidencia = evidencias.find(e => e.id === evidenciaId);
    if (!evidencia) {
      throw new Error('Evidência não encontrada.');
    }

    // Caso 4 (US11): Tenta recusar deixando a justificativa em branco [cite: 115]
    if (!justificativa || justificativa.trim() === '') {
      throw new Error('O aplicativo burla a regra e deixa o professor recusar a missão sem explicar o motivo para o estudante.');
    }

    evidencia.status = 'Recusado';
    evidencia.justificativa = justificativa.trim();

    return evidencia;
  }
}