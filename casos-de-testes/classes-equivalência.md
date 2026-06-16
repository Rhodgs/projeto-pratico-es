US1: Manter Sequência de Dias Ativos (Ofensiva) 
1. Tabela de Classes de Equivalência

| Condição de Entrada | Classes Válidas | Classes Inválidas |
| :--- | :--- | :--- |
| **Realização de login** | Login efetuado no dia civil **(1)** | Login não efetuado no dia civil **(2)** |
| **Finalização de quiz** | Quiz de conteúdo finalizado **(3)** | Quiz não finalizado ou incompleto **(4)** |
| **Resposta em desafio** | Resposta enviada no desafio prático **(5)** | Nenhuma resposta enviada no desafio **(6)** |
| **Postagem no fórum** | Postagem realizada no fórum **(7)** | Nenhuma postagem realizada no fórum **(8)** |
| **Horário da atividade** | Dentro do horário limite (00:00 às 23:59) **(9)** | Fora do horário limite (após as 23:59) **(10)** |

2. Tabela de Caso de Teste

| Casos de Teste | Classes de Equivalência | Entradas (Cenário do Teste) | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1** | 1, 3, 6, 8, 9 | Usuário realiza login e finaliza um quiz dentro do dia civil. | Ofensiva Mantida/Incrementada |
| **Caso 2** | 1, 4, 5, 8, 9 | Usuário realiza login e responde a um desafio prático dentro do dia civil. | Ofensiva Mantida/Incrementada |
| **Caso 3** | 1, 4, 6, 7, 9 | Usuário realiza login e faz uma postagem no fórum dentro do dia civil. | Ofensiva Mantida/Incrementada |
| **Caso 4** | 2, 4, 6, 8, 10 | Usuário não realiza login e não faz nenhuma atividade no dia civil. | Ofensiva Zerada ao final do dia |
| **Caso 5** | 1, 4, 6, 8, 9 | Usuário realiza login dentro do dia civil, mas não conclui nenhuma atividade válida. | Ofensiva Zerada ao final do dia |
| **Caso 6** | 1, 3, 6, 8, 10 | Usuário realiza login, mas conclui a atividade após o término do dia civil. | Ofensiva Zerada |


US2: Visualizar Ranking Escolar
1. Tabela de Classes de Equivalência

| Condição de Entrada | Classes Válidas | Classes Inválidas |
| :--- | :--- | :--- |
| **Tempo de atualização** | Atualização em até 3 segundos **(1)** | Atualização demorou mais de 3 segundos **(2)** |
| **Cor de fundo do usuário** | Fundo definido como `#F0F0F0` **(3)** | Fundo com cor diferente ou sem destaque **(4)** |
| **Borda lateral do usuário** | Borda esquerda verde de `5px` **(5)** | Borda com tamanho ou cor incorreta **(6)** |
| **Limite de exibição** | Exibir apenas os 50 estudantes com maior pontuação **(7)** | Exibir mais de 50 estudantes na lista principal **(8)** |
| **Exibição fora do Top 50** | Usuário fixado e visível na parte inferior da tela **(9)** | Usuário fora do Top 50 oculto ou no local incorreto **(10)** |
| **Unidade escolar** | Estudantes pertencem à mesma unidade **(11)** | Estudante de outra unidade aparece na lista **(12)** |
| **Desempate de pontos** | Primeiro a atingir a pontuação fica acima **(13)** | Usuário que pontuou depois fica acima **(14)** |

2. Tabela de Casos de Teste

| Casos de Teste | Classes de Equivalência | Entradas (Cenário do Teste) | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1** | 1, 3, 5, 7, 9, 11, 13 | Alteração de pontos de um aluno do Top 50 da mesma escola. | Interface atualiza em < 3s, limita a 50 alunos e destaca usuário logado. |
| **Caso 2** | 1, 3, 5, 7, 9, 11, 13 | Usuário logado está na posição 75 do ranking da escola. | Lista principal exibe o Top 50 e o usuário logado fica fixado no rodapé com estilo. |
| **Caso 3** | 1, 3, 5, 7, 9, 11, 13 | Aluno A pontua às 10:00 e Aluno B atinge mesma pontuação às 11:00. | Aluno A aparece listado acima do Aluno B no ranking por ordem cronológica. |
| **Caso 4** | 2, 3, 5, 7, 9, 11, 13 | Nova pontuação é salva no banco de dados. | Interface demora mais de 3 segundos para atualizar a tabela do ranking (Falha de performance). |
| **Caso 5** | 1, 4, 6, 7, 9, 11, 13 | Usuário logado visualiza a tela do ranking. | O item do usuário não recebe o fundo `#F0F0F0` ou a borda verde de `5px` (Falha de estilo). |
| **Caso 6** | 1, 3, 5, 8, 9, 11, 13 | Sistema carrega a tela de ranking geral. | A lista principal renderiza mais de 50 estudantes ao mesmo tempo (Falha de limite). |
| **Caso 7** | 1, 3, 5, 7, 10, 11, 13 | Usuário na posição 51 entra na tela. | O sistema deixa de exibir o usuário fixado na parte inferior da tela (Falha de ocultação). |
| **Caso 8** | 1, 3, 5, 7, 9, 12, 13 | Carregamento da lista do ranking da unidade. | Um estudante de outra escola é listado erroneamente no ranking da turma (Falha de escopo). |
| **Caso 9** | 1, 3, 5, 7, 9, 11, 14 | Dois alunos empatam e o sistema inverte as posições. | O usuário que pontuou depois fica acima sem critério (Falha de desempate). |



US3: Criar "Turmas" no Aplicativo
1. Tabela de Classes de Equivalência

| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| :--- | :--- | :--- | :--- |
| **Perfil do usuário logado** | Usuário com perfil "Professor" **(1)** | Usuário com outro perfil (ex: Aluno) **(2)** |
| **Quantidade de turmas** | Professor possui menos de 10 turmas **(3)** | Professor já possui 10 turmas ativas **(4)** |
| **Tamanho do código** | Código com exatamente 6 caracteres **(5)** | Código com menos de 6 caracteres **(6)** | Código com mais de 6 caracteres **(7)** |
| **Formato do código** | Caracteres alfanuméricos em caixa alta **(8)** | Contém caracteres minúsculos ou símbolos **(9)** |
| **Aviso ao excluir** | Sistema exibe o texto de aviso padrão **(10)** | Sistema exclui direto ou exibe texto errado **(11)** |

2. Tabela de Casos de Teste

| Casos de Teste | Classes de Equivalência | Entradas (Cenário do Teste) | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1 (Criar - Sucesso)** | 1, 3, 5, 8 | Professor com menos de 10 turmas cria uma nova turma com código válido. | Turma criada com sucesso; código gerado com 6 caracteres (ex: `AM42XP`). |
| **Caso 2 (Criar - Falha)** | 2, 3, 5, 8 | Usuário com perfil Aluno tenta forçar a criação de uma turma. | Ação bloqueada pelo sistema (Erro de permissão). |
| **Caso 3 (Criar - Falha)** | 1, 4, 5, 8 | Professor com 10 turmas ativas tenta criar mais uma sala. | Sistema bloqueia a criação e informa que o limite máximo foi atingido. |
| **Caso 4 (Criar - Falha)** | 1, 3, 6, 8 | Sistema tenta salvar um código gerado que veio curto demais (ex: `AM42X`). | Sistema rejeita a criação por ter menos de 6 caracteres. |
| **Caso 5 (Criar - Falha)** | 1, 3, 7, 8 | Sistema tenta salvar um código gerado que veio longo demais (ex: `AM42XPT`). | Sistema rejeita a criação por ter mais de 6 caracteres. |
| **Caso 6 (Criar - Falha)** | 1, 3, 5, 9 | Sistema gera código contendo letras minúsculas ou símbolos (ex: `AM@2XP`). | Sistema rejeita o formato inválido dos caracteres. |
| **Caso 7 (Criar e Excluir - Sucesso)** | 1, 3, 5, 8, 10 | Professor cria a turma corretamente e, em seguida, clica em excluir essa mesma turma. | A turma é criada e, ao clicar em excluir, o sistema exibe o pop-up com o aviso regulamentar de 90 dias. |
| **Caso 8 (Criar e Excluir - Falha)** | 1, 3, 5, 8, 11 | Professor cria a turma corretamente e, em seguida, clica em excluir essa mesma turma. | A turma é criada, mas ao clicar em excluir, ela é apagada direto sem exibir o alerta obrigatório. |

US4: Lançar Desafios Práticos
1. Tabela de Classes de Equivalência

| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| :--- | :--- | :--- | :--- |
| **Envio dentro do prazo** | Envio realizado antes do cronômetro zerar **(1)** | Envio tentado após o cronômetro zerar **(2)** |
| **Extensão do arquivo** | Arquivo com extensão `.jpg` ou `.png` **(3)** | Arquivo com extensão diferente (ex: `.pdf`, `.txt`) **(4)** |
| **Tamanho da imagem** | Arquivo maior que 0 MB e até 5 MB **(5)** | Arquivo igual a 0 MB (vazio) **(6)** | Arquivo maior que 5 MB **(7)** |
| **Tipo real do arquivo** | O conteúdo interno é realmente uma imagem **(8)** | O conteúdo interno é um script/programa disfarçado **(9)** |
| **Verificação de duplicidade** | Hash do arquivo é inédito no sistema **(10)** | Hash do arquivo já existe no sistema (duplicado) **(11)** |

2. Tabela de Casos de Teste

| Casos de Teste | Classes de Equivalência | Entradas (Cenário do Teste) | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1** | 1, 3, 5, 8, 10 | Aluno envia imagem `.png` de 2 MB no prazo, correta e inédita. | Upload concluído; status muda para "Aguardando Validação". |
| **Caso 2** | 2, 3, 5, 8, 10 | Aluno tenta fazer upload de imagem válida, mas prazo expirou. | Sistema bloqueia envio e exibe o status como "Expirado". |
| **Caso 3** | 1, 4, 5, 8, 10 | Aluno tenta anexar um arquivo `.pdf` dentro do prazo. | Sistema rejeita o arquivo por formato inválido. |
| **Caso 4** | 1, 3, 6, 8, 10 | Aluno envia arquivo corrompido que ficou com 0 MB (vazio). | Sistema recusa o upload por arquivo inválido/vazio. |
| **Caso 5** | 1, 3, 7, 8, 10 | Aluno tenta enviar uma foto pesada com 6.2 MB. | Sistema bloqueia o upload (excede o limite de 5 MB). |
| **Caso 6** | 1, 3, 5, 9, 10 | Usuário renomeia um programa malicioso para "foto.png". | Sistema analisa conteúdo interno e bloqueia arquivo disfarçado. |
| **Caso 7** | 1, 3, 5, 8, 11 | Aluno envia arquivo idêntico a um que já foi enviado antes. | Sistema rejeita o envio por detecção de duplicidade. |


US5: Acessar Relatórios Analíticos de Desempenho
1. Tabela de Classes de Equivalência

| Condição de Entrada | Classes Válidas | Classes Inválidas |
| :--- | :--- | :--- |
| **Filtro de escopo** | Turma completa ou aluno individual válido **(1)** | Aluno selecionado não pertence àquela turma **(2)** |
| **Filtro de período** | Período Semanal, Mensal ou Personalizado **(3)** | Tipo de período inexistente ou não selecionado **(4)** |
| **Intervalo de datas** | Data de início menor ou igual à data de fim **(5)** | Data de início maior do que a data de fim **(6)** |
| **Cálculo das métricas** | Indicadores calculados e atualizados na tela **(7)** | Tela renderiza erro de processamento ou dados zerados **(8)** |
| **Formato de exportação** | Exportação solicitada em formato PDF **(9)** | Tentativa de forçar exportação em outro formato (ex: `.xlsx`) **(10)** |


2. Tabela de Casos de Teste


| Casos de Teste | Classes de Equivalência | Entradas (Cenário do Teste) | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1** | 1, 3, 5, 7, 9 | Professor filtra turma por um período semanal válido. | Gráficos e indicadores gerados dinamicamente com dados na tela. |
| **Caso 2** | 1, 3, 5, 7, 9 | Professor clica no botão de exportar o relatório atual. | O arquivo é gerado e baixado com sucesso em formato PDF. |
| **Caso 3** | 2, 3, 5, 7, 9 | Sistema busca dados de um aluno de outra turma no relatório. | O sistema bloqueia a consulta (Erro: Aluno não encontrado). |
| **Caso 4** | 1, 4, 5, 7, 9 | O componente de filtro envia uma opção nula para o servidor. | Sistema mantém o último estado válido ou pede seleção de período. |
| **Caso 5** | 1, 3, 6, 7, 9 | No filtro personalizado, define Início: 15/06 e Fim: 10/06. | Sistema bloqueia filtro (Aviso: Início maior que data fim). |
| **Caso 6** | 1, 3, 5, 8, 9 | Banco de dados falha ou retorna métricas nulas/zeradas. | Tela exibe aviso amigável de erro em vez de quebrar os gráficos. |
| **Caso 7** | 1, 3, 5, 7, 10 | Usuário força requisição web pedindo planilha `.xlsx`. | O backend rejeita e bloqueia por formato não permitido. |





