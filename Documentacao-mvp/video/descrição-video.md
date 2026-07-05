## 📺 Demonstração Audiovisual e Operacional do MVP

### Relatório Detalhado do Fluxo de Validação:

O vídeo comprova de forma prática a integração de ponta a ponta entre a interface construída no Flutter e as regras de negócio distribuídas nos serviços e controllers do backend em Node.js (TypeScript). A apresentação simulada cobre detalhadamente as duas visões do sistema:

#### 1. Fluxo de Autenticação e Cadastro Inicial (US13)
* **Interação:** O vídeo inicia na tela de boas-vindas e segue para o formulário de cadastro. É demonstrada a inserção dos dados do usuário ("samara Cruz") e a validação do formato de e-mail institucional.
* **Comportamento das Regras:** É testada a inserção da senha atendendo aos critérios de complexidade (mínimo de 8 caracteres, exigindo uma letra maiúscula e um número). O sistema valida a alternância de estado dos botões de seleção de perfil ("ALUNO" e "PROFESSOR") e condiciona a ativação do botão "Cadastrar" ao aceite obrigatório dos Termos de Uso e Política de Privacidade através do Checkbox de consentimento.

#### 2. A Experiência Engajadora do Estudante (Área do Aluno — US1, US2, US6, US9)
* **Dashboard e Ofensiva (US1):** Ao acessar o perfil do aluno ("Olá, Alex!"), a interface exibe o painel principal com o nível atual do usuário e a contagem de Experiência (1250/2000 XP). É possível visualizar o ícone de fogo e o contador numérico de dias seguidos (ofensiva) ativo no canto superior, incentivando a interação diária com a plataforma.
* **Feed de Missões e Cronômetro (US4/US9):** O estudante navega pelas "Missões Ecológicas" e acessa os detalhes do desafio prático "Herói da Reciclagem" (Separe 10 itens recicláveis esta semana). A tela apresenta um cronômetro regressivo em tempo real com o tempo restante exato para a conclusão (*7D 00:00:00*), detalha as regras de como participar e disponibiliza o fluxo seguro para anexar e enviar a evidência fotográfica.
* **Ranking Reativo Escolar (US2):** Na aba "Impacto/Progresso", o sistema carrega o ranking de classificação geral da unidade escolar. A interface destaca o item correspondente ao usuário logado ("Alex") com o fundo diferenciado em cinza claro e uma borda lateral esquerda verde de 5px, posicionando-o de forma transparente e competitiva em relação aos colegas (Ana Silva, Bruno Costa e Carla Dias).
* **Configurações e Acessibilidade (US6):** É demonstrada a flexibilidade da plataforma na aba de configurações visuais, onde o usuário realiza o ajuste dinâmico da escala de fontes (tamanho aumentado para 20 pixels) e testa os seletores de paleta de alto contraste, alternando com feedback instantâneo entre o Modo Escuro e o Modo Daltonismo sem qualquer travamento.

#### 3. Painel de Gestão de Turmas do Professor (US3)
* **Interação:** Através do menu de apresentação, o fluxo alterna para o perfil de docente ("Olá, Prof. Carlos!"), renderizando o painel geral de turmas ativas. É exibido o fluxo de exclusão de uma turma, disparando o modal de confirmação com a mensagem de aviso obrigatória: *"Esta ação desvinculará todos os alunos... O histórico será arquivado por 90 dias. Confirmar?"*.
* **Criação de Código Único:** O vídeo exibe o acionamento do botão flutuante para criação de uma "Nova Turma", com seletores customizados para o Ano Letivo (Ex: "3º Ano") e Identificador (Ex: "Turma 03"). Ao clicar em "Criar", o backend gera instantaneamente o código alfanumérico único de 6 caracteres em caixa alta (`01OHMA`), emitindo o feedback visual na barra inferior e permitindo a cópia direta para a área de transferência do dispositivo.

#### 4. Monitoramento e Validação Manual de Evidências (US11)
* **Interação:** O painel "Validar Evidências" exibe a fila de triagem com os envios pendentes de avaliação realizados pelos estudantes anexados à turma.
* **Atribuição Reativa de Recompensas:** A interface renderiza o card individual de cada aluno contendo o nome, o desafio vinculado e os botões de ação com cores semânticas ("Aprovar" em verde e "Recusar" em vermelho). O fluxo valida a regra de negócio de que os pontos de experiência (XP) permanecem retidos no extrato como pendentes e só são creditados de forma permanente no saldo do perfil do estudante após a validação e clique manual do professor, garantindo a integridade contra fraudes ou duplicidades de arquivos de imagem no sistema.
