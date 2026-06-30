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
