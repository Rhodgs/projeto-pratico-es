# Relatório consolidado de mudanças — Jornada Verde

**Data:** 06/09/2026, horário de Manaus (UTC−4).  
**Escopo:** mudanças registradas no histórico da branch atual durante o dia, até o commit `86e8163`. Comparação entre `c5efdf0` (estado anterior) e `86e8163` (estado final). A árvore de trabalho estava limpa no início deste levantamento.

Este documento relaciona os quatro problemas de código tratados às implementações entregues, suas correções funcionais, testes e limites. Os resultados de execução abaixo foram recuperados dos relatórios produzidos no dia; os testes não foram executados novamente para elaborar este resumo.

## 1. Visão geral

| Problema | Situação anterior | Solução entregue | Resultado |
| :--- | :--- | :--- | :--- |
| 1 — Criação de desafios | Controller concentrava validação, transformação dos dados e persistência | Facade, validação extraída e repositório Prisma | Fluxo de criação separado do tratamento HTTP e testável isoladamente |
| 2 — ApiService | Repetição de URI, headers, JSON, envio e parsing em cada operação | Decorator HTTP e cliente JSON, mantendo ApiService como fachada | Comunicação centralizada e erros tratados de maneira consistente |
| 3 — Dependências dos controllers | Instâncias criadas ou importadas de maneiras diferentes | Injeção por construtor e composição centralizada | Serviços substituíveis em testes e configuração separada do uso |
| 4 — Cadastro de usuários | Duplicação de criação, campos de retorno e tratamento de erros entre perfis | Factory Method para produtos Aluno/Professor | Uma rotina de persistência, mantendo as particularidades de cada perfil |

O conjunto do dia alterou **37 arquivos**, com **3.535 inserções e 637 remoções**, incluindo documentação, testes e snapshots. Esses números representam o diff acumulado, não somente código de produção, e não incluem este relatório.

## 2. Problema 1 — Separação da criação de desafios

**Mudanças realizadas:**

- `DesafioController.criarDesafio` passou a delegar a criação para `CriacaoDesafioFacade`, mantendo a responsabilidade por requisição e resposta HTTP.
- `ValidacaoCriacaoDesafio` passou a reunir as verificações de campos obrigatórios, prazo passado e intervalo mínimo útil de 60 segundos.
- A preparação dos dados centralizou remoção de espaços nas extremidades do título e descrição, conversão da pontuação para número e conversão do prazo para `Date`.
- `CriacaoDesafioFacade` organiza a sequência validar → persistir e permite fornecer um relógio para testes determinísticos.
- `PrismaCriacaoDesafioRepository` concentra a gravação desse caso de uso. A fachada depende de um contrato de repositório que pode ser substituído.
- Foram adicionados testes de comparação antes/depois e cenários isolados de validação e persistência.
- Na etapa do problema 3, a fachada passou a ser recebida pelo construtor do controller e montada na composição de produção.

**Benefício:** regras e armazenamento podem ser exercitados separadamente, sem montar uma requisição real. O padrão Facade foi aplicado ao caso de criação; os demais acessos de DesafioController à persistência não foram todos migrados para repositórios.

**Evidência:** 10 testes aprovados. Detalhes e código antes/depois em [Facade na criação de desafios](padrao-facade-criacao-desafios.md).

## 3. Problema 2 — Centralização da comunicação com a API

**Mudanças realizadas:**

- `ApiService` mantém a interface consumida pelas telas, com os 16 métodos anteriores delegando a infraestrutura HTTP ao cliente JSON.
- `JsonHeadersClient` foi criado como Decorator de `http.Client`, estendendo `http.BaseClient` e centralizando headers em `send`.
- Headers explícitos são respeitados e requisições multipart mantêm seu próprio Content-Type e boundary.
- `JsonApiClient` centraliza URI, parâmetros de consulta, serialização JSON, envio, leitura da resposta e verificação do formato esperado.
- `ApiException` foi extraída para arquivo próprio e reexportada por `api_service.dart`, preservando os imports existentes.
- Foi acrescentado `close()` para liberar o cliente utilizado pela fachada; o encerramento também alcança o cliente injetado.
- A dependência de testes foi acrescentada ao `pubspec.yaml`, com suíte e snapshot anterior para comparação.

**Correções de comportamento entregues:**

1. Falha HTTP ao listar turmas passou a lançar `ApiException`, em vez de aparentar uma lista vazia.
2. Respostas 2xx passaram a ser reconhecidas como sucesso; ausência de conteúdo retorna objeto ou lista vazia conforme a operação, incluindo HTTP 204.
3. JSON malformado ou incompatível com o formato esperado passou a produzir erro explícito, preservando o status recebido.
4. Erros não JSON recebem mensagem HTTP genérica. Em objetos de erro, são considerados os campos textuais `erro`, `message` e `error`, nessa ordem.
5. IDs de caminho e parâmetros de consulta passaram a ser codificados para lidar com caracteres reservados.

**Distinção de responsabilidades:** o Decorator preserva o contrato HTTP; a transformação de respostas em objetos/listas pertence a `JsonApiClient`. `ApiService` continua sendo a fachada das operações do aplicativo.

**Evidência:** 33 testes aprovados e análise estática dos serviços Dart sem problemas. Foram usados Dart e MockClient em ambiente isolado, pois Flutter não estava instalado. Detalhes em [Decorator e fachada da API](padrao-decorator-api-service.md).

## 4. Problema 3 — Injeção de dependências e composição

**Mudanças realizadas:**

- `AuthController` passou a receber as operações de cadastro e login pelo construtor.
- `TurmaController` passou de funções exportadas para uma classe que recebe as operações de turmas.
- `AlunoController` passou a receber o serviço de ranking adequado.
- `DesafioController` passou a receber a fachada de criação, o serviço de desafios e a dependência de banco utilizada nos demais métodos.
- Funções de evidências antes exportadas isoladamente foram incorporadas como métodos de `DesafioController`.
- `composition/controllers.ts` passou a conectar os serviços às instâncias dos controllers por meio de `montarControllers`.
- `composition/producao.ts` passou a montar as dependências reais, incluindo Prisma, bcrypt, serviços, fachada, repositório e criadores de usuários.
- `server.ts` passou a utilizar essa composição e callbacks que preservam a instância dos métodos, sem introduzir novas URLs.
- A instância global exportada por `TurmaService` foi removida. A composição é criada uma vez na inicialização, com reutilização dos serviços.
- Imports somente de tipos e contratos restritos com `Pick` permitem testar controllers com colaboradores simulados.

**Correção funcional adicional:** `AlunoController` utilizava `buscarRanking`, inexistente em `TurmaService`. Foi conectado à operação `buscarTop5` de `RankingService`.

**Classificação:** a solução é injeção de dependências com ponto de composição. Centralizar chamadas de construção não caracteriza, por si só, Factory Method; reutilizar instâncias também não transforma as classes em Singleton.

**Limites:** `RankingController`, `UsuarioController` e `PreferenciasController` ficaram fora desta refatoração. `AlunoController` continua sem rota registrada, e seus placeholders de perfil/envio não foram implementados por essa mudança.

**Evidência:** testes de mocks, delegação, composições independentes e registro/execução de callbacks de rotas com Express simulado. Detalhes em [Injeção de dependências](problema-3-injecao-de-dependencias.md).

## 5. Problema 4 — Factory Method na criação de usuários

**Mudanças realizadas:**

- Criada a abstração `UsuarioParaCadastro`, responsável por mapear os campos comuns para persistência.
- Criados `AlunoParaCadastro` e `ProfessorParaCadastro`: aluno acrescenta vínculo com uma turma validada; professor acrescenta seu perfil.
- Criado `CriadorUsuario`, com o Factory Method `criarUsuario` e a operação `preparar`.
- Criados `CriadorAluno` e `CriadorProfessor`, responsáveis por escolher o produto concreto.
- `CadastroService` passou a receber banco, operações de senha e mapa de criadores por injeção.
- As duas chamadas de criação de usuário foram consolidadas em uma única chamada.
- As duas seleções de campos públicos foram consolidadas em uma seleção compartilhada, sem retornar senha.
- Os dois tratamentos de e-mail duplicado (`P2002`) foram consolidados em um único tratamento.
- Foram preservados o hash antes da persistência, bcrypt com 10 rounds na composição real, vínculo com turma, normalização dos perfis válidos e retorno público de cadastro/login.

**Correção funcional adicional:** perfil desconhecido, vazio ou ausente passou a ser recusado com HTTP 422, antes de gerar hash ou persistir. Antes, valores diferentes de Aluno podiam seguir pelo caminho de professor e a ausência do perfil podia causar erro de execução.

**Limite:** validar o nome do perfil não comprova que a pessoa é professora. Convites, aprovação institucional, validação completa de nome/e-mail e recuperação de senha não foram implementados nesta etapa.

**Evidência:** testes de produtos/criadores, dados persistidos, retorno sem senha, erros e comparação com o código anterior. Detalhes em [Factory Method de usuários](problema-4-factory-method-usuario.md).

## 6. Testes, arquivos auxiliares e verificação

| Verificação registrada no dia | Resultado | Alcance |
| :--- | :--- | :--- |
| Criação de desafios | 10 aprovados | Comparação antes/depois e colaboradores isolados |
| Cadastro, login e fábricas | 18 aprovados | Perfis, persistência simulada, erros e dados públicos |
| Controllers, composição e rotas | 9 aprovados | Injeção e chamadas com colaboradores simulados |
| Comunicação Dart com a API | 33 aprovados | Contratos, erros, formatos, transporte, sessão e Decorator |
| Verificação de tipos do backend | Aprovada | TypeScript 6.0.3 e Prisma Client 5.22.0 gerado localmente |
| Análise estática dos serviços Dart | Sem problemas | Camada de serviços analisada |

São **70 testes aprovados no total**, sendo 37 de backend e 33 de Dart. Os 10 testes de desafios já estão incluídos nos 37; não são uma suíte adicional a somar novamente.

Também foram adicionados os scripts `test:criacao` e `test:dependencias-cadastro`, o carregador `tests/helpers/carregar-ts.cjs` e snapshots do código anterior para comparação. O script genérico `npm test` continua com o placeholder anterior; as suítes usam os comandos específicos documentados.

O `.gitignore` passou a ignorar `/work/validacao-api/` e `/work/validacao-backend/`, usados na validação local. A verificação do backend utilizou dependências instaladas sem atualizar locks; não demonstra reprodução exata do package-lock. A geração local do Prisma Client não executou migrações.

Os resultados não incluem integração com PostgreSQL/Redis, tráfego HTTP real, testes de widgets ou build Android/web. A ausência da checagem completa de tipos mencionada no relatório inicial do problema 1 foi superada pela verificação posterior registrada nos problemas 3 e 4.

## 7. Documentação e planejamento do dia

Foram adicionados os quatro relatórios técnicos vinculados acima, com responsabilidades, justificativa, exemplos antes/depois e evidências de testes.

Foi criado o [Plano evolutivo e consolidação do escopo](../../especificacao/5-plano-evolutivo-e-escopo.md), com referência no plano de trabalho. Ele registra discussão sobre público geral versus alternativa institucional, proposta B2B, convites/aprovações e backlog de evolução. Esses itens são planejamento, não funcionalidades entregues.

Continuam pendentes, conforme o escopo documentado: decisão final de público e moderação; autenticação e autorização completas; convites e aprovação institucional se aplicáveis; concessão de XP transacional e única; integração do envio real de evidências; validação completa em Android e com serviços reais. `anexarEvidencia` ainda envia o contrato JSON anterior, incompatível com o multipart exigido pelo backend.

As seis refatorações descritas no arquivo histórico `refatoração.md` não foram incluídas como entregas de hoje, pois esse arquivo não aparece no diff do período.

## 8. Rastreabilidade no Git

| Commit | Horário de Manaus | Registro |
| :--- | :--- | :--- |
| `d053433` | 14:38:50 | Plano Evolutivo |
| `54ad425` | 15:02:40 | Refatoração de Controller Desafios — problema 1 |
| `8279afe` | 17:03:08 | Merge do PR #91 |
| `5adef0c` | 17:18:39 | Refatoração de Api Service Dart — problema 2 |
| `ee0db43` | 17:21:53 | Merge do PR #92 |
| `86e8163` | 19:00:48 | Refatoração de Controllers — problemas 3 e 4 |

Os merges integram as alterações e não são contabilizados como implementações duplicadas. O levantamento cobre o histórico alcançável pela branch atual, sem afirmar abranger trabalho existente apenas em outras branches ou máquinas.

## 9. Inventário completo dos arquivos do período

Os caminhos abaixo são relativos à raiz do repositório. A = adicionado; M = modificado.

```text
M	.gitignore
A	Documentacao-mvp/docs/padrao-decorator-api-service.md
A	Documentacao-mvp/docs/padrao-facade-criacao-desafios.md
A	Documentacao-mvp/docs/problema-3-injecao-de-dependencias.md
A	Documentacao-mvp/docs/problema-4-factory-method-usuario.md
M	backend/package.json
M	backend/server.ts
A	backend/src/composition/controllers.ts
A	backend/src/composition/producao.ts
M	backend/src/controllers/AuthController.ts
M	backend/src/controllers/DesafioController.ts
M	backend/src/controllers/TurmaController.ts
M	backend/src/controllers/alunoController.ts
A	backend/src/factories/CriadorUsuario.ts
A	backend/src/repositories/PrismaCriacaoDesafioRepository.ts
M	backend/src/services/CadastroService.ts
A	backend/src/services/CriacaoDesafioFacade.ts
M	backend/src/services/TurmaService.ts
A	backend/src/services/ValidacaoCriacaoDesafio.ts
A	backend/tests/criacao-desafio.test.cjs
A	backend/tests/dependencias-cadastro.test.cjs
A	backend/tests/fixtures/DesafioController.antes.txt
A	backend/tests/fixtures/problemas-3-4/AuthController.ts.txt
A	backend/tests/fixtures/problemas-3-4/CadastroService.ts.txt
A	backend/tests/fixtures/problemas-3-4/DesafioController.ts.txt
A	backend/tests/fixtures/problemas-3-4/TurmaController.ts.txt
A	backend/tests/fixtures/problemas-3-4/alunoController.ts.txt
A	backend/tests/helpers/carregar-ts.cjs
A	codigo-fonte/lib/services/api_exception.dart
M	codigo-fonte/lib/services/api_service.dart
A	codigo-fonte/lib/services/json_api_client.dart
A	codigo-fonte/lib/services/json_headers_client.dart
M	codigo-fonte/pubspec.yaml
A	codigo-fonte/test/api_service_test.dart
A	codigo-fonte/test/fixtures/api_service_antes.dart
M	especificacao/1_plano-de-trabalho.md
A	especificacao/5-plano-evolutivo-e-escopo.md
```
