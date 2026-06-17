import { TurmaService } from '../src/TurmaService';

describe('Testes de Classes de Equivalência - US3 (Criar e Gerenciar Turmas)', () => {
    let turmaService: TurmaService;

    // Prepara o ambiente antes de cada teste
    beforeEach(() => {
        turmaService = new TurmaService();
    });

    it('Caso 1 (Criar - Sucesso): Professor com menos de 10 turmas cria com código válido', () => {
        const resultado = turmaService.validarCriacaoTurma('Professor', 3, 'AM42XP');
        expect(resultado).toBe('Sucesso: Turma criada com o código AM42XP');
    });

    it('Caso 2 (Criar - Falha): Usuário com perfil Aluno tenta forçar a criação', () => {
        const resultado = turmaService.validarCriacaoTurma('Aluno', 0, 'AM42XP');
        expect(resultado).toBe('Erro: Apenas professores podem criar turmas.');
    });

    it('Caso 3 (Criar - Falha): Professor com 10 turmas ativas tenta criar mais uma', () => {
        const resultado = turmaService.validarCriacaoTurma('Professor', 10, 'AM42XP');
        expect(resultado).toBe('Erro: Limite máximo de 10 turmas atingido.');
    });

    it('Caso 4 (Criar - Falha): Sistema tenta salvar código muito curto', () => {
        const resultado = turmaService.validarCriacaoTurma('Professor', 5, 'AM42X');
        expect(resultado).toBe('Erro: O código deve ter exatamente 6 caracteres.');
    });

    it('Caso 5 (Criar - Falha): Sistema tenta salvar código muito longo', () => {
        const resultado = turmaService.validarCriacaoTurma('Professor', 5, 'AM42XPT');
        expect(resultado).toBe('Erro: O código deve ter exatamente 6 caracteres.');
    });

    it('Caso 6 (Criar - Falha): Código gerado contém símbolos ou letras minúsculas', () => {
        const resultado = turmaService.validarCriacaoTurma('Professor', 5, 'AM@2XP');
        expect(resultado).toBe('Erro: O código deve conter apenas letras maiúsculas e números.');
    });

    it('Caso 7 (Criar e Excluir - Sucesso): Professor clica em excluir e sistema exige confirmação', () => {
        // O backend recebe o pedido de exclusão sem a flag de confirmação final (false)
        const resultado = turmaService.solicitarExclusaoTurma(false);
        expect(resultado).toBe('Aviso: Esta ação desvinculará todos os alunos. O histórico será arquivado por 90 dias. Confirmar?');
    });

    it('Caso 8 (Criar e Excluir - Prevenção de Falha): Garante que a turma não é apagada direto', () => {
        // Se um desenvolvedor alterar a lógica e tentar excluir direto sem o pop-up de aviso prévio,
        // este teste falhará, protegendo o sistema contra o erro descrito no Caso 8.
        const resultado = turmaService.solicitarExclusaoTurma(false);
        expect(resultado).not.toBe('Sucesso: Turma excluída direto.');
    });
});
