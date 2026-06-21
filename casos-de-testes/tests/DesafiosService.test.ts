// Arquivo: tests/DesafiosService.test.ts

import { DesafiosService } from '../src/DesafiosService';

describe('US4: Lançar Desafios Práticos - Nova Tabela', () => {

    test('Caso 1 (Sucesso - Professor): Desafio cadastrado com sucesso', () => {
        // Classes 1 e 3: Campos preenchidos e Prazo no Futuro
        const camposValidos = DesafiosService.validarCamposCriacao('Coleta de Lixo', 'Recolha plásticos', 'Ambiental');
        expect(camposValidos).toBe(true);

        const hoje = new Date('2026-06-20T10:00:00');
        const proximoMes = new Date('2026-07-20T10:00:00');
        const prazo = DesafiosService.validarPrazoCriacao(proximoMes, hoje);
        expect(prazo).toBe('FUTURO');
    });

    test('Caso 2 (Falha - Professor): Erro de campos obrigatórios vazios', () => {
        // Classe 2: Esquece Título e Descrição (deixa em branco)
        const camposValidos = DesafiosService.validarCamposCriacao('   ', '   ', 'Ambiental');
        expect(camposValidos).toBe(false); // O sistema bloqueia
        });

    test('Caso 3 (Falha - Professor): Erro de prazo no passado', () => {
        // Classe 4: Prazo definido para o dia anterior
        const hoje = new Date('2026-06-20T10:00:00');
        const ontem = new Date('2026-06-19T10:00:00');
        
        const prazo = DesafiosService.validarPrazoCriacao(ontem, hoje);
        expect(prazo).toBe('PASSADO'); // O sistema bloqueia
    });

    test('Caso 4 (Falha - Professor): Erro de prazo no presente/imediato', () => {
        // Classe 5: Prazo para o mesmo exato momento da criação
        const agora = new Date('2026-06-20T10:00:00');
        const mesmoMinuto = new Date('2026-06-20T10:00:15'); // 15 segundos de diferença
        
        const prazo = DesafiosService.validarPrazoCriacao(mesmoMinuto, agora);
        expect(prazo).toBe('PRESENTE'); // O sistema bloqueia
    });

    test('Caso 5 (Sucesso - Aluno): Upload concluído e aguardando validação', () => {
        // Classe 8 e 10: Imagem PNG, 2 MB
        expect(DesafiosService.validarTamanhoEFormato('foto.png', 2)).toBe(true);
        // Classe 13: Conteúdo real é imagem
        expect(DesafiosService.validarTipoRealMime('foto.png', 'image/png')).toBe(true);
        // Classe 15: Hash inédito
        expect(DesafiosService.validarDuplicidade('hash_unico', ['outros_hashes'])).toBe(true);
        // Classe 6: Envio no prazo
        const limite = new Date('2026-12-31T23:59:00');
        const envio = new Date('2026-06-20T14:00:00');
        expect(DesafiosService.verificarPrazoEnvioAluno(limite, envio)).toBe('Aguardando Validação');
    });

    test('Caso 6 (Falha - Aluno): Sistema bloqueia envio após cronômetro zerar', () => {
        // Classe 7: Tentativa após o prazo limite
        const limite = new Date('2026-06-10T23:59:00');
        const envioAtrasado = new Date('2026-06-20T14:00:00');
        
        expect(DesafiosService.verificarPrazoEnvioAluno(limite, envioAtrasado)).toBe('Expirado');
    });

});