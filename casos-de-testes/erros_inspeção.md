# Inspeção e Refatoração de Requisitos - Jornada Verde

Abaixo, apresentamos um resumo detalhado sobre os maiores erros e problemas encontrados na fase de inspeção do nosso backlog inicial pelo outro grupo. O documento mapeia cada falha identificada nas Histórias de Usuário e explica como elas foram corrigidas e refatoradas na nossa versão final.

**Links Importantes:**
* [Backlog do Produto Revisado](https://github.com/users/Rhodgs/projects/3)
* [Quadro de Problemas Apontados (Inspeção)](https://github.com/users/Rhodgs/projects/6)

---

### **US1: Sequência de Dias Ativos (Ofensiva)**
* **Erros Encontrados:**
  1. A contagem "intervalo superior a 24 horas" era vaga.
  2. "Completar uma atividade" não definia quais ações o sistema deveria validar.
* **Correção Realizada:** O intervalo foi fixado como um dia civil (00:00 às 23:59 no fuso do usuário). As atividades válidas foram listadas explicitamente: finalizar quiz, enviar evidência de desafio ou postar no fórum.

### **US2: Ranking Escolar**
* **Erros Encontrados:**
  1. O termo "Tempo real" era interpretativo para a programação.
  2. Pedir uma posição "destacada" não fornecia parâmetros visuais.
  3. Omissão da origem dos "pontos ganhos".
  4. Falta de critérios de desempate e limites de exibição da lista.
* **Correção Realizada:** A lista foi restrita ao Top 50, com a atualização reativa acontecendo em no máximo 3 segundos após a persistência no banco. O destaque visual foi padronizado (fundo cinza claro, borda lateral verde `#28A745`). Empates agora são resolvidos por ordem cronológica.

### **US3: Criação de Turmas**
* **Erros Encontrados:**
  1. Omissão do formato limite para o "código alfanumérico".
  2. Falta de funcionalidades básicas de gestão do professor (ver lista, remover aluno).
  3. Falta de política de retenção ao excluir turmas, gerando risco de apagar dados vitais.
* **Correção Realizada:** O código de convite agora tem exatamente 6 caracteres. Foram incluídos botões de "Remover Aluno" no painel de gestão e o professor ficou limitado a 10 turmas ativas. Na exclusão, foi aplicada uma política de retenção movendo os dados para um arquivo morto por 90 dias antes da exclusão permanente.

### **US4: Lançar Desafios Práticos**
* **Erros Encontrados:**
  1. Contradição de atores (exigir botão de "Anexar" para o aluno dentro da história do professor).
  2. Omissão crítica: o sistema não sabia o que fazer quando o cronômetro do desafio chegava a zero.
  3. Indefinição sobre o gatilho que marcava o desafio como "concluído".
  4. Falta de mecanismos de segurança no recebimento de arquivos.
* **Correção Realizada:** Interfaces divididas entre "Criação" (Professor) e "Execução" (Aluno). Quando o tempo zera, o sistema bloqueia novos uploads e marca como "Expirado". A conclusão atrelou-se à aprovação do professor. Adicionou-se segurança via *MIME-type* (apenas JPG/PNG), sanitização de nomes e validação de Hash para bloquear envios duplicados.

### **US5: Relatórios de Desempenho**
* **Erros Encontrados:**
  1. Termos abstratos sem definições ("impacto real", "engajamento", "evolução").
  2. Omissão da interface de filtros (por aluno, turma, data).
* **Correção Realizada:** A interface ganhou filtros obrigatórios de Escopo (individual/turma) e Período (semanal/mensal). As métricas ganharam cálculos exatos: Impacto (desafios validados), Engajamento (taxa de participação vs. logins) e Evolução (curva de média de pontos acumulados).

### **US6: Acessibilidade Visual**
* **Erros Encontrados:**
  1. O termo "total autonomia" era inalcançável e subjetivo.
  2. Afirmar que "fundo preto e texto amarelo" resolvia a baixa visão estava incorreto perante o padrão WCAG.
  3. "Amarelo vibrante" não possui correspondência técnica no código.
* **Correção Realizada:** "Total autonomia" foi removido. A interface passou a exigir três paletas específicas com códigos hexadecimais: Escuro (`#000000` / `#FFFFFF`), Daltonismo e Suave, garantindo contraste mínimo de 7:1 (padrão WCAG). Também foi exigida a opção de ampliar a fonte em até 200%.

### **US7: Acessibilidade (Leitores de Tela)**
* **Erros Encontrados:**
  1. A regra para ocultar "elementos meramente estéticos" era interpretativa.
  2. Omissão total sobre o leitor anunciar a mudança de estados (Carregando, Selecionado).
* **Correção Realizada:** Foram definidos exatamente os itens decorativos a ocultar (ícones sem texto, linhas divisórias, fundos sem contexto). O sistema foi obrigado a ditar feedbacks de voz específicos de estado ("Desabilitado", "Selecionado", "Por favor aguarde").

### **US8: Interface Minimalista**
* **Erros Encontrados:**
  1. A expressão "limpa e sem firulas" não serve de diretriz para design.
  2. O requisito limitava o menu a "máximo de 5 itens", mas não definia quais seriam.
* **Correção Realizada:** Os 5 itens da barra inferior foram fixados: Início, Desafios, Impacto, Perfil e Configurações. As diretrizes visuais impuseram *Flat Design*, proibição de texturas, transições de máximo 300ms e obrigação de 30% de respiro nas telas.

### **US9: Recompensas e Feedbacks**
* **Erros Encontrados:**
  1. Omissão quanto aos tipos de recompensas existentes.
  2. "Feedbacks instantâneos" era um prazo vago.
  3. Exigir pontos atribuídos "no mesmo instante" era uma falha arquitetural que ignorava queda de conexão ou latência.
  4. Ambiguidade no gatilho para "finalizar uma missão".
* **Correção Realizada:** Recompensas divididas em numéricas (XP) e visuais (Medalhas). O feedback foi parametrizado em até 1 segundo após o servidor confirmar a transação. Criou-se tolerância a falhas (arquitetura *offline-first*): se a internet cair, o progresso salva no dispositivo e sincroniza em segundo plano.

### **US10: Consumo de Vídeos**
* **Erros Encontrados:**
  1. O termo "vídeos curtos" não definia um limite de duração.
  2. Omissão dos recursos básicos de um player e da forma de navegação.
  3. Falta de acessibilidade de mídia (Legenda/Audiodescrição).
  4. Omissão sobre a origem da publicação dos vídeos.
* **Correção Realizada:** A exclusividade de publicação foi atribuída aos Administradores do sistema. O player ganhou um *feed* vertical de rolagem com controles nativos, *Closed Captions* (CC) e opções para audiodescrição. A duração dos vídeos foi definida de forma flexível, permitindo conteúdos de tamanhos variados sem o limite estrito de 15 segundos.

### **US11: Validação de Evidências (Professor)**
* **Erros Encontrados:**
  1. Inconsistência lógica com a US9 (sobre o momento de computar pontos).
  2. Falta do fluxo de justificativa (caixa de texto para recusar).
  3. "Botões claros" feria regras de Interação Humano-Computador.
  4. Omissão na organização, sem filtros em turmas grandes.
* **Correção Realizada:** O conflito foi sanado estipulando que o status fica "Pendente" na carteira do aluno até o professor aprovar manualmente. A tela ganhou filtros por "Turma" e ordenação cronológica. Foi criada uma janela Modal obrigatória para justificar recusas, utilizando botões de núcleos semânticos (Verde/Aprovar, Vermelho/Recusar).

### **US12: Guia Passo a Passo (Tutorial)**
* **Erros Encontrados:**
  1. Ambiguidade sobre "primeiro acesso" (geral do app ou por tela?).
  2. Falta de opção para o aluno controlar o tutorial (pular ou fechar).
  3. Alvos subjetivos ("apontar para botões principais").
  4. A palavra "interativo" não definia a interface real.
* **Correção Realizada:** Os alvos dos balões de foco foram explícitos (Missões, Perfil e Ranking). Implementaram-se controles vitais ("Próximo", "Anterior", "Pular"). Se o usuário pular ou fechar o app, o guia é concluído, mas pode ser reiniciado pelas configurações do perfil a qualquer momento.

### **US13: Cadastro de Perfil**
* **Erros Encontrados:**
  1. Expressão vaga de "perfil personalizado".
  2. Falta total de delimitação e regras de força para Nome e Senha.
* **Correção Realizada:** Foco voltado a "cadastro básico", cobrando validações técnicas: E-mail único, Nome exige mínimo de 3 caracteres, Senha exige mínimo de 8 caracteres contendo pelo menos uma letra e um número.

### **US14: Notificações**
* **Erros Encontrados:**
  1. Nenhuma concepção visual ou de conteúdo para a notificação de nova missão.
* **Correção Realizada:** O texto do push foi padronizado. Título fixo: "Novo Desafio!". Corpo dinâmico: "[Nome do Professor] lançou a missão [Nome da Missão]". O clique redireciona direto para os detalhes do desafio.

### **US15: Selos e Conquistas**
* **Erros Encontrados:**
  1. Falta de limites (quantos selos um professor envia por semana?).
  2. Omissão de armazenamento histórico dos itens após fechar a notificação.
* **Correção Realizada:** Estabeleceu-se uma escassez de 5 envios semanais por turma para cada professor. O sistema criou a "Galeria de Conquistas" para gerenciar e abrigar a permanência de todos os itens. As regras estipulam que o acesso a esses broches e selos é restrito apenas ao dono do perfil privado.

