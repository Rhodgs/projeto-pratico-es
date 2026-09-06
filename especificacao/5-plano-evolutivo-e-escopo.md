# Plano evolutivo e consolidação do escopo — Jornada Verde

Registro atualizado em 06/09/2026.

## 1. Objetivo e limites deste registro

Organizar decisões, propostas e correções futuras do ciclo de vida do aplicativo. Os itens abaixo são planejamento; não representam funcionalidades concluídas nem autorização para iniciar sua implementação nesta etapa.

O Jornada Verde mantém o objetivo de incentivar ações ambientais por meio de desafios, evidências, pontuação, progresso com XP, medalhas e rankings. Android é a plataforma de entrega; web é o ambiente inicial de testes. A validação em Android deverá fazer parte dos critérios de entrega, especialmente para fotos, permissões e acesso à API.

## 2. Público e decisão de escopo pendente

A professora solicitou a mudança do foco estudantil para o público geral. Durante a análise, surgiu a alternativa de manter o foco estudantil com acesso institucional controlado, simplificando a confirmação do vínculo de professores e alunos.

**Situação:** registrar a alternativa institucional como proposta de evolução futura solicitada pelo usuário. A definição final do público e a compatibilidade com as orientações da professora ainda precisam ser alinhadas. Este registro não declara aprovada a reversão para o público estudantil.

Se prevalecer o público geral, será necessário decidir quem cria desafios e avalia evidências. Foram discutidas moderação pela equipe, avaliação comunitária, autodeclaração e auxílio de IA; nenhuma dessas alternativas foi escolhida como solução definitiva.

## 3. Proposta futura: acesso institucional e modelo B2B

### Fluxo proposto

1. A equipe do Jornada Verde confirma a instituição e seu representante por contato institucional independente e ativa seu acesso.
2. Um responsável institucional autorizado convida professores. No piloto, a equipe do Jornada Verde poderá realizar esses convites.
3. Os professores convidados ativam suas contas e definem suas próprias senhas; não recebem privilégios apenas por selecionar o perfil no cadastro.
4. Professores criam turmas e compartilham códigos de solicitação de entrada ou convites individuais.
5. Alunos utilizam cadastro simplificado e solicitam participação. O professor confere o vínculo com a turma e aprova ou recusa a solicitação.
6. Professores publicam desafios e avaliam evidências das turmas sob sua responsabilidade.
7. Responsáveis autorizados podem revogar convites e vínculos, desativar acessos e transferir turmas quando um professor sair.

O contrato formaliza a relação comercial; convites, aprovações e permissões no servidor controlam o acesso. O vínculo é confirmado pela instituição e pelo professor, sem exigir verificação documental individual no fluxo proposto. E-mail institucional isolado não comprova o papel de professor, e código de turma isolado não comprova matrícula.

### Hipótese comercial

Licenciamento para instituições privadas caracteriza a proposta B2B. Contratações por órgãos públicos exigem planejamento próprio de B2G. Licença por instituição com faixas de alunos ativos é uma hipótese a validar, sem preços ou garantia de viabilidade definidos. Cobrança automatizada não é requisito confirmado do MVP.

### Dados e privacidade

Coletar somente os dados necessários para conta, vínculo e funcionamento. Não incluir CPF, RG, diploma ou biometria como requisito deste fluxo. Contas e fotos ainda podem conter dados pessoais; aprovação institucional não elimina a necessidade de definir proteção, acesso, retenção, exclusão e tratamento adequado de dados de menores antes do uso real. Rankings e evidências devem ter visibilidade delimitada, a confirmar nos critérios finais.

## 4. Backlog de adições e correções futuras

Todos os itens estão **pendentes**. A prioridade indica ordem técnica sugerida, não prazo ou sprint comprometido.

| ID | Prioridade | Item | Critério de aceitação proposto |
| :--- | :--- | :--- | :--- |
| ESC-01 | Primeiro | Confirmar público e requisitos com a professora | Decisão registrada: institucional ou público geral, com responsabilidades de criação e avaliação definidas. |
| SEG-01 | Alta | Implementar autenticação e autorização no servidor | Requisições sem sessão válida são rejeitadas; usuário não obtém privilégios alterando perfil ou IDs enviados pelo cliente. |
| INST-01 | Alta, se institucional | Modelar instituição e responsável institucional | Cada instituição possui responsável autorizado e seus dados ficam isolados das demais. |
| INST-02 | Alta, se institucional | Substituir escolha livre de professor por convite autorizado | Convite tem destinatário, validade, uso único e revogação; apenas autoridade permitida concede o papel. |
| INST-03 | Alta, se institucional | Acrescentar aprovação de alunos | Código compartilhado permite solicitar entrada, mas não concede acesso aos dados da turma antes da aprovação. |
| INST-04 | Alta, se institucional | Delimitar turmas, desafios, evidências e rankings | Professor só gerencia turmas autorizadas; aluno só participa e consulta conteúdos permitidos por seu vínculo. |
| INST-05 | Média, se institucional | Gerenciar saída e revogação de usuários | Remoção de vínculo revoga acesso e há fluxo definido para transferência de turmas e destino do histórico. |
| GAM-01 | Alta | Corrigir concessão de XP | Aprovação é transacional e concede XP uma única vez, inclusive sob chamadas repetidas ou simultâneas; política de reversão fica definida. |
| EVI-01 | Alta | Integrar o fluxo real de evidências | Aluno envia foto real; professor carrega a evidência e aprova ou recusa com justificativa; não há sucesso simulado. |
| EVI-02 | Alta | Validar submissões e armazenamento | Servidor verifica prazo, autorização, arquivo e política de duplicidade; falhas não deixam arquivos órfãos; acesso à foto é protegido. |
| GAM-02 | Média | Consolidar regras de gamificação | Pontuação, medalhas, progresso, limites do ranking e desempate têm regras e testes definidos, preservando essas funcionalidades no escopo. |
| DAD-01 | Antes de uso real | Definir ciclo de vida dos dados | Coleta mínima, visibilidade, retenção, exclusão e responsabilidades estão documentadas e refletidas no sistema. |
| QUA-01 | Alta | Testar a implementação real | Testes cobrem API, permissões, isolamento institucional quando aplicável, XP repetido e fluxo completo; não dependem apenas dos serviços de simulação. |
| DOC-01 | Contínua | Atualizar documentação após decisões | Backlog, C4, modelo de dados, instruções de execução e rastreabilidade correspondem ao comportamento entregue. |

## 5. Sequência de evolução

1. **Consolidar escopo:** resolver ESC-01 e definir critérios obrigatórios, sem descartar gamificação.
2. **Estabilizar execução:** validar dependências, compilação, configuração e inicialização reproduzível com dados de demonstração separados.
3. **Proteger o domínio:** autenticação, permissões e, caso aprovado, instituição, convites e vínculos.
4. **Completar o fluxo principal:** desafio, envio real, avaliação, XP consistente e ranking.
5. **Validar e documentar:** testes do código real, integração, cenários de erro, Android e atualização dos documentos.
6. **Evoluir e operar:** funcionalidades restantes, piloto autorizado, suporte e validação da hipótese comercial.

Cada entrega deverá ter critérios atendidos, tratamento de erros, testes pertinentes e documentação correspondente. Aprovação em testes web é intermediária e não substitui validação em Android.

## 6. Referência da proposta

O fluxo de aprovação administrativa de professores tem como referência o [controle de professores verificados do Google Classroom](https://support.google.com/edu/classroom/answer/6071551?hl=en). O Jornada Verde terá regras próprias; esta proposta não pressupõe integração com Google Classroom.
