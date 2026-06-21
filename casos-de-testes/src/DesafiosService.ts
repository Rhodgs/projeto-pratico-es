export class DesafiosService {
    /**
        * Classe 1 e 2: Verifica se Título, Descrição e Classificação estão preenchidos
        * O que retorna: true (se tudo preenchido) ou false (se tem algum vazio)
    */
    static validarCamposCriacao(titulo: string, descricao: string, classificacao: string): boolean {
        if (!titulo.trim() || !descricao.trim() || !classificacao.trim){
            return false; // Classe Inválida 2
        }
        return true; // Classe Válida 1
    }
    /**
    * Classe 3, 4 e 5: Verifica se o Prazo Limite definido pelo professor é futuro, passado ou presente
    * O que retorna: Uma string ('FUTURO', 'PASSADO' ou 'PRESENTE')
   */
    static validarPrazoCriacao(prazoLimite: Date, dataAtual: Date): string {
        const limiteMs = prazoLimite.getTime();
        const atualMs = dataAtual.getTime();

        if (limiteMs < atualMs){
            return 'PASSADO';
        }
        if (Math.abs(limiteMs - atualMs) < 60000) {
            return 'PRESENTE';
        }
        return 'FUTURO'
    }
    /**
    * Classe 6 e 7: Verifica se o aluno enviou antes do cronômetro zerar
    * O que retorna: 'Aguardando Validação' ou 'Expirado
    */
    static verificarPrazoEnvioAluno(prazoLimite: Date, dataEnvio: Date): string {
        if (dataEnvio.getTime() > prazoLimite.getTime()) {
            return 'Expirado'; // Classe Inválida 7
        }
            return 'Aguardando Validação'; // Classe Válida 6
    }
    /**
    * Classes 8 a 12: Verifica extensão (.jpg/.png) e tamanho (0 a 5MB)
    * O que retorna: booleano
   */
    static validarTamanhoEFormato(nomeArquivo: string, tamanhoMB: number): boolean{
        const nome = nomeArquivo.toLowerCase();
        const formatoValido = nome.endsWith('.jpg') || nome.endsWith('.png'); // Classe 8
        const tamanhoValido = tamanhoMB > 0 && tamanhoMB <= 5; // Classe 10

        return formatoValido && tamanhoValido;
    }
    /**
     * Classes 13 e 14: Verifica o Tipo MIME Real (Bloqueia scripts disfarçados)
     * O que retorna: booleano
     */
    static validarTipoRealMime(nomeArquivo: string, mimeTypeDetectado: string): boolean {
        const isMimeJpg = mimeTypeDetectado === 'image/jpeg' || mimeTypeDetectado === 'image/jpg';
        const isMimePng = mimeTypeDetectado === 'image/png';
        
        if (nomeArquivo.endsWith('.jpg') && !isMimeJpg) return false; // Classe Inválida 14
        if (nomeArquivo.endsWith('.png') && !isMimePng) return false;

        return true; // Classe Válida 13
    }
    /**
     * Classes 15 e 16: Verifica se o hash é inédito no banco de dados
    * O que retorna: booleano
    */
    static validarDuplicidade(hashNovo: string, bancoHashes: string[]): boolean {
        if (bancoHashes.includes(hashNovo)) {
        return false; // Classe Inválida 16
        }
        return true; // Classe Válida 15
    }
}
