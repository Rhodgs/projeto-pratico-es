
export class TurmaService {
  /**
   * Valida os critérios de criação de uma nova turma.
   */
    validarCriacaoTurma(perfilUsuario: string, qtdTurmasAtuais: number, codigoGerado: string): string {
    // RN01 - Permissão - Apenas usuários com o perfil "Professor" podem criar e excluir
    //turmas no sistema
        if (perfilUsuario !== 'Professor') {
        return 'Erro: Apenas professores podem criar turmas.';
        }

        // RN02 - Limite de Turmas - Cada professor pode manter no máximo 10 turmas ativas
        //simultaneamente
        if (qtdTurmasAtuais >= 10) {
        return 'Erro: Limite máximo de 10 turmas atingido.';
        }

        // CA02 - Padrão do Código (Tamanho)
        if (codigoGerado.length !== 6) {
        return 'Erro: O código deve ter exatamente 6 caracteres.';
        }

        // CA02 - Padrão do Código (Formato Alfanumérico e Caixa Alta)
        const regex = /^[A-Z0-9]+$/;
        if (!regex.test(codigoGerado)) {
        return 'Erro: O código deve conter apenas letras maiúsculas e números.';
        }

        return 'Sucesso: Turma criada com o código ' + codigoGerado;
    }

    /**
     * Valida o fluxo de exclusão de uma turma.
     */
    solicitarExclusaoTurma(confirmacaoDoUsuario: boolean): string {
        // CA04 - Aviso de Exclusão
        if (!confirmacaoDoUsuario) {
        return 'Aviso: Esta ação desvinculará todos os alunos. O histórico será arquivado por 90 dias. Confirmar?';
        }

        // RN03 - Regra de Exclusão efetivada após confirmação
        return 'Sucesso: Turma excluída direto.';
    }
}