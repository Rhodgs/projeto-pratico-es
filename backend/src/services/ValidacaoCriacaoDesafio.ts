export interface EntradaCriacaoDesafio {
  titulo: string;
  descricao: string;
  pontuacao: number | string;
  prazoLimite: string;
}

export interface DadosNovoDesafio {
  titulo: string;
  descricao: string;
  pontuacao: number;
  prazoLimite: Date;
}

export class ValidacaoCriacaoDesafio {
  preparar(entrada: EntradaCriacaoDesafio, agora: Date): DadosNovoDesafio {
    const { titulo, descricao, pontuacao, prazoLimite } = entrada;
    if (!titulo || titulo.trim() === '' || !descricao || descricao.trim() === '') {
      throw new Error('Erro: Campos obrigatórios vazios.');
    }

    const prazo = new Date(prazoLimite);
    if (prazo < agora) {
      throw new Error('Erro: Prazo no passado.');
    }
    if (Math.abs(prazo.getTime() - agora.getTime()) < 60000) {
      throw new Error('Erro: Prazo precisa dar um tempo mínimo útil de duração.');
    }

    return {
      titulo: titulo.trim(),
      descricao: descricao.trim(),
      pontuacao: Number(pontuacao),
      prazoLimite: prazo,
    };
  }
}
