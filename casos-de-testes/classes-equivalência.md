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
| **Caso 1 (Sucesso)** | 1, 3, 6, 8, 9 | Usuário realiza login e finaliza um quiz dentro do dia civil. | Ofensiva Mantida/Incrementada |
| **Caso 2 (Sucesso)** | 1, 4, 5, 8, 9 | Usuário realiza login e responde a um desafio prático dentro do dia civil. | Ofensiva Mantida/Incrementada |
| **Caso 3 (Sucesso)** | 1, 4, 6, 7, 9 | Usuário realiza login e faz uma postagem no fórum dentro do dia civil. | Ofensiva Mantida/Incrementada |
| **Caso 4 (Falha)** | 2, 4, 6, 8, 10 | Usuário não realiza login e não faz nenhuma atividade no dia civil. | Ofensiva Zerada ao final do dia |
| **Caso 5 (Falha)** | 1, 4, 6, 8, 9 | Usuário realiza login dentro do dia civil, mas não conclui nenhuma atividade válida. | Ofensiva Zerada ao final do dia |
| **Caso 6 (Falha)** | 1, 3, 6, 8, 10 | Usuário realiza login, mas conclui a atividade após o término do dia civil. | Ofensiva Zerada |

---

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
| **Caso 1 (Sucesso)** | 1, 3, 5, 7, 9, 11, 13 | Aluno do Top 50 ganha novos pontos e a interface recebe os dados normalmente da mesma escola. | Interface atualiza em < 3s, limita a 50 alunos e destaca o usuário logado perfeitamente. |
| **Caso 2 (Sucesso)** | 1, 3, 5, 7, 9, 11, 13 | Usuário logado está na posição 75 e visualiza o ranking da sua escola com sucesso. | Lista principal exibe o Top 50 e o usuário logado fica fixado no rodapé com seu estilo de destaque. |
| **Caso 3 (Sucesso)** | 1, 3, 5, 7, 9, 11, 13 | Alunos empatam na pontuação, mas o sistema identifica corretamente que o Aluno A pontuou mais cedo. | Aluno A aparece listado acima do Aluno B no ranking por ordem cronológica. |
| **Caso 4 (Falha)** | 2, 3, 5, 7, 9, 11, 13 | Nova pontuação é salva no banco, mas a interface do aplicativo sofre uma lentidão extrema ao buscar os dados. | Interface demora mais de 3 segundos para atualizar a tabela do ranking (Falha de performance). |
| **Caso 5 (Falha)** | 1, 4, 6, 7, 9, 11, 13 | Usuário logado visualiza a tela do ranking, mas o aplicativo falha ao carregar os estilos visuais dele. | O item do usuário logado não recebe o fundo `#F0F0F0` e nem a borda verde de `5px` (Falha de estilo). |
| **Caso 6 (Falha)** | 1, 3, 5, 8, 9, 11, 13 | Sistema carrega a tela de ranking, mas falha no limite de paginação e tenta puxar todos os alunos de uma vez. | A lista principal renderiza mais de 50 estudantes ao mesmo tempo, quebrando o layout (Falha de limite). |
| **Caso 7 (Falha)** | 1, 3, 5, 7, 10, 11, 13 | Usuário que está fora do Top 50 entra na tela, mas o sistema apresenta erro de interface e não fixa o nome dele. | O sistema deixa de exibir o usuário fixado na parte inferior da tela (Falha de ocultação). |
| **Caso 8 (Falha)** | 1, 3, 5, 7, 9, 12, 13 | Sistema carrega a lista do ranking, mas o banco de dados falha no filtro e mistura escolas diferentes. | Um estudante de outra escola é listado erroneamente no ranking da turma atual (Falha de escopo). |
| **Caso 9 (Falha)** | 1, 3, 5, 7, 9, 11, 14 | Dois alunos empatam na pontuação, mas o algoritmo de desempate falha e inverte as posições. | O usuário que pontuou depois acaba ficando acima no ranking sem critério válido (Falha de desempate). |

---

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

---

US4: Lançar Desafios Práticos

1. Tabela de Classes de Equivalência

| Condição de Entrada | Classes Válidas | Classe Inválida 1 | Classe Inválida 2 |
| :--- | :--- | :--- | :--- |
| **Campos de criação (CA1)** | Título, descrição e classificação preenchidos **(1)** | Um ou mais campos em branco **(2)** | - |
| **Prazo limite (CA1)** | Data e hora definidas para o futuro **(3)** | Data e hora definidas no passado **(4)** | Data e hora definidas no presente/mesma hora **(5)** |
| **Envio dentro do prazo** | Envio realizado antes do cronômetro zerar **(6)** | Envio tentado após o cronômetro zerar **(7)** | - |
| **Extensão do arquivo** | Arquivo com extensão `.jpg` ou `.png` **(8)** | Arquivo com extensão diferente (ex: `.pdf`) **(9)** | - |
| **Tamanho da imagem** | Arquivo maior que 0 MB e até 5 MB **(10)** | Arquivo igual a 0 MB (vazio) **(11)** | Arquivo maior que 5 MB **(12)** |
| **Tipo real do arquivo** | O conteúdo interno é realmente uma imagem **(13)** | O conteúdo interno é um script/programa disfarçado **(14)** | - |
| **Verificação de duplicidade** | Hash do arquivo é inédito no sistema **(15)** | Hash do arquivo já existe no sistema (duplicado) **(16)** | - |

2. Tabela de Casos de Teste (Padronizada com 7 classes por linha)

| Casos de Teste | Classes de Equivalência | Entradas (Cenário do Teste) | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1 (Sucesso - Professor)** | 1, 3, 6, 8, 10, 13, 15 | Professor preenche título, descrição, escolhe a classificação e define um prazo limite para o mês seguinte. | O desafio é cadastrado com sucesso e fica disponível para os alunos da turma. |
| **Caso 2 (Falha - Professor)** | 2, 3, 6, 8, 10, 13, 15 | Professor tenta criar o desafio, mas esquece de preencher o Título e a Descrição. (Erro: Campos obrigatórios vazios). | O sistema bloqueia a criação e exige o preenchimento dos campos em branco. |
| **Caso 3 (Falha - Professor)** | 1, 4, 6, 8, 10, 13, 15 | Professor preenche todos os textos, mas define o prazo limite do desafio para o dia anterior. (Erro: Prazo no passado). | O sistema bloqueia a criação e exige que a data e hora sejam no futuro. |
| **Caso 4 (Falha - Professor)** | 1, 5, 6, 8, 10, 13, 15 | Professor preenche tudo, mas define o prazo para o mesmo minuto atual da criação. (Erro: Prazo no presente/imediato). | O sistema bloqueia a criação e informa que o prazo precisa dar um tempo mínimo útil de duração. |
| **Caso 5 (Sucesso - Aluno)** | 1, 3, 6, 8, 10, 13, 15 | Aluno envia imagem `.png` de 2 MB no prazo, correta e inédita para o desafio criado. | Upload concluído; status muda para "Aguardando Validação". |
| **Caso 6 (Falha - Aluno)** | 1, 3, 7, 8, 10, 13, 15 | Aluno tenta fazer upload de imagem válida, mas o cronômetro já zerou. (Erro: Prazo expirado). | Sistema bloqueia envio e exibe o status


---

US5: Acessar Relatórios Analíticos de Desempenho

1. Tabela de Classes de Equivalência

| Condição de Entrada | Classes Válidas | Classes Inválidas |
| :--- | :--- | :--- |
| **Filtro de escopo** | Turma completa ou aluno individual válido **(1)** | Aluno selecionado não pertence à turma **(2)** |
| **Filtro de período** | Período Semanal, Mensal ou Personalizado **(3)** | Tipo de período inexistente ou não selecionado **(4)** |
| **Intervalo de datas** | Data de início menor ou igual à data de fim **(5)** | Data de início maior do que a data de fim **(6)** |
| **Cálculo das métricas** | Indicadores calculados e atualizados na tela **(7)** | Tela renderiza erro de processamento ou dados zerados **(8)** |
| **Formato de exportação** | Exportação solicitada em formato PDF **(9)** | Tentativa de forçar a exportação em outro formato (ex: `.xlsx`) **(10)** |

2. Tabela de Casos de Teste

| Casos de Teste | Classes de Equivalência | Entradas (Cenário do Teste) | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1 (Sucesso)** | 1, 3, 5, 7, 9 | Professor filtra turma por um período semanal válido. | Gráficos e indicadores gerados dinamicamente com dados na tela. |
| **Caso 2 (Sucesso)** | 1, 3, 5, 7, 9 | Professor clicou no botão de exportar o relatório atual. | O arquivo é gerado e baixado com sucesso em formato PDF. |
| **Caso 3 (Falha)** | 2, 3, 5, 7, 9 | Sistema de busca de dados de um aluno de outra turma no relatório. | O sistema bloqueia a consulta (Erro: Aluno não encontrado). |
| **Caso 4 (Falha)** | 1, 4, 5, 7, 9 | O componente de filtro envia uma opção nula para o servidor. | O sistema mantém o último estado válido ou pede seleção de período. |
| **Caso 5 (Falha)** | 1, 3, 6, 7, 9 | Sem filtro personalizado, defina Início: 15/06 e Fim: 10/06. | Sistema de bloqueio de filtro (Aviso: Início maior que data fim). |
| **Caso 6 (Falha)** | 1, 3, 5, 8, 9 | Banco de dados com falha ou retornos nulos/zerados. | Tela exibe aviso amigável de erro em vez de quebrar os gráficos. |
| **Caso 7 (Falha)** | 1, 3, 5, 7, 10 | Usuário força requisição web solicitando planilha `.xlsx`. | O backend rejeita e bloqueia por formato não permitido. |

---

US6: Recursos de Acessibilidade Visual
1. Tabela de Classes de Equivalência

| Condição de Entrada | Classes Válidas | Classes Inválidas |
| :--- | :--- | :--- |
| **Seleção de paleta de contraste** | Selecionar Modo Escuro, Daltonismo ou Suave **(1)** | Tentar aplicar paleta inexistente ou cor inválida **(2)** |
| **Limite do tamanho da fonte** | Ajuste de escala de até 200% **(3)** | Ajuste de escala maior que 200% **(4)** |
| **Tempo de resposta da interface** | Alteração aplicada em até 1 segundo **(5)** | Aplicação demora mais de 1 segundo **(6)** |
| **Atualização da página** | Aplicação do estilo sem recarregar a página **(7)** | Interface força o recarregamento total da página **(8)** |
| **Persistência pós-login** | Estilos salvos carregam sozinhos após o login **(9)** | Sistema volta para o tema padrão após o login **(10)** |

2. Tabela de Casos de Teste

| Casos de Teste | Classes de Equivalência | Entradas (Cenário do Teste) | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1 (Configurar - Sucesso)** | 1, 3, 5, 7 | Usuário seleciona o Modo Daltonismo e aumenta a fonte para 150%. | Paleta e tamanho mudam em menos de 1s, sem sobreposição e sem atualizar a página. |
| **Caso 2 (Configurar - Falha)** | 2, 3, 5, 7 | Sistema tenta injetar um código de paleta de cores não mapeado. | O sistema ignora a paleta inválida e mantém o visual atual íntegro. |
| **Caso 3 (Configurar - Falha)** | 1, 4, 5, 7 | Usuário tenta arrastar ou forçar a escala da fonte para 250%. | O sistema trava o limite máximo em 200% para evitar quebra de layout. |
| **Caso 4 (Configurar - Falha)** | 1, 3, 6, 7 | Usuário escolhe a paleta de Modo Suave na tela. | A interface demora 3 segundos para aplicar as cores de contraste na tela. |
| **Caso 5 (Configurar - Falha)** | 1, 3, 5, 8 | Usuário altera o tamanho da fonte para 120%. | O sistema altera a fonte, mas pisca e recarrega a página inteira do navegador. |
| **Caso 6 (Salvar e Logar - Sucesso)** | 1, 3, 5, 7, 9 | Usuário configura o Modo Escuro, desloga do app e faz login novamente. | O perfil carrega automaticamente as opções de acessibilidade salvas logo após o login. |
| **Caso 7 (Salvar e Logar - Falha)** | 1, 3, 5, 7, 10 | Usuário configura o Modo Escuro, desloga do app e faz login novamente. | O aplicativo esquece as alterações e carrega a interface com o tema padrão branco. |

---

US7: Rótulos Descritivos e Anúncios Dinâmicos

1. Tabela de Classes de Equivalência

| Condição de Entrada | Classes Válidas | Classes Inválidas |
| :--- | :--- | :--- |
| **Presença de rótulos acessíveis** | Componente possui tag descritiva da sua função **(1)** | Componente possui tag vazia ou sem descrição **(2)** |
| **Anúncio de mudança de estado** | Leitor anuncia estados (Desabilitado, Selecionado, Carregando) **(3)** | Interface muda de estado mas o leitor permanece em silêncio **(4)** |
| **Tratamento de elementos decorativos** | Linhas, bordas e ícones repetitivos ocultados do leitor **(5)** | Leitor de tela lê elementos puramente visuais/decorativos **(6)** |
| **Tratamento de imagens com significado** | Medalhas e imagens de progresso recebem rótulo textual **(7)** | Imagens com significado pedagógico ocultadas do leitor **(8)** |

2. Tabela de Casos de Teste

| Casos de Teste | Classes de Equivalência | Entradas (Cenário do Teste) | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1 (Navegação - Sucesso)** | 1, 3, 5, 7 | Usuário navega pelos botões principais e por uma medalha de conquista em uma tela com divisórias visuais. | O leitor anuncia claramente a função dos botões e o texto da medalha, ignorando as divisórias visuais. |
| **Caso 2 (Navegação - Falha)** | 2, 3, 5, 7 | Usuário foca o cursor em um elemento interativo que está sem a tag de acessibilidade configurada. | O leitor de tela não consegue descrever a função do componente (fala apenas "botão" ou fica em silêncio). |
| **Caso 3 (Anúncio - Sucesso)** | 1, 3, 5, 7 | Usuário clica em enviar um arquivo e o sistema entra em estado de carregamento assíncrono. | O leitor interrompe e anuncia dinamicamente: "Carregando evidência, por favor aguarde", evitando a sensação de app travado. |
| **Caso 4 (Anúncio - Falha)** | 1, 4, 5, 7 | Um botão de avançar na tela se torna indisponível (desabilitado) após uma ação. | A interface muda visualmente, mas o leitor de tela não anuncia a mudança de estado para o usuário. |
| **Caso 5 (Filtro Visual - Falha)** | 1, 3, 6, 7 | Usuário passa o leitor por uma lista que possui várias linhas divisórias e ícones decorativos de enfeite. | O leitor de tela perde tempo lendo os códigos de layout ou descrevendo elementos de design inúteis. |
| **Caso 6 (Filtro Conteúdo - Falha)** | 1, 3, 5, 8 | Usuário navega pela área de conquistas para verificar suas medalhas e progresso pedagógico. | O sistema trata os gráficos de evolução como elementos decorativos e oculta as informações do leitor de tela. |

---

US08: Interface Minimalista

1. Tabela de Classes de Equivalência

| Condição de Entrada | Classes Válidas | Classes Inválidas |
| :--- | :--- | :--- |
| **Quantidade de itens no menu inferior** | Menu com até 5 itens essenciais **(1)** | Menu com mais de 5 itens cadastrados **(2)** |
| **Visibilidade do menu nas telas** | Menu fixo e visível em todas as telas principais **(3)** | Menu desaparece ou fica oculto em alguma tela principal **(4)** |
| **Área de respiro do layout** | Proporção de espaço em branco igual ou maior que 30% **(5)** | Espaço em branco menor que 30% (tela poluída) **(6)** |
| **Duração de transições e microinterações**| Animação concluída em até 300ms **(7)** | Animação demora mais de 300ms para concluir **(8)** |
| **Comportamento de elementos dinâmicos** | Animações automáticas em loop e pop-ups desativados **(9)** | Presença de banners carrossel automáticos ou pop-ups intrusivos **(10)** |

2. Tabela de Casos de Teste

| Casos de Teste | Classes de Equivalência | Entradas (Cenário do Teste) | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1 (Layout - Sucesso)** | 1, 3, 5, 7, 9 | Usuário navega pelas telas principais do aplicativo com layout minimalista. | O menu exibe os 5 itens corretos, as telas mantêm mais de 30% de área livre e nenhuma animação automática é disparada. |
| **Caso 2 (Layout - Falha)** | 2, 3, 5, 7, 9 | Sistema tenta renderizar um 6º item na barra de navegação inferior. | O sistema bloqueia o item excedente para manter o limite fixo de 5 abas. |
| **Caso 3 (Layout - Falha)** | 1, 4, 5, 7, 9 | Usuário navega da Dashboard principal para a tela de Perfil. | A barra de navegação inferior desaparece ou fica oculta erroneamente. |
| **Caso 4 (Layout - Falha)** | 1, 3, 6, 7, 9 | Interface carrega elementos, textos e botões excessivos, deixando o layout compactado. | O sistema falha em manter os 30% de área de respiro, gerando sobrecarga visual. |
| **Caso 5 (Animação - Sucesso)** | 1, 3, 5, 7, 9 | Usuário clica em um botão para abrir uma nova tela ou interagir com um elemento. | A transição ocorre de forma discreta e a microinteração termina em menos de 300ms. |
| **Caso 6 (Animação - Falha)** | 1, 3, 5, 8, 9 | Usuário clica em um botão com microinteração configurada. | A animação do botão é lenta e demora 500ms para terminar. |
| **Caso 7 (Animação - Falha)** | 1, 3, 5, 7, 10 | Interface renderiza a Dashboard inicial do aplicativo. | O sistema dispara um banner carrossel que fica rodando sozinho ou abre um pop-up na tela. |

---

US09: Feedback Visual Imediato e Recompensas

1. Tabela de Classes de Equivalência

| Condição de Entrada | Classes Válidas | Classes Inválidas |
| :--- | :--- | :--- |
| **Confirmação do sistema** | Sistema confirma o envio com sucesso **(1)** | Falha ou demora na resposta do sistema **(2)** |
| **Tempo de exibição da tela** | Tela de aviso aparece em até 1 segundo **(3)** | Tela demora mais de 1 segundo para aparecer **(4)** |
| **Tipo de missão entregue** | Missão de correção automática (ex: quiz). Libera recompensa na hora. **(5)** | Missão que exige avaliação do professor. Dá apenas aviso de envio. **(6)** |
| **Situação da internet (RN2)** | Conectado (salva no servidor na mesma hora) **(7)** | Sem internet (sistema não trava, não perde os dados e salva no celular) **(8)** |
| **Visibilidade do broche ganho** | Visível apenas para o dono do perfil **(9)** | Visível publicamente para outras pessoas **(10)** |

2. Tabela de Casos de Teste

| Casos de Teste | Classes de Equivalência | Entradas (Cenário do Teste) | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1 (Sucesso)** | 1, 3, 5, 7, 9 | Usuário conectado à internet finaliza uma missão de correção automática (quiz) com sucesso. | O sistema confirma o envio, exibe a tela de comemoração em menos de 1 segundo e o broche ganho fica visível apenas para ele. |
| **Caso 2 (Sucesso)** | 1, 3, 6, 7, 9 | Usuário conectado à internet envia a foto de um desafio prático (exige professor) com sucesso. | O sistema confirma o envio e exibe apenas a mensagem "Desafio enviado com sucesso" em menos de 1 segundo (não libera recompensas na hora). |
| **Caso 3 (Falha)** | 2, 3, 5, 8, 9 | Usuário tenta enviar a missão automática, mas a internet cai bem na hora do envio. | O aplicativo não trava e não perde os dados. Ele salva o progresso no celular, avisa o usuário e exibe "Sincronização Pendente" no perfil. |
| **Caso 4 (Falha)** | 1, 4, 5, 7, 9 | Usuário finaliza a missão automática online, mas o aplicativo sofre uma lentidão. | A tela de comemoração demora mais de 1 segundo para aparecer, deixando a experiência do aplicativo lenta. |
| **Caso 5 (Falha)** | 1, 3, 5, 7, 10 | Usuário ganha um novo broche, mas o sistema falha em aplicar a regra de privacidade no perfil dele. | O aplicativo exibe o broche publicamente para outros alunos verem, quebrando a regra de que só o dono pode ver. |

---

 US10: Consumo de Conteúdos Educativos em Vídeo

1. Tabela de Classes de Equivalência

| Condição de Entrada | Classes Válidas | Classes Inválidas |
| :--- | :--- | :--- |
| **Botões do vídeo** | Botões de pausar, pular e volume funcionam **(1)** | Botões ficam travados ou não funcionam **(2)** |
| **Rolagem da tela (Feed)** | Deslizar a tela carrega novos vídeos **(3)** | Deslizar a tela não funciona ou trava **(4)** |
| **Pesquisa por categorias** | Pesquisa mostra os vídeos do tema correto **(5)** | Pesquisa não funciona ou mostra vídeos errados **(6)** |
| **Recursos de acessibilidade** | Legendas e audiodescrição ligam corretamente **(7)** | Legendas ou audiodescrição falham ao ligar **(8)** |
| **Permissão para postar vídeos** | Usuário logado é um Administrador **(9)** | Usuário logado é um Estudante ou Professor **(10)** |
| **Tempo de duração do vídeo** | Duração livre até o limite de 3 minutos **(11)** | Vídeo com mais de 3 minutos **(12)** |

2. Tabela de Casos de Teste

| Casos de Teste | Classes de Equivalência | Entradas (Cenário do Teste) | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1 (Sucesso)** | 1, 3, 5, 7, 10, 11 | Estudante pesquisa um tema, assiste a um vídeo de 2 minutos e liga as legendas com sucesso. | O vídeo roda normalmente, a rolagem funciona, as legendas aparecem e os botões de postar vídeos ficam escondidos para ele. |
| **Caso 2 (Sucesso)** | 1, 3, 5, 7, 9, 11 | Administrador acessa o aplicativo e posta um vídeo de 2 minutos e 45 segundos com sucesso. | O sistema permite a postagem, o vídeo vai para a tela principal e os botões de controle funcionam normalmente. |
| **Caso 3 (Falha)** | 1, 3, 5, 7, 9, 12 | Administrador tenta postar um vídeo novo, mas seleciona um arquivo que tem 5 minutos de duração. | O aplicativo bloqueia a postagem avisando que o limite máximo permitido é de 3 minutos. |
| **Caso 4 (Falha)** | 1, 3, 5, 8, 10, 11 | Estudante com deficiência visual tenta ligar a audiodescrição, mas o botão apresenta falha ao ser clicado. | O botão não responde e o áudio não muda, atrapalhando a acessibilidade. |
| **Caso 5 (Falha)** | 1, 4, 5, 7, 10, 11 | Estudante assiste a um vídeo válido e tenta deslizar a tela para baixo, mas o feed de vídeos trava. | A tela congela e o aplicativo não carrega os novos vídeos. |
| **Caso 6 (Falha)** | 2, 3, 5, 7, 10, 11 | Estudante assiste a um vídeo e tenta pular 10 segundos para frente, mas o botão do player trava. | Os botões do player não respondem ao toque e o vídeo não avança. |
| **Caso 7 (Falha)** | 1, 3, 5, 7, 10, 12 | Estudante dá play em um vídeo de 2 minutos, mas o aplicativo faz um corte forçado de tempo. | O aplicativo corta o vídeo sozinho aos 15 segundos, seguindo uma regra antiga do sistema que já deveria ter sido removida. |

---

US11: Validação de Evidências pelo Professor

1. Tabela de Classes de Equivalência

| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| :--- | :--- | :--- | :--- |
| **Filtros e ordenação da lista** | Filtros e ordenação funcionam **(1)** | Filtros não funcionam **(2)** | Ordenação fica bagunçada **(3)** |
| **Aprovar evidência (Verde)** | Aprova e credita os pontos **(4)** | Botão trava e não aprova **(5)** | Aprova mas pontos não caem **(6)** |
| **Recusar evidência (Vermelho)** | Exige justificativa para recusar **(7)** | Deixa recusar sem texto **(8)** | Tela de justificativa não abre **(9)** |
| **Status dos pontos ao enviar** | Ficam como "Pendente" **(10)** | Somam no saldo antes de avaliar **(11)** | Não aparecem no extrato **(12)** |

2. Tabela de Casos de Teste

| Casos de Teste | Classes de Equivalência | Entradas (Cenário do Teste) | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1 (Sucesso)** | 1, 4, 7, 10 | Professor filtra a lista corretamente, vê a missão que entrou como "Pendente", aprova uma missão com sucesso e recusa outra digitando a justificativa. | Todo o fluxo funciona, a justificativa é cobrada e os pontos da missão aprovada vão para o saldo do aluno. |
| **Caso 2 (Falha)** | 3, 4, 7, 10 | Professor clica para ordenar as atividades por "Mais recentes", mas a listagem falha e mistura missões antigas com novas na tela. | A ordenação da interface fica bagunçada, dificultando o trabalho de correção do professor. |
| **Caso 3 (Falha)** | 1, 6, 7, 10 | Professor clica no botão verde de "Aprovar" em uma atividade correta, mas o sistema falha e os pontos não chegam ao saldo do aluno. | A missão muda de status para aprovada, mas o aluno fica sem receber a pontuação correspondente no saldo. |
| **Caso 4 (Falha)** | 1, 4, 8, 10 | Professor clica no botão de "Recusar" e envia direto com o campo de texto em branco, e o sistema falha ao aceitar o envio sem validação. | O aplicativo burla a regra e deixa o professor recusar a missão sem explicar o motivo para o estudante. |
| **Caso 5 (Falha)** | 1, 4, 7, 11 | Aluno faz o envio de sua missão prática, mas o sistema apresenta falha ao creditar os pontos direto no saldo dele antes do professor avaliar. | O aluno ganha os pontos automaticamente de forma errada, quebrando a regra de que a aprovação precisa ser estritamente manual. |

---

US12: Guia Passo a Passo Interativo (Tutorial)

1. Tabela de Classes de Equivalência

| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| :--- | :--- | :--- | :--- |
| **Exibição do guia (1º acesso)** | Balões aparecem no 1º acesso **(1)** | Balões nunca aparecem **(2)** | Aparecem toda vez **(3)** |
| **Botões de controle do guia** | "Próximo"/"Anterior" funcionam **(4)** | Botões travam/não clicam **(5)** | Pulam para a dica errada **(6)** |
| **Ação de Pular Tutorial** | Oculta e marca como concluído **(7)** | Botão de pular não responde **(8)** |  Oculta mas volta a aparecer **(9)** |
| **Reiniciar nas Configurações** | Botão reinicia o guia perfeitamente **(10)** | Opção não existe no menu **(11)** | Botão existe mas dá erro **(12)** |

2. Tabela de Casos de Teste

| Casos de Teste | Classes de Equivalência | Entradas (Cenário do Teste) | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1 (Sucesso)** | 1, 4, 7, 10 | Estudante abre a tela pela 1ª vez, usa os botões para avançar com sucesso, termina o guia e depois consegue achar o botão nas configurações para rever. | O tutorial funciona de forma fluida, não aparece repetido depois de fechado e pode ser reiniciado manualmente pelo menu. |
| **Caso 2 (Falha)** | 2, 4, 7, 10 | Estudante cria uma conta nova e abre a tela pela primeira vez, mas o sistema falha e os balões de ajuda simplesmente não aparecem na interface. | O usuário novo fica sem o tutorial interativo e não aprende a usar as funcionalidades iniciais. |
| **Caso 3 (Falha)** | 3, 4, 7, 10 | Estudante já utilizou o aplicativo várias vezes e concluiu o guia, mas o sistema apresenta falha ao exibir o tutorial de novo a cada novo acesso. | O aplicativo gera uma experiência ruim, irritando o usuário ao mostrar o tutorial repetidas vezes de forma forçada. |
| **Caso 4 (Falha)** | 1, 5, 7, 10 | Estudante lê a primeira dica de ajuda e clica no botão "Próximo", mas o botão do balão trava e impede a mudança de tela. | O estudante fica preso no primeiro passo do tutorial por erro de clique na interface do balão de ajuda. |
| **Caso 5 (Falha)** | 1, 4, 9, 10 | Estudante clica na opção "Pular Tutorial", a tela fecha na hora, mas o sistema falha ao não salvar a preferência e traz o guia de volta na próxima tela. | O botão fecha o tutorial momentaneamente, mas falha ao não marcar o guia como concluído no banco de dados. |
| **Caso 6 (Falha)** | 1, 4, 7, 11 | Estudante entra no menu de Configurações do seu perfil para tentar rever as dicas, mas o sistema falha e a opção de "Reiniciar Tutorial" sumiu do menu. | O estudante perde a capacidade de acionar o guia interativo manualmente quando precisa tirar alguma dúvida sobre o app. |


US13: Realizar Cadastro Básico no Sistema

1. Tabela de Classes de Equivalência

| Condição de Entrada | Classes Válidas | Classe Inválida 1 | Classe Inválida 2 |
| :--- | :--- | :--- | :--- |
| **Nome do usuário** | Mínimo de 3 caracteres **(1)** | Menos de 3 caracteres **(2)** | - |
| **E-mail do usuário** | Formato válido e inédito **(3)** | Formato inválido (ex: sem `@`) **(4)** | E-mail já cadastrado (RN1) **(5)** |
| **Validação da Senha** | Mínimo de 8 caracteres com maiúscula e número **(6)** | Menos de 8 caracteres **(7)** | Sem letra maiúscula ou número **(8)** |
| **Tipo de Perfil** | Selecionado (Aluno ou Professor) **(9)** | Não selecionado (em branco) **(10)** | - |

2. Tabela de Casos de Teste

| Casos de Teste | Classes de Equivalência | Entradas (Cenário do Teste) | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1 (Sucesso)** | 1, 3, 6, 9 | Usuário preenche nome com 5 letras, e-mail correto, senha forte e seleciona o perfil de "Aluno" com sucesso. | O cadastro é concluído e o perfil é criado na Jornada Verde. |
| **Caso 2 (Falha)** | 2, 3, 6, 9 | Usuário tenta se cadastrar digitando o nome apenas com "Zé", mas o sistema falha ao aceitar o nome curto. (Erro: Aceitou nome menor que 3 caracteres). | O aplicativo aceita o cadastro com nome curto, quebrando a regra de limite mínimo. |
| **Caso 3 (Falha)** | 1, 4, 6, 9 | Usuário preenche os dados, mas digita o e-mail sem o símbolo `@`, e o formulário falha ao não validar o formato. (Erro: E-mail em formato incorreto). | O sistema aceita o e-mail no formato incorreto e cria a conta mesmo assim. |
| **Caso 4 (Falha)** | 1, 5, 6, 9 | Usuário preenche tudo certo, mas usa um e-mail que já está cadastrado, e o sistema falha ao permitir o registro. (Erro: Duplicidade de e-mail). | O banco de dados aceita a duplicidade, quebrando a regra de e-mail único. |
| **Caso 5 (Falha)** | 1, 3, 7, 9 | Usuário digita uma senha fraca com apenas 5 caracteres, e o sistema apresenta falha ao aceitar o envio. (Erro: Senha com menos de 8 caracteres). | A conta é criada com uma senha insegura, quebrando a regra de tamanho mínimo. |
| **Caso 6 (Falha)** | 1, 3, 8, 9 | Usuário cria uma senha longa, mas apenas com letras minúsculas, e o sistema falha ao aprovar. (Erro: Faltou letra maiúscula e número). | O sistema aceita a senha fraca, quebrando a regra de complexidade. |
| **Caso 7 (Falha)** | 1, 3, 6, 10 | Usuário preenche os dados de texto, mas deixa o Tipo de Perfil em branco, e o sistema falha ao prosseguir com o cadastro. (Erro: Perfil não selecionado). | O usuário é cadastrado sem nenhuma permissão definida, gerando erros na conta depois. |

---

US14: Receber Notificações sobre Novos Desafios

1. Tabela de Classes de Equivalência

| Condição de Entrada | Classes Válidas | Classes Inválidas |
| :--- | :--- | :--- |
| **Permissão do usuário** | Aceitou receber notificações **(1)** | Recusou receber notificações **(2)** |
| **Conteúdo do alerta** | Apenas texto com Título e Corpo corretos **(3)** | Texto com campos vazios ou nulos **(4)** |
| **Ação ao clicar** | Abre na tela de detalhes da missão certa **(5)** | Abre na tela errada (ex: Home) **(6)** |

2. Tabela de Casos de Teste

| Casos de Teste | Classes de Equivalência | Entradas (Cenário do Teste) | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1 (Sucesso)** | 1, 3, 5 | Aluno aceita notificações, recebe o push com o título e corpo corretos quando o professor lança um desafio e clica nele com sucesso. | O aplicativo abre diretamente na tela de detalhes daquela missão específica. |
| **Caso 2 (Falha)** | 2, 3, 5 | Aluno marcou que NÃO quer notificações, mas o sistema falha e envia o push mesmo assim quando o professor lança um desafio. (Erro: Sistema ignorou a permissão). | O usuário é incomodado por uma notificação que ele havia desativado nas permissões. |
| **Caso 3 (Falha)** | 1, 4, 5 | O professor lança o desafio, mas o sistema falha na hora de montar a mensagem e exibe "null lançou a missão: null". (Erro: Falha no carregamento do texto). | O aluno recebe um push com os campos de texto vazios e sem sentido. |
| **Caso 4 (Falha)** | 1, 3, 6 | Aluno clica na notificação do novo desafio para ver os detalhes, mas o sistema falha no direcionamento e abre a tela Home do app. (Erro: Redirecionamento incorreto). | O aluno é jogado na tela inicial e é obrigado a procurar a missão manualmente. |

---

US15: Receber selos de "Destaque" enviados pelo professor

1. Tabela de Classes de Equivalência

| Condição de Entrada | Classes Válidas | Classes Inválidas |
| :--- | :--- | :--- |
| **Vínculo de Turma (RN1)** | Professor e aluno na mesma turma **(1)** | Professor de outra turma **(2)** |
| **Limite de Envio (RN2)** | Até 5 selos enviados na semana **(3)** | Tentativa de enviar o 6º selo na semana **(4)** |
| **Exibição do Selo (CA1)** | Pop-up no ecrã inicial no próximo login **(5)** | Pop-up não é exibido no login **(6)** |
| **Armazenamento (CA2)** | Fica salvo na "Galeria de Conquistas" **(7)** | Selo desaparece após fechar o pop-up **(8)** |
| **Acúmulo de Selos (RN3)** | Aluno recebe o 2º selo ou mais **(9)** | Sistema bloqueia recebimento do 2º selo **(10)** |

2. Tabela de Casos de Teste

| Casos de Teste | Classes de Equivalência | Entradas (Cenário do Teste) | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| **Caso 1 (Sucesso)** | 1, 3, 5, 7, 9 | Professor da mesma turma, com limite disponível, envia um segundo selo ao aluno. O aluno faz login com sucesso e fecha o aviso. | O pop-up surge no ecrã inicial e o selo é guardado permanentemente na Galeria de Conquistas. |
| **Caso 2 (Falha)** | 2, 3, 5, 7, 9 | Professor tenta enviar um selo para um aluno, mas o sistema falha ao permitir a ação. (Erro: Professor e aluno pertencem a turmas diferentes). | O sistema quebra a regra de vínculo e permite o envio do selo a um aluno de outra turma. |
| **Caso 3 (Falha)** | 1, 4, 5, 7, 9 | Professor já enviou 5 selos nesta semana e tenta enviar mais um, mas o botão não o impede. (Erro: Sistema ignora o limite máximo de 5 selos). | O professor ultrapassa o limite semanal, desvalorizando a exclusividade do reconhecimento. |
| **Caso 4 (Falha)** | 1, 3, 6, 7, 9 | O selo é enviado corretamente, o aluno faz o seu próximo login, mas o sistema falha e não mostra nenhum aviso. (Erro: O pop-up não foi acionado no ecrã inicial). | O aluno não é notificado do reconhecimento no momento exato do login. |
| **Caso 5 (Falha)** | 1, 3, 5, 8, 9 | O aluno vê o pop-up no login e fecha-o, mas o sistema apresenta falha ao gravar os dados. (Erro: O selo não é guardado na base de dados). | O selo desaparece completamente e não fica visível na secção "Galeria de Conquistas". |
| **Caso 6 (Falha)** | 1, 3, 5, 7, 10 | O aluno já tem um selo e o professor tenta enviar-lhe outro, mas o sistema recusa. (Erro: Bloqueio indevido de múltiplos selos para o mesmo aluno). | O sistema quebra a regra que permite ao aluno acumular mais do que um selo no seu perfil. |











