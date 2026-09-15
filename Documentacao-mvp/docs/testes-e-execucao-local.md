# Jornada Verde — bateria de testes e execução local

## Resultado desta execução (15/09/2026)

- Backend: **57 casos executados: 54 aprovados e 3 defeitos reproduzidos como TODO**.
- Os 37 testes anteriores passaram; foram acrescentados 17 testes aprovados de serviços de produção e 3 testes de defeitos conhecidos.
- Os testes substituem PostgreSQL e Redis por colaboradores simulados. Não comprovam integração, transações, concorrência ou funcionamento das telas.
- Verificação de tipos do backend: **aprovada**, usando o compilador já presente em `backend/node_modules` (não comprova reinstalação pelo lockfile).
- Os 33 testes Dart registrados no relatório de 06/09 **não foram reexecutados**. Tampouco foram executados widgets, Jest das simulações, análise Flutter, build ou app local.
- Ambiente desta sessão: Node 24.19.0 disponível; npm, Docker e Flutter não encontrados no PATH nem nos caminhos comuns verificados. A pasta antiga de Dart em `work` está sem executável.
- O app **ainda não foi iniciado**. Os comandos abaixo ficam prontos para execução após disponibilizar essas ferramentas.

## 1. Organização da bateria

| Camada | Arquivos / comando na raiz | O que demonstra |
|---|---|---|
| Regressão de produção | `npm test` ou `node --experimental-vm-modules --test backend/tests/*.test.cjs` | Fachada, Factory Method, controllers, rotas simuladas, turmas, ranking e avaliação |
| Simulações acadêmicas | `npm run test:simulacoes` | Regras das classes em `casos-de-testes/src`, que não são os serviços de produção |
| Contrato Flutter/API e widgets | `npm run test:flutter` | API com HTTP simulado e tela inicial; requer Flutter |
| Todas as suítes acima | `npm run test:all` | Execução sequencial; requer dependências da raiz e Flutter |
| Tipos do backend | Na pasta `backend`: `npm run typecheck` | Consistência TypeScript, após gerar Prisma Client |
| Análise Flutter | Na pasta `codigo-fonte`: `flutter analyze` | Erros e avisos do aplicativo inteiro |
| Integração e aceite | Roteiro das seções 4 e 5 | HTTP real, persistência e experiência completa |

O runner de backend usa APIs experimentais do Node; esta execução foi verificada com Node 24.19.0. Não precisa de npm nem de banco para rodar esses testes unitários.

**TODO não significa aprovado.** Os três testes executam a expectativa desejada e atualmente falham, mas o Node os contabiliza como TODO e retorna código zero. Uma liberação exige corrigir esses casos, remover os marcadores TODO e executar novamente. `test:all` sozinho não é critério de liberação.

## 2. Rastreabilidade das refatorações

| Refatoração | Verificações necessárias | Situação |
|---|---|---|
| Facade de criação de desafios / cláusulas de guarda | Campos vazios, trim, pontuação, prazo passado, 59.999/60.000 ms, persistência única e erro propagado | Casos existentes aprovados; data e número inválidos reproduzidos como defeitos |
| Decorator HTTP + ApiService | 16 operações, headers, multipart, codificação de IDs/query, 2xx/204, JSON inválido, erro HTTP/transporte e close | Suíte Dart existente; execução pendente |
| Injeção de dependências | Delegação, erros, isolamento entre composições e preservação de `this` nas rotas | Aprovado com mocks; HTTP real pendente |
| Factory Method de usuários | Aluno com turma, professor sem turma, perfis normalizados/inválidos, hash, retorno sem senha, duplicidade e login | Aprovado com mocks; banco real pendente |
| Extração de `_SectionCard` | Três seções preservam conteúdo, espaçamento, borda, sombra e adaptação a fonte grande | Inspeção visual/widget pendente |
| XP movido para `xpFormatado` | 0, 999, 1.000, 10.000; mesmo formato no destaque e linhas | Widget/visual pendente |
| Padronização de modelos/status/datas | `pendente`, `aprovada`, `recusada`, pontuação consistente, data ISO e fuso de Manaus | Avaliação unitária parcial; integração pendente |
| Extração de validações de cadastro acadêmico | Nome, e-mail, senha e duplicidade; comparar regras com serviço real | Suíte de simulação existente; execução pendente |
| Renomeação de IDs de evidências | Aprovar/recusar a evidência correta, mantendo IDs de desafio/aluno distintos | Delegação parcial; aceite pendente. Rotas atuais continuam com `:id` |

## 3. Defeitos e prioridades

| ID | Prioridade | Evidência / ação |
|---|---|---|
| BUG-XP | Alta | Teste reproduz 300 XP ao aprovar duas vezes evidência de 150 XP. Tornar concessão única e transacional; testar concorrência e rollback real |
| BUG-VALIDACAO-DATA | Alta | Fachada aceita data inválida e tenta persistir. Rejeitar antes do repositório |
| BUG-VALIDACAO-NUMERO | Alta | Fachada aceita pontuação não numérica. Validar número finito e definir limites de negócio |
| UPLOAD | Alta | `ApiService.anexarEvidencia` envia JSON com nome; backend exige multipart `foto` e `alunoId`. Integrar seleção/envio real e testar pela tela |
| ACESSO | Alta | Autenticação/autorização completas continuam pendentes conforme relatório e rotas atuais. Testar sessão ausente, aluno avaliando e professor acessando outra turma |
| RECUPERACAO | Média | Cliente chama `/auth/forgot-password`, mas servidor não registra essa rota. Implementar fluxo ou tratar indisponibilidade explicitamente |
| CACHE | Média | Exercitar Redis desligado, cache inválido e invalidação após aprovação; definir comportamento esperado quando cache falhar |

Não corrigimos as regras de negócio nesta bateria: os defeitos permanecem identificados para correção e validação, sem transformar o comportamento incorreto em expectativa de sucesso.

## 4. Lista de trabalho para validar o app inteiro

Use usuários e dados exclusivamente de desenvolvimento. Para cada caso, anote data, commit, plataforma, passos, esperado, obtido e evidência (log/captura).

- [x] Inventariar refatorações e separar simulações de código de produção.
- [x] Executar regressões de backend existentes.
- [x] Acrescentar regressões de turmas, ranking, avaliação e reproduções de defeitos.
- [x] Configurar `npm test`, separar Jest e disponibilizar endereço configurável da API.
- [ ] Disponibilizar Node com npm, Docker Desktop e Flutter no terminal.
- [ ] Instalar dependências, iniciar PostgreSQL/Redis e aplicar migrações em banco local.
- [ ] Rodar Jest, Flutter tests, `flutter analyze`, tipos TypeScript e build web/Android.
- [ ] Corrigir os três TODOs e confirmar que nenhum defeito conhecido impede o fluxo principal.
- [ ] Cadastro: professor válido; aluno com código válido; código inexistente; perfil ausente; e-mail duplicado; senha curta/ausente; nome/e-mail inválidos. Erros devem ser claros e não criar registros parciais.
- [ ] Login: credenciais válidas para ambos os perfis, senha incorreta, usuário inexistente, falha de rede, logout e troca de usuário sem dados da sessão anterior.
- [ ] Turmas: criar com nome válido, campos vazios, código de seis caracteres, 9/10/11 turmas, colisão de código, listagem por professor, exclusão confirmada/cancelada e turma inexistente.
- [ ] Desafios: criar/listar, preservar título/descrição/XP, validar data inválida/passada/próxima, fuso horário e limites de pontuação; verificar se turma correta visualiza o desafio.
- [ ] Evidências: selecionar foto real, enviar multipart, campos ausentes, IDs inválidos, formato/tamanho não permitido, cancelamento, envio duplicado, desafio vencido e visualização da imagem pelo professor.
- [ ] Avaliação: pendências, aprovar, recusar com motivo, motivo vazio; conferir status e justificativa no aluno; impedir reavaliação indevida.
- [ ] XP: uma aprovação concede uma recompensa; clique duplo e requisições concorrentes não duplicam; falha entre alteração de status e XP desfaz a operação inteira.
- [ ] Ranking: turma vazia, 1/5/6 alunos, ordem decrescente, posição fora do top 5, empates, cache hit/miss, expiração e atualização após aprovação.
- [ ] Perfil e preferências: carregar usuário correto; salvar tamanho de fonte/contraste; reabrir tela e relogar; verificar persistência e isolamento entre usuários.
- [ ] Interface: navegação normal de aluno/professor, voltar, teclado, campos obrigatórios, carregamento e mensagem de erro; menu de desenvolvimento não conta como fluxo de aceite.
- [ ] Acessibilidade: fonte ampliada sem corte, contraste nas telas completas, rótulos para leitor de tela, foco/teclado e alvos de toque.
- [ ] Segurança: rotas sem sessão, perfil indevido, IDs de outra turma/usuário e retorno sem senha/hash; validar restrições no servidor.
- [ ] Resiliência: backend/banco/Redis indisponíveis, respostas inválidas, rede lenta e repetição de operação; não exibir sucesso falso.
- [ ] Persistência: reiniciar backend e containers sem apagar volumes; cadastros, turmas, evidências, XP e preferências continuam consistentes.
- [ ] Plataforma: repetir o fluxo principal no navegador e Android; câmera/arquivos e rede precisam de validação no dispositivo.
- [ ] Registrar relatório final e automatizar os casos de integração em banco de testes isolado antes de integrar à CI.

## 5. Rodar localmente no Windows

### Preparação

Disponibilize Node 24 com npm, Docker Desktop iniciado e Flutter SDK no PATH. Feche e reabra o terminal após ajustar o PATH. Para Android, configure também SDK/emulador; para começar pelo navegador, isso não é necessário.

Na raiz do repositório:

```powershell
.\scripts\verificar-ambiente.ps1
node --experimental-vm-modules --test backend/tests/*.test.cjs
```

O diagnóstico retorna código 1 se faltar ferramenta. Ele não instala programas nem altera bancos.

Após disponibilizar npm, instale também as dependências da raiz para executar as simulações acadêmicas:

```powershell
npm ci
npm run test:simulacoes
```

### Terminal 1 — backend

```powershell
cd backend
if (-not (Test-Path .env)) { Copy-Item .env.example .env }
npm ci
docker compose up -d
docker compose exec -T postgres pg_isready -U postgres -d projeto_verde
docker compose exec -T redis redis-cli ping
npx prisma generate
npx prisma migrate deploy
npm run typecheck
npm test
npm start
```

Espere PostgreSQL responder que aceita conexões e Redis responder `PONG` antes das migrações; repita a verificação se ainda estiverem iniciando. Confira que `.env` aponta para o banco **local de desenvolvimento** antes de migrar.

`npm start` agora executa o servidor TypeScript com `.env` carregado. `npm run dev` faz o mesmo, mas também inicia o Docker por meio de `predev`. A configuração de exemplo usa PostgreSQL em 5432, Redis em 6379 e API em 3000.

Em outro terminal, verifique o servidor:

```powershell
Invoke-RestMethod http://localhost:3000/
Invoke-RestMethod http://localhost:3000/api/desafios
```

A primeira chamada deve informar que o servidor está online. A segunda deve devolver uma lista (possivelmente vazia) e exercita acesso ao banco; a primeira isoladamente não comprova conexão com o banco.

**Não execute o seed para preparar esse teste:** `backend/prisma/seed.ts` apaga dados existentes antes de popular. Cadastre um professor pela interface, crie uma turma e use o código dela para cadastrar um aluno de teste.

### Terminal 2 — Flutter no navegador

Partindo da raiz:

```powershell
cd codigo-fonte
flutter doctor
flutter pub get
flutter test
flutter analyze
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:3000/api
```

Se Chrome não estiver disponível, veja `flutter devices` ou use:

```powershell
flutter run -d web-server --web-port=8080 --dart-define=API_BASE_URL=http://localhost:3000/api
```

Abra `http://localhost:8080` no navegador. O backend precisa continuar ativo no primeiro terminal.

### Android

No emulador Android padrão, use o endereço do computador anfitrião:

```powershell
flutter devices
flutter run -d ID_DO_EMULADOR --dart-define=API_BASE_URL=http://10.0.2.2:3000/api
```

Substitua `ID_DO_EMULADOR` pelo ID retornado. Em celular físico, use o IP local do computador no lugar de `10.0.2.2`, ambos na mesma rede. Confira permissão de internet, política de HTTP e acesso à porta 3000 se houver falha. `localhost` no celular aponta para o próprio celular.

### Aceite mínimo, em ordem

1. Cadastrar professor de teste e fazer login.
2. Criar turma e copiar seu código.
3. Cadastrar aluno com esse código e fazer login.
4. Professor criar desafio com prazo futuro e 150 XP.
5. Aluno visualizar desafio e enviar foto real — atualmente bloqueado pela integração de upload.
6. Professor visualizar foto, aprovar e conferir 150 XP no aluno/ranking.
7. Repetir aprovação: XP deve continuar 150 — defeito atualmente reproduzido.
8. Enviar outra evidência e recusá-la com motivo; XP não aumenta.
9. Alterar preferências, sair, entrar novamente e confirmar comportamento.
10. Reiniciar os serviços e conferir persistência.

### Encerrar

Use `Ctrl+C` nos terminais do Flutter e backend. Na pasta `backend`, `docker compose stop` interrompe banco/cache preservando os dados. Não remova volumes para repetir testes.

## Critério de conclusão

Somente declarar o app validado quando: testes sem TODOs de defeitos, análises e builds verificados, roteiro principal concluído em ambiente real, autorização validada e pendências restantes registradas com impacto aceito. O resultado atual é uma base de regressão com defeitos conhecidos, não uma aprovação completa do produto.
