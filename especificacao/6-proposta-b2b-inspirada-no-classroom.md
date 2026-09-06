# Jornada Verde — especificação da proposta B2B inspirada no Classroom

Data: 06/09/2026.

## 1. Finalidade e situação

Registro individual da ideia discutida com o usuário, consolidado a partir da conversa. É uma síntese da proposta, não uma transcrição integral do chat nem uma declaração de funcionalidades já implementadas.

Esta é a alternativa institucional que pretendemos desenvolver e apresentar para discussão. A professora havia solicitado foco no público geral; a aceitação da continuidade estudantil ainda precisa ser alinhada com ela. Salvar esta especificação não autoriza automaticamente alterações no código.

O planejamento técnico complementar está em [Plano evolutivo e consolidação do escopo](5-plano-evolutivo-e-escopo.md).

## 2. Visão do produto

Incentivar práticas ambientais por meio de um aplicativo mobile com desafios, evidências, pontuação, progresso com XP, medalhas e rankings. Na proposta B2B, instituições de ensino contratam o acesso e utilizam o aplicativo com seus professores e estudantes.

Android é a plataforma de entrega. Web é o ambiente inicial de testes, sem substituir a validação no Android, especialmente para fotos, permissões e comunicação com a API.

## 3. Inspiração no Classroom

A inspiração é o fluxo de organização e acesso: instituição autoriza professores, professores organizam turmas e estudantes ingressam por convite ou código. O diferencial do Jornada Verde permanece nas ações ambientais e na gamificação.

Não está prevista integração com Google Classroom nem reprodução integral de suas funcionalidades. Referência consultada na discussão: [verificação de professores e permissões no Classroom](https://support.google.com/edu/classroom/answer/6071551?hl=en).

## 4. Papéis e responsabilidades propostos

| Papel | Responsabilidades |
| --- | --- |
| Equipe Jornada Verde | Contatar instituições, confirmar o representante autorizado, ativar a instituição e prestar suporte. No piloto, pode enviar convites aos professores. |
| Responsável institucional | Autorizar professores e administrar vínculos da própria instituição. Este papel é uma adição proposta ao modelo atual. |
| Professor autorizado | Criar e gerenciar suas turmas, aprovar participantes, publicar desafios e avaliar evidências. |
| Aluno aprovado | Participar das turmas autorizadas, realizar atividades, enviar evidências e acompanhar recompensas e progresso. |

## 5. Fluxo de acesso e confirmação de vínculo

1. Jornada Verde entra em contato com a instituição interessada e confirma seu representante por um canal institucional independente da solicitação.
2. A relação comercial é formalizada e a instituição é ativada.
3. O responsável institucional, ou a equipe Jornada Verde no piloto, convida professores autorizados.
4. O professor aceita o convite e define sua própria senha. Escolher “Professor” no cadastro não concede esse privilégio.
5. O professor cria turmas e compartilha códigos de solicitação de entrada ou convites individuais.
6. O aluno faz um cadastro simplificado e solicita participação.
7. O professor confere o vínculo com sua lista de alunos e aprova ou recusa a solicitação.
8. Somente participantes aprovados acessam os dados e atividades restritos à turma.

O contrato formaliza a relação comercial. Convites, aprovações e verificações de permissão no servidor controlam o acesso. O vínculo é confirmado pela instituição e pelo professor; não se propõe conferência individual de CPF, RG, diploma, selfie ou biometria.

E-mail institucional isolado não comprova que alguém seja professor. Código de turma isolado não comprova matrícula, pois pode ser compartilhado. A aprovação de entrada é a proteção proposta para esse caso.

Convites devem ter validade, uso único e possibilidade de revogação. Também deverá ser definido como remover vínculos e transferir turmas quando um professor sair.

## 6. Funcionalidades que queremos preservar

- Desafios e missões ambientais com objetivos claros.
- Regras de pontuação e recompensas.
- Envio de fotos como evidências das ações.
- Avaliação pelo professor, com aprovação ou recusa justificada.
- Progresso individual com XP.
- Medalhas e reconhecimento por conquistas.
- Rankings com escopo e critérios de desempate definidos.
- Organização por turmas e acompanhamento dos participantes.
- Recursos de acessibilidade visual e identificação dos controles.

Fluxo central: professor publica desafio para a turma → aluno realiza a ação e envia evidência → professor avalia → aprovação concede a recompensa uma única vez → progresso e ranking são atualizados.

Os valores de XP, critérios de medalhas, limites do ranking, prazos e regras de reenvio ainda precisam ser consolidados. Não há aprovação para eliminar ou reduzir a gamificação.

## 7. Modelo comercial proposto

- Instituição contratante como cliente; professores e estudantes como usuários.
- Hipótese inicial: licença por instituição, com faixas de alunos ativos.
- Valor oferecido: organização de projetos ambientais, gestão de desafios e acompanhamento da participação, com gamificação para engajamento.
- Suporte e implantação podem compor a oferta; formato ainda não definido.
- Preços, duração contratual, limites, condições comerciais e disposição das instituições para pagar precisam ser validados.
- Cobrança automatizada não foi definida como requisito do MVP.
- A proposta B2B se aplica às instituições privadas; contratação por órgãos públicos requer planejamento próprio de B2G.

Ter um comprador institucional torna a oferta mais clara, mas não comprova facilidade de venda ou viabilidade financeira.

## 8. Segurança, dados e limites de responsabilidade

- Autenticar usuários e verificar permissões no servidor.
- Separar os dados de cada instituição e restringir ações conforme o vínculo com a turma.
- Coletar apenas os dados necessários ao funcionamento; campos obrigatórios ainda serão definidos.
- Evitar exigir documentos individuais no fluxo proposto.
- Definir visibilidade de rankings e evidências; a proposta inicial é acesso restrito às pessoas autorizadas.
- Definir retenção, exclusão e destino do histórico quando um vínculo termina.
- Reconhecer que contas, fotos e vínculos escolares podem conter dados pessoais mesmo com cadastro simplificado.
- Definir o tratamento adequado de dados de menores antes de uso real; a aprovação institucional não resolve sozinha essas responsabilidades.

## 9. Evolução técnica necessária

1. Confirmar o direcionamento institucional com a professora e fechar os requisitos da entrega.
2. Tornar a execução reproduzível e verificar compilação e configuração.
3. Implementar autenticação, autorização e isolamento entre instituições.
4. Acrescentar instituição, responsável institucional, convites e aprovação de alunos.
5. Vincular desafios às turmas e limitar a avaliação aos professores responsáveis.
6. Integrar fotos reais, listagens e justificativas, substituindo simulações nas telas.
7. Garantir aprovação transacional e concessão única de XP, inclusive sob requisições simultâneas.
8. Consolidar regras de medalhas, progresso e ranking.
9. Testar o código real, os acessos indevidos e o fluxo completo em web e Android.
10. Atualizar backlog, arquitetura, instruções e rastreabilidade conforme cada entrega.

## 10. Ideias discutidas que não foram escolhidas

Para a alternativa de público geral, discutimos autodeclaração, moderação pela equipe, avaliação comunitária, auxílio de IA e um modelo híbrido. Nenhuma foi escolhida como solução definitiva.

Na proposta institucional, o professor continua responsável pela avaliação. Não está prevista substituição por IA, votação comunitária ou suporte do Jornada Verde. Isso distribui a avaliação entre as instituições, mas não constitui um sistema totalmente descentralizado.

Quizzes, conteúdos educativos, notificações, mapas, sequência de dias, funcionamento offline e relatórios detalhados continuam com prioridade e obrigatoriedade pendentes; não foram automaticamente removidos nem confirmados para a próxima entrega.

## 11. Decisões ainda necessárias

- A professora aceita a contraproposta estudantil B2B?
- Qual é o prazo e quais funcionalidades e documentos são obrigatórios?
- O piloto terá responsável institucional no aplicativo ou convites geridos pela equipe Jornada Verde?
- Quais dados mínimos serão exigidos e como ocorrerá a recuperação de conta?
- Quais serão as regras finais de XP, medalhas, ranking, prazos, reenvio e revisão de avaliações?
- Qual será a política de visibilidade, retenção e exclusão dos dados?
- Qual instituição participaria de um piloto e como validaríamos interesse comercial?

## 12. Critério proposto de entrega

Uma funcionalidade só será considerada concluída após atender seus critérios de aceitação, operar com dados reais, tratar erros relevantes, passar por testes pertinentes e ter documentação correspondente. Para a entrega mobile, o fluxo deverá ser validado no Android. Demonstrações acadêmicas podem utilizar instituição e usuários fictícios.
