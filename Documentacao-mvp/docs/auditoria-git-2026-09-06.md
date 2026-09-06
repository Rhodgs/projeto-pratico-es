# Auditoria de commits e integridade — 06/09/2026

## Conclusão

As quatro refatorações estão preservadas na `main` local e publicada. Foi identificado e recuperado um documento de planejamento que não constava dos commits atuais. Não foi encontrada perda do código final das refatorações.

## Evidências do Git

- A consulta direta ao GitHub retornou `60cc17a9e82dbbb841dcbea2eb80e96ea4d19147` para `refs/heads/main`, o mesmo commit da cópia local.
- O diff de `86e8163` (refatorações concluídas) para `60cc17a` contém somente a adição de `relatorio-mudancas-2026-09-06.md`. Todos os demais arquivos são idênticos entre essas duas versões.
- Os commits dos problemas 1, 2, 3 e 4 estão no histórico da main, incluindo os merges dos PRs #91, #92 e #93.
- No início da auditoria, não havia alterações locais pendentes nem arquivos rastreados ausentes. Nenhum arquivo de `work`, `node_modules` ou `.dart_tool` estava versionado.
- A verificação de integridade dos objetos do Git não apresentou corrupção. Foram encontrados objetos antigos sem referência ativa, que foram inspecionados; isso, isoladamente, não é erro de commit.
- Não foram encontrados marcadores de conflito de merge no código examinado. Os avisos de espaços finais do diff estão em documentação, snapshots e fim de arquivo de teste; não indicam perda de implementação.

## Registro temporário de exclusões

O objeto `14774fa99310f28181a65a32192b7e6d18103557`, datado de 19:13:22, tem formato de stash/WIP e registra exclusão de 36 arquivos do backend em relação ao seu primeiro pai, `d3c7f61`. O segundo pai preserva o índice sem essas exclusões. O horário coincide com o pull registrado no reflog.

Esse objeto não está na main e não há stash ativo listado. As exclusões não foram incorporadas à versão atual: o backend está presente, seu conteúdo corresponde ao commit final das refatorações e seus testes passaram. Não há motivo para restaurar esse WIP sobre o projeto atual. O registro não permite atribuir com certeza qual ação da interface originou as exclusões.

## Documento recuperado

O arquivo `especificacao/6-proposta-b2b-inspirada-no-classroom.md` foi localizado na árvore antiga `53246d58b4a8649899caae96d928dcf4e3196a37`. Ele não estava na main e não apareceu no histórico de commits consultado para esse caminho.

Foi recuperado para seu caminho original, sem substituir arquivo existente. É uma proposta de planejamento, não implementação nem decisão definitiva de público. A recuperação fica como arquivo novo para revisão e commit. Nenhum código de versões intermediárias foi reaplicado.

## Verificações executadas nesta auditoria

| Verificação | Resultado |
| --- | --- |
| Suítes backend de desafios, cadastro, dependências e rotas | 37 aprovados, 0 falhas |
| TypeScript com `--noEmit --ignoreDeprecations 6.0` | Aprovado |
| Comparação entre código final refatorado e main atual | Idêntico |
| Comparação do commit local com main no GitHub | Idêntico |
| Integridade dos objetos Git | Sem corrupção reportada |
| Reexecução da suíte Dart | Não realizada: executável do SDK temporário ausente |

O ambiente em `work/validacao-api` está incompleto: a pasta existe, mas `dart-sdk/bin/dart.exe` não está presente. Os serviços Dart, os 33 testes e o snapshot anterior continuam versionados. Os 33 resultados aprovados descritos no relatório anterior são históricos, não uma nova execução desta auditoria.

Não foram executados build Flutter, testes em Android, integração com banco/Redis ou servidor real. A aprovação dos testes isolados não certifica todos os fluxos do aplicativo.

## Pendências de funcionamento confirmadas na leitura

São questões anteriores ou já delimitadas nas refatorações, sem evidência de terem sido causadas pelos merges de hoje:

- `DesafiosService.aprovarEvidencia` ainda incrementa XP sem impedir aprovação repetida e sem transação conjunta da alteração de status e XP.
- `ApiService.anexarEvidencia` ainda envia JSON com nome de arquivo; o servidor exige foto multipart e identificação do aluno.
- O servidor ainda não possui middleware de autenticação/autorização nas rotas examinadas; IDs enviados pelo cliente são usados em operações.
- `ValidacaoCriacaoDesafio` mantém verificações incompletas para data inválida e pontuação inválida. A extração preservou essas limitações, sem implementar validação completa de entrada.
- Recuperação de senha, início de quiz e conteúdos de aprendizado têm chamadas no ApiService sem rotas correspondentes em `server.ts`.
- A URL da API continua `localhost`, dependente do ambiente de execução.
- O comando genérico `npm test` permanece como placeholder; os testes aprovados utilizam os scripts específicos.

## Como interpretar os milhares de arquivos

SDKs, caches e dependências podem gerar milhares de arquivos locais e não precisam entrar em commits; as pastas de validação estão no `.gitignore`. Entretanto, quantidade de arquivos não é critério seguro para descartar: o documento recuperado demonstra que trabalho útil também pode ficar fora dos commits.

Antes de descartar, conferir o caminho e o diff: dependências geradas podem ser reinstaladas, mas alterações em `backend/src`, `codigo-fonte/lib`, testes e documentação precisam ser avaliadas. Um arquivo já existente na main pode conter mudanças locais importantes.

Esta auditoria não alterou código, commits, branches ou conteúdo publicado. As únicas adições são o documento recuperado e este relatório. Conteúdo nunca salvo como objeto Git não pode ser reconstruído com certeza a partir do histórico; portanto, a conclusão de preservação se aplica ao código final registrado e às evidências disponíveis.
