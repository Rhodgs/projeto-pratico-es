# Inventario e Tratamento de Dados Pessoais
**Projeto MVP - Documentação Inicial**

---

### 1. Identificação do Projeto e Responsáveis

| Campo | Valor |
| :--- | :--- |
| **Nome do Projeto** | Jornada Verde |
| **Grupo / Equipe** | Rhuan Lucas Cunha Rodrigues e equipe |
| **Área / Disciplina** | Engenharia de Software - ICET/UFAM |
| **Responsável pelo documento** | Rhuan Lucas Cunha Rodrigues |
| **Data de criação** | 13/06/2026 |
| **Versão** | 1.0 |
| **Última atualização** | 13/06/2026 |

---

### 2. Descrição do Sistema e do Tratamento de Dados

**O que o sistema faz:**
Plataforma gamificada de educação ambiental que conecta alunos e professores, permitindo a gestão de turmas, o envio de evidências de missões ecológicas e o acompanhamento de progresso num ranking.

**Por que dados pessoais são necessários:**
Para identificar com segurança os usuários (diferenciando perfis de Aluno e Professor), garantir a integridade do sistema de gamificação (atribuição de XP e selos ao aluno correto) e permitir a comunicação através de notificações push de novos desafios.

---

### 3. Agentes de Tratamento

| Papel | Nome / Descrição | Contato / E-mail |
| :--- | :--- | :--- |
| **Controlador** (quem decide o quê e como tratar) | Equipe de Desenvolvimento do Jornada Verde | rhuan.rodrigues@ufam.edu.br |
| **Encarregado** (responsável por privacidade no grupo) | Rhuan Lucas Cunha Rodrigues | rhuan.rodrigues@ufam.edu.br |
| **Operador** (serviço externo que processa dados) | Google (Firebase Auth / Firebase Cloud Messaging) | Não se aplica |

---

### 4. Finalidade do Tratamento

| Campo | Descrição |
| :--- | :--- |
| **4.1 Hipótese de tratamento** | Mediante consentimento do titular (art. 7º, I, LGPD) e para execução de serviços da plataforma (art. 7º, V, LGPD). |
| **4.2 Finalidade** | Permitir o registro seguro, diferenciação de privilégios (Aluno/Professor), gestão do progresso acadêmico e envio de notificações. |
| **4.3 Previsão legal/Referência normativa** | LGPD, art. 7º, I e Termos de Uso aceitos no momento do registro. |
| **4.4 Resultado esperado para o usuário** | Acesso a um *dashboard* personalizado com seu histórico, ranking (Top 50), turmas vinculadas e missões pendentes. |
| **4.5 Benefício para o projeto / sociedade** | Fomento do engajamento ambiental através da retenção do usuário numa plataforma gamificada e estruturada de forma segura. |

---

### 5. Fluxo de Tratamento dos Dados

| Fase | Descrição do que acontece no seu sistema |
| :--- | :--- |
| **Coleta** | Dados inseridos pelo usuário via formulário no Aplicativo Móvel (Flutter) durante o registro. |
| **Armazenamento** | Dados persistentes salvos no PostgreSQL (via Prisma ORM). Dados voláteis de pontuação salvos em Cache/Redis. Credenciais no Firebase Auth. |
| **Processamento / Uso** | Processados pela API Node.js para validação de regras de negócio, cálculo de XP e ordenação do Ranking. |
| **Compartilhamento** | Metadados (E-mail, Senha e Tipo de Perfil) compartilhados com Firebase Auth. Tokens de dispositivos compartilhados com FCM. |
| **Eliminação** | Dados apagados da base de dados e do Firebase Auth após a solicitação explícita de exclusão da conta pelo usuário. |

---

### 6. Categorias de Dados Pessoais Coletados

#### 6.1 Dados de Identificação Pessoal

| Dado | Coletado? | Tempo de Retenção | Meio de Coleta | Forma de Armazenamento |
| :--- | :---: | :--- | :--- | :--- |
| Nome completo | ☑ | Até a conta ser excluída | Formulário online | Banco de dados relacional (PostgreSQL) |
| Endereço de e-mail | ☑ | Até a conta ser excluída | Formulário online | B.D. Relacional e Firebase Auth |
| Número de telefone | ☐ | | | |
| Endereço residencial | ☐ | | | |
| CPF | ☐ | | | |
| RG | ☐ | | | |
| Data de nascimento | ☐ | | | |
| Foto / Avatar | ☑ | Até a conta ser excluída | Upload de arquivo | Storage e PostgreSQL (URL) |
| Outro: Tipo de Perfil | ☑ | Até a conta ser excluída | Formulário online | B.D. Relacional e Firebase Auth |

#### 6.2 Dados de Acesso e Identificação Digital

| Dado | Coletado? | Tempo de Retenção | Meio de Coleta | Forma de Armazenamento |
| :--- | :---: | :--- | :--- | :--- |
| Nome de usuário (login) | ☐ | | | |
| Senha (hash) | ☑ | Até troca ou exclusão | Formulário online | Firebase Auth |
| Endereço IP | ☐ | | | |
| Tokens de sessão / autenticação | ☑ | Duração da sessão | Integração com API | Firebase e Dispositivo Móvel |
| Logs de acesso | ☐ | | | |
| Outro: Token de Push (FCM) | ☑ | Até logoff / exclusão | Integração com API | Firebase Cloud Messaging |

#### 6.3 Dados de Uso do Sistema

| Dado | Coletado? | Tempo de Retenção | Meio de Coleta | Forma de Armazenamento |
| :--- | :---: | :--- | :--- | :--- |
| Histórico de ações no sistema | ☑ | Até a conta ser excluída | Geração interna | PostgreSQL (Evidências/Missões) |
| Preferências do usuário | ☑ | Até a conta ser excluída | Formulário online | Firebase Auth (Metadados) |
| Dados de navegação / cliques | ☐ | | | |
| Dispositivo/sistema operacional | ☐ | | | |
| Outro: Pontuação/Ofensivas | ☑ | Até a conta ser excluída | Geração interna | Banco em memória (Redis) |

---

### 7. Dados Pessoais Sensíveis [OPCIONAL]

Não se aplica. O sistema Jornada Verde não coleta dados sensíveis (origem racial, religião, dados biométricos ou de saúde). As configurações de acessibilidade da interface referem-se a preferências de visualização (paleta de cores e fonte) e não constituem dados de saúde diretamente identificáveis.

---

### 8. Categorias de Usuários (Titulares)

| Tipo de Usuário | Descrição |
| :--- | :--- |
| **Aluno / Estudante** | Usuário final que realiza missões, envia evidências, consome conteúdos educativos e acumula XP/Selos. |
| **Professor** | Gestor da turma, responsável por criar desafios, avaliar evidências e atribuir selos aos estudantes. |

---

### 9. Compartilhamento de Dados com Terceiros

| Serviço / Empresa | Dados Compartilhados | Finalidade |
| :--- | :--- | :--- |
| **Firebase Auth (Google)** | E-mail, Senha (hash) e Tipo de Perfil | Gestão de identidade e autenticação segura. |
| **Firebase Cloud Messaging** | Payload de texto e Tokens de dispositivo | Disparo de notificações push de novos desafios. |

---

### 11. Medidas de Segurança Adotadas

| Medida | Adotada? | Descrição de como foi implementada |
| :--- | :---: | :--- |
| Senhas armazenadas com hash | ☑ | Delegado nativamente ao ecossistema do Firebase Auth. O backend em Node.js não manipula senhas em texto limpo. |
| HTTPS/TLS em todas as comunicações | ☑ | Conexões criptografadas padrão de mercado nas requisições da API Node.js. |
| Controle de acesso por perfil (autenticação) | ☑ | Validação rigorosa gerenciada pelo componente `AuthMiddleware`, que barra acessos indevidos a rotas restritas. |
| Variáveis de ambiente para credenciais | ☑ | Uso de arquivos `.env` para proteger as credenciais de conexão do Prisma, PostgreSQL e Redis. |
| Backup regular dos dados | ☐ | A ser implementado em ambiente de produção definitivo. |
| Política de senhas fortes para usuários | ☑ | O Aplicativo Móvel valida localmente a exigência de 8 caracteres, uma maiúscula e um número no cadastro. |
| Logs de acesso e auditoria | ☐ | A ser implementado em versões futuras. |
| Validação e sanitização de entradas | ☑ | Utilização do ORM Prisma para blindagem contra SQL Injection nas consultas ao banco de dados. |

---

### 12. Direitos dos Usuários e Como São Atendidos

| Direito do Usuário | Como o sistema atende (ou planeja atender) |
| :--- | :--- |
| **Confirmação de tratamento** | Visível no perfil do usuário, que exibe o seu progresso, XP acumulada e turmas vinculadas. |
| **Acesso aos próprios dados** | Usuário pode visualizar seu histórico completo de missões na tela inicial. |
| **Correção de dados incompletos** | Funcionalidade planejada para a seção de "Configurações" da conta no aplicativo móvel. |
| **Exclusão de dados** | Deleção em cascata no PostgreSQL e Firebase após solicitação explícita de exclusão da conta. |
| **Portabilidade dos dados** | Não implementado nesta versão MVP. |
| **Revogação do consentimento** | Ocorre por meio da exclusão definitiva da conta na plataforma. |

---

### 13. Levantamento de Riscos

| # | Risco | Medida de Mitigação |
| :--- | :--- | :--- |
| **1** | Acesso não autorizado ao banco de dados | Utilização do Prisma ORM para evitar SQL Injection e isolamento do PostgreSQL em ambiente seguro. |
| **2** | Vazamento de senhas | Uso do Firebase Auth (BaaS), eliminando a responsabilidade da API de armazenar senhas na própria base de dados. |
| **3** | Ações indevidas entre diferentes perfis | Interceptação de todas as requisições pelo `AuthMiddleware`, validando o token JWT antes de encaminhar para o `Controller`. |

---

### 14. Termo de Consentimento / Aviso de Privacidade

**O sistema exibe um aviso de privacidade ou termo de uso?**
☑ Sim - descreva onde e como: No ecrã de registro do aplicativo móvel, antes da conclusão do envio do formulário, com checkbox obrigatório de aceite.

**O consentimento é registrado no sistema?**
☑ Sim - descreva como: Associado à criação da conta no Firebase Auth no momento do clique no botão de registro.

**Quais informações o aviso de privacidade contém?**

| Informação | Incluída? |
| :--- | :---: |
| Quais dados são coletados | ☑ |
| Por que os dados são coletados (finalidade) | ☑ |
| Com quem os dados são compartilhados | ☑ |
| Por quanto tempo os dados são retidos | ☑ |
| Como o usuário pode exercer seus direitos | ☑ |
| Contato do responsável pelo projeto | ☑ |
