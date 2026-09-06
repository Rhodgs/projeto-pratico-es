import { ValidacaoCriacaoDesafio } from './ValidacaoCriacaoDesafio';
import type { DadosNovoDesafio, EntradaCriacaoDesafio } from './ValidacaoCriacaoDesafio';

export interface RepositorioCriacaoDesafio<T> {
  criar(dados: DadosNovoDesafio): Promise<T>;
}

// Ponto de entrada para o subsistema de criação: valida antes de persistir.
export class CriacaoDesafioFacade<T> {
  private readonly repositorio: RepositorioCriacaoDesafio<T>;
  private readonly validacao: ValidacaoCriacaoDesafio;
  private readonly agora: () => Date;

  constructor(
    repositorio: RepositorioCriacaoDesafio<T>,
    validacao = new ValidacaoCriacaoDesafio(),
    agora: () => Date = () => new Date(),
  ) {
    this.repositorio = repositorio;
    this.validacao = validacao;
    this.agora = agora;
  }

  async criar(entrada: EntradaCriacaoDesafio): Promise<T> {
    const dados = this.validacao.preparar(entrada, this.agora());
    return this.repositorio.criar(dados);
  }
}
