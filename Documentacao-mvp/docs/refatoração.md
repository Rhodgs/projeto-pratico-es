# Refatoração de Código

Esta seção documenta o processo de refatoração contínua aplicado ao código-fonte do projeto Jornada Verde. O objetivo principal destas intervenções foi melhorar a estrutura interna do sistema sem alterar o seu comportamento externo visível ao usuário. As refatorações detalhadas abaixo foram etapas fundamentais para garantir a escalabilidade, a legibilidade e a facilidade de manutenção do software a longo prazo.

Caso queira consultar diretamente a implementação do front-end e do back-end, acesse os links correspondentes:
* **Código Fonte:** [https://github.com/Rhodgs/projeto-pratico-es/tree/main/codigo-fonte](https://github.com/Rhodgs/projeto-pratico-es/tree/main/codigo-fonte)
* **Backend:** [https://github.com/Rhodgs/projeto-pratico-es/tree/main/backend](https://github.com/Rhodgs/projeto-pratico-es/tree/main/backend)

---

## Refatoração 1 — Extração de Classe

**Problema Identificado:**
Os cards "Progresso", "Sobre o Desafio" e "Enviar Evidência" na tela `challenge_upload_screen.dart` tinham exatamente o mesmo bloco de decoração (`Container` com `padding: 20`, fundo branco, `borderRadius: 16` e `BoxShadow`) copiado e colado três vezes no código.

**Motivação da Refatoração:**
Código duplicado é um code smell clássico. Se o estilo visual dos cards precisasse mudar (cor, sombra, borda), seria necessário editar em três lugares diferentes, com risco de inconsistência. A refatoração de Extração de Classe resolve isso isolando a estrutura repetida em um único lugar.

**Descrição da Melhoria:**
Foi criado o widget `_SectionCard`, que encapsula a decoração padrão e recebe um `child`. Os três `Container` duplicados foram substituídos por chamadas a `_SectionCard(child: ...)`, seguindo o mesmo padrão já usado em `_StatCard` e `_CronometroCard`.

**Impacto no Sistema:**
Eliminação de ~40 linhas duplicadas. Qualquer alteração futura no estilo dos cards passa a ser feita em um único lugar, reduzindo risco de inconsistência visual e facilitando a manutenção.

---

## Refatoração 2 — Mover Método

**Problema Identificado:**
O método `_formatXp(int xp)`, responsável por formatar o número de XP com separador de milhar, estava definido dentro do widget `_PositionCard` em `progress_ranking_screen.dart`. Widgets não deveriam ter responsabilidade de formatar dados — e o widget `_RankingRow`, que também exibe XP, não tinha acesso a esse método, exibindo o valor sem formatação.

**Motivação da Refatoração:**
Um método deve estar na classe que possui os dados que ele manipula. Como `_formatXp` opera sobre o campo `xp`, ele pertence à classe `_RankingEntry`, não ao widget visual que o exibe. Manter o método no widget viola o princípio de coesão e impede o reuso.

**Descrição da Melhoria:**
O método `_formatXp` foi movido para a classe `_RankingEntry` como o getter `xpFormatado`. O `_PositionCard` passou a usar `user.xpFormatado` em vez de chamar o método local, e o `_RankingRow` também passou a usar `entry.xpFormatado`, ganhando a formatação que antes não tinha.

**Impacto no Sistema:**
A lógica de formatação ficou centralizada na classe de dados, eliminando duplicação potencial. Qualquer widget que use `_RankingEntry` agora pode acessar o XP formatado sem reescrever a lógica, aumentando a coesão e a reutilização do código.

--- 

## Refatoração 3 — Renomeação de Variável (e Padronização de Tipos)

**Problema Identificado:**
Durante a integração das branches `feat/gestao-professor` e `feat/autenticacao-base`, os modelos de dados para Desafio e Evidencia estavam incompatíveis. Havia divergências na tipagem de datas (tratadas como string em um local e Date em outro), divergências na capitalização de status (pendente minúsculo vs Pendente maiúsculo) e ambiguidade nos nomes dos atributos de recompensa (xpRecompensa vs pontuacao)

**Motivação da Refatoração:**
Nomes de variáveis confusos e tipagens inconsistentes quebram o contrato da API e geram erros de compilação ou falhas de integração com o frontend. Essa inconsistência é um `code smell` (código-fonte que aponta para um problema estrutural) que impede a escalabilidade do modelo de domínio, sendo necessário renomear e padronizar os dados para garantir uma única fonte da verdade.

**Descrição da Melhoria:**
Os atributos foram renomeados e consolidados em um modelo único. O status foi padronizado estritamente em minúsculo, as datas foram unificadas para o tipo Date nativo, e os atributos redundantes de pontuação foram mesclados.

**Impacto no Sistema:**
Prevenção de quebra de tipagem no frontend e eliminação dos erros de compilação no TypeScript (ts-node). O sistema agora opera com um modelo de domínio padronizado e confiável, facilitando a criação de novas funcionalidades sem risco de incompatibilidade de dados.

--- 

## Refatoração 4 – Decompor Método (Extract Method)

* **Problema Identificado:** O método principal `cadastrar` acumulava manualmente a lógica bruta de todas as regras de negócio em condicionais densas e encadeadas. Ele apresentava o code smell de *Método Longo*, misturando funções de validação de dados com a persistência final no array em memória.
* **Motivação da Refatoração:** Centralizar múltiplas responsabilidades em um único bloco de código reduz drasticamente a manutenibilidade e aumenta a chance de efeitos colaterais. Isolar essas checagens garante maior coesão e simplifica manutenções futuras.
* **Descrição da Melhoria:** A técnica de *Extract Method* foi aplicada para isolar o bloco de checagens obrigatórias em uma subfunção privada e semântica chamada `executarValidacoesCadastro`. Com essa extração, o fluxo principal de cadastro tornou-se enxuto, delegando a responsabilidade de verificar nome, e-mail único, formato e complexidade de senha para uma rotina dedicada. Essa abordagem eleva o alinhamento do código com o Princípio de Responsabilidade Única (SRP) e simplifica de forma significativa o isolamento de testes unitários automatizados para o comportamento do sistema. O código central passou a descrever o algoritmo de cadastro de forma limpa e linear, facilitando a legibilidade imediata por outros membros da equipe de engenharia.
* **Impacto no Sistema:** Limpeza do fluxo principal de persistência do usuário e melhoria na reutilização e manutenção do código de validações. O código atende diretamente aos critérios de aceitação e regras de negócio de e-mail e senhas da história de usuário **US13**.

---

## Refatoração 5 – Substituir Condicional por Cláusulas de Guarda (Replace Conditional with Guard Clauses)

* **Problema Identificado:** O método de criação de desafios `criarDesafio` utilizava fluxos alternativos implícitos e estruturas condicionais para gerenciar os caminhos de falha (como prazos expirados ou campos vazios). Isso forçava o fluxo de sucesso ("caminho feliz") a ficar aninhado e dependente.
* **Motivação da Refatoração:** Estruturas condicionais excessivamente aninhadas aumentam a complexidade ciclomática do algoritmo e geram o anti-padrão conhecido como código em seta (*Arrow Anti-pattern*), tornando a varredura visual lenta e confusa.
* **Descrição da Melhoria:** Esta refatoração introduziu Cláusulas de Guarda no início do método `criarDesafio` para validar e rejeitar os cenários de falha de maneira imediata. Em vez de envolver o algoritmo principal em ramificações complexas de tomadas de decisão, a função avalia as violações de negócio logo na entrada e dispara exceções com comandos `throw` explícitos. Esse modelo assegura que restrições cruciais da história de usuário — tais como campos em branco ou prazos definidos no passado — sejam interrompidas na periferia da função. A organização simplificou a leitura do código, permitindo que a lógica de sucesso seja executada de forma perfeitamente linear ao término das checagens, reduzindo significativamente a carga cognitiva necessária no desenvolvimento.
* **Impacto no Sistema:** Eliminação completa do aninhamento profundo de blocos `if/else`, garantindo código linear e de fácil leitura. Assegura a integridade estrita do plano de testes e das regras da história de usuário **US4** para prazos e validação.

---

## Refatoração 6 – Renomear Parâmetro (Rename Parameter)

* **Problema Identificado:** Os controladores de gerenciamento do professor utilizavam o identificador genérico e abstrato `id` (via `req.params.id`) para tratar o recebimento de arquivos de evidência. Essa nomenclatura gerava ambiguidade conceitual com os próprios identificadores de desafios do sistema.
* **Motivação da Refatoração:** Identificadores ambíguos ou excessivamente curtos quebram a clareza e legibilidade do código, agindo como barreiras ocultas que podem induzir os desenvolvedores ao erro de misturar chaves estrangeiras distinctas durante a manutenção.
* **Descrição da Melhoria:** Aplicou-se a refatoração de *Rename Parameter* nas assinaturas de requisição do Express para substituir a variável genérica `id` por `evidenciaId`. Essa renomeação foi estendida tanto para as definições de rotas no arquivo central do servidor quanto para as assinaturas internas e desestruturações de parâmetros feitas no controlador de desafios. Com essa alteração, o código eliminou qualquer ambiguidade de escopo entre entidades de missões e arquivos de envio, agindo como uma documentação viva e implícita da API do backend. A padronização protege a integridade conceitual do modelo de domínio do ecossistema, facilitando o entendimento de onde cada referência deve ser consumida para o lançamento de notas do professor.
* **Impacto no Sistema:** Prevenção de falhas ocultas por cruzamento incorreto de identificadores e aumento da coesão do código nos controladores. Fornece suporte claro aos endpoints de avaliação manual da história de usuário **US11**.
