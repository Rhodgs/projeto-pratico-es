### 1. Introdução

O Backlog do Produto é uma lista priorizada das funcionalidades desejadas para o sistema Jornada Verde . Ele serve como guia para o desenvolvimento incremental. garantindo que a equipe foque no que gera mais valor para o usuário.

### 2. Link para o Quadro no GitHub

A gestão dinâmica das histórias de usuário (colunas de Especificação. Revisão e Implementação) é realizada através do GitHub Projects .

> **https://github.com/users/Rhodgs/projects/3**

### Brainstorming (Ideação)

* [Link para a Página de Ideação no Notion](https://www.notion.so/fe8f30e12a868315ab6a0183fab176e2?v=1faf30e12a8682e58384082dc8c99227&source=copy_link)



### 3. Lista de Histórias de Usuário

Todas as histórias seguem o padrão: "Enquanto [persona]. desejo [funcionalidade] para [benefício]" . </br>

| ID|Persona|História de Usuário| Status (Coluna GitHub) |
|-|-|-|-|
| US01|Ana Luiza|"Enquanto estudante, desejo manter uma sequência de dias ativos para me sentir motivada a interagir diariamente."|Implementação |
| US02|Ana Luiza|"Enquanto estudante, desejo visualizar um ranking em tempo real para utilizar a comparação saudável como incentivo."|Implementação |
| US03|João Marcos|"Enquanto professor, desejo criar turmas com códigos exclusivos para organizar meus alunos de forma prática ."|Implementação |
| US04 |Joao Marcos|"Enquanto Professor, desejo lançar desafios que exijam ações reais para incentivar os alunos a aplicarem a teoria em causas ambientais na comunidade"|Implementação |
| US05|João Marcos|"Enquanto professor, desejo acessar relatórios de desempenho para validar a eficácia das atividades."|Implementação |
| US06|Lucas Pereira|"Enquanto usuário com baixa visão, desejo ativar um modo de alto contraste para utilizar a plataforma com autonomia."|Implementação |
| US07 | Lucas Pereira | "Enquanto estudante que utiliza leitores de tela, desejo que cada botão e elemento interativo possua um rótulo textual descritivo detalhado para compreensão das ações." | Implementação |
| US08 | Lucas Pereira | "Enquanto usuário, desejo utilizar uma interface limpa e livre de distrações para concentrar minha atenção nas missões ambientais." | Implementação |
| US09 | Ana Luiza | "Enquanto estudante, desejo receber confirmações visuais e recompensas no momento em que concluo uma ação para reforçar meu progresso." | Implementação |
| US10 | Ana Luiza | "Enquanto estudante, desejo consumir materiais educativos através de vídeos curtos e objetivos para aprender conceitos de forma dinâmica." | Implementação |
| US11 | João Marcos | "Enquanto professor, desejo validar as evidências enviadas pelos alunos para garantir que as missões práticas foram cumpridas."  | Implementação |
| US12 | Ana Luiza | "Enquanto estudante, desejo utilizar um guia passo a passo interativo para aprender a usar novas funcionalidades sem esquecer as etapas."  | Implementação* |
| US13 | Lucas Pereira | "Enquanto usuário, desejo realizar o cadastro no sistema criando um perfil personalizado para salvar meu progresso na jornada." | Implementação |
| US14 | Ana Luiza | "Enquanto usuário, desejo receber notificações sobre novos desafios semanais lançados para me manter engajado com a causa." | Implementação |
| US15 | Ana Luiza | "Enquanto estudante, desejo receber selos de 'Destaque' enviados pelo meu professor para ter meu esforço reconhecido perante a turma." |Implementação |

### 4. Detalhamento das Histórias (10+ detalhadas)

Abaixo estão as especificações técnicas das histórias que já possuem critérios de aceitação e regras de negócio definidos:
* US01: Sequência de Dias Ativos (Streaks)

    * Critérios de Aceitação (CA): O sistema deve exibir um ícone de fogo e um contador numérico de dias seguidos no perfil .

    * Regras de Negócio (RN): O contador deve ser zerado se o usuário não realizar login e completar uma atividade em mais de 24 horas .

* US03: Criação de Turmas

    * Critérios de Aceitação (CA): Deve fornecer um botão "Criar Turma" que gera um código alfanumérico único automaticamente .

    * Regras de Negócio (RN): Apenas usuários com perfil "Professor" podem criar ou excluir turmas .

* US06: Modo de Alto Contraste

    * Critérios de Aceitação (CA): Aplicar instantaneamente fundo preto sólido com textos em amarelo vibrante ao ativar a função .

    * Regras de Negócio (RN): A preferência deve ser salva no banco de dados para acessos futuros .

* US07: Rótulos para Acessibilidade

    * Critérios de Aceitação (CA): Botões devem ser anunciados por TalkBack com sua função específica (ex: "Botão Voltar") .

    * Regras de Negócio (RN): Elementos meramente estéticos devem ser ocultados para leitores de tela .

* US08: Interface Limpa

    * Critérios de Aceitação (CA): O menu principal deve ter no máximo 5 itens e não deve possuir animações automáticas .

* US09: Gratificação Imediata

    * Critérios de Aceitação (CA): Mensagem de sucesso deve aparecer em menos de 1 segundo após finalizar uma missão .

    * Regras de Negócio (RN): Os pontos devem ser exibidos no perfil no mesmo instante da conclusão .

* US11: Validação de Evidências

    * Critérios de Aceitação (CA): Professor visualiza a foto e possui os botões "Aprovar" ou "Recusar com Justificativa" .

    * Regras de Negócio (RN): A pontuação só é atribuída ao aluno após confirmação manual do professor.

* US13: Cadastro de Perfil

    * Critérios de Aceitação (CA): O formulário exige Nome, E-mail, Senha e Tipo de Perfil (Aluno ou Professor).

    * Regras de Negócio (RN): Impede o registro de dois usuários com o mesmo e-mail.

* US14: Notificações Push

    * Critérios de Aceitação (CA): Enviar notificação push sempre que o professor da turma publicar uma nova missão.

* US15: Selos de Destaque

    * Critérios de Aceitação (CA): O selo deve aparecer em um pop-up na tela inicial do aluno no próximo login.

    * Regras de Negócio (RN): Aluno só recebe selos de professores vinculados à mesma turma.
