<h1 align="center">📍 Rastreabilidade Arquitetural</h1>
<p align="center"><i>Mapeamento das Histórias de Usuário no Modelo C4</i></p>

<hr>

## 🎯 US01: Manter Ofensiva Diária

<blockquote>
  <i>"Como estudante, desejo manter uma sequência de dias ativos para me sentir motivada a interagir com o app diariamente"</i>
</blockquote>

### 🔍 Evidência no Modelo C4
  * **Diagrama de Containers:** Comunicação entre o `Aplicativo Móvel`, a `API de Backend` e o `Cache (Redis)`
  * **Diagrama de Componentes:** Fluxo interno passando pela autenticação e pelo módulo de Ranking

<br>

<div align="center">
  <img width="6364" height="3364" alt="US1compone drawio" src="https://github.com/user-attachments/assets/85fa556e-79dd-4be2-8a70-5fdbe8521b2a" />
  <br><br>
  <em><b>Figura 1:</b> Rastreabilidade da US01</em>
</div>

<br>

### ⚙️ Passos de Execução (Nível 3)

1. **Requisição:** O Aplicativo Móvel envia o sinal de conclusão da atividade (ex: Quiz finalizado)
2. **Autenticação:** O `AuthMiddleware` intercepta a requisição, valida o token do usuário e repassa para o controlador
3. **Recepção:** O `RankingController` recebe a requisição validada
4. **Regra de Negócio:** O `RankingService` processa a regra para validar a sequência de dias ativos
5. **Persistência:** O `RankingRepository` faz a consulta/escrita rápida no `Cache/Ranking` (Redis) para atualizar a ofensiva

<hr>

## 🎯 US02: Visualizar Ranking Escolar

<blockquote>
  <i>"Enquanto estudante, desejo visualizar um ranking escolar com atualizações imediatas após a pontuação para competir de forma saudável com meus amigos."</i>
</blockquote>

### 🔍 Evidência no Modelo C4
* **Diagrama de Containers:** Comunicação entre o `Aplicativo Móvel`, a `API de Backend` e o `Cache (Redis)`

* **Diagrama de Componentes:** Fluxo interno passando pela autenticação e pela leitura de dados no módulo de Ranking

<br>

<div align="center">
  <img width="6364" height="3364" alt="US2Componen drawio" src="https://github.com/user-attachments/assets/b988fdde-f74e-433e-9206-28f734c0a885" />
  <br><br>
  <em><b>Figura 2:</b> Rastreabilidade do fluxo de execução da US02</em>
</div>

<br>

### ⚙️ Passos de Execução (Nível 3)

1. **Requisição:** O Aplicativo Móvel solicita a listagem do Top 50 e a posição atual do usuário logado
2. **Autenticação:** O `AuthMiddleware` intercepta a requisição, valida o token do usuário e repassa para o controlador
3. **Recepção:** O `RankingController` recebe a requisição de listagem
4. **Regra de Negócio:** O `RankingService` processa as regras de formatação (limite de 50 estudantes) e aplica o critério de desempate por ordem cronológica
5. **Recuperação de Dados:** O `RankingRepository` realiza a operação de leitura em alta velocidade dos dados no `Cache/Ranking` (Redis) e devolve as pontuações para atualizar a interface

## 🎯 US03: Criar Turmas

<blockquote>
  <i>"Enquanto professor, desejo criar 'turmas' dentro do aplicativo para gerenciar meus alunos de forma organizada."</i>
</blockquote>

### 🔍 Evidência no Modelo C4
* **Diagrama de Containers:** Comunicação entre o `Aplicativo Móvel`, a `API de Backend` e o `Banco de Dados` (PostgreSQL).
* **Diagrama de Componentes:** Fluxo interno passando pela autenticação e pelo módulo de gerenciamento de Turmas.

<br>

<div align="center">
  <img width="6364" height="3356" alt="US3Componen drawio" src="https://github.com/user-attachments/assets/008fec33-6aca-4752-9a84-d966a66bd63e" />
  <br><br>
  <em><b>Figura 3:</b> Rastreabilidade do fluxo de execução da US03.</em>
</div>

<br>

### ⚙️ Passos de Execução (Nível 3)

1. **Requisição:** O Aplicativo Móvel envia o comando para a criação de uma nova turma.
2. **Autenticação:** O `AuthMiddleware` intercepta a requisição, valida o token do usuário e garante que ele possui o perfil de "Professor".
3. **Recepção:** O `TurmaController` recebe a requisição HTTPS validada.
4. **Regra de Negócio:** O `TurmaService` valida o limite de turmas ativas do professor e gera automaticamente o código alfanumérico único de 6 caracteres (ex: AM42XP).
5. **Persistência:** O `TurmaRepository` executa a operação de escrita estruturada no `Banco de Dados` (PostgreSQL) para salvar a nova turma.

<hr>

## 🎯 US04: Lançar Desafios Práticos

<blockquote>
  <i>"Como professor, desejo lançar desafios práticos para tirar as aulas da teoria e focar em causas reais, permitindo que os alunos interajam com a atividade."</i>
</blockquote>

### 🔍 Evidência no Modelo C4
* **Diagrama de Containers:** Comunicação entre o `Aplicativo Móvel`, a `API de Backend`, o `Banco de Dados` (PostgreSQL) e o sistema externo `FCM` (Mensageria).
* **Diagrama de Componentes:** Fluxo interno focado no módulo de Turmas e integração com o módulo de Notificações.

<br>

<div align="center">
  <img width="6404" height="3356" alt="US4Componen drawio" src="https://github.com/user-attachments/assets/b347ee03-cadb-43e4-8e0d-bb78c0cde7ff" />
  <br><br>
  <em><b>Figura 4:</b> Rastreabilidade do fluxo de execução da US04.</em>
</div>

<br>

### ⚙️ Passos de Execução (Nível 3)

1. **Requisição:** O `Aplicativo Móvel` envia os dados do novo desafio (título, prazo e pontuação) para o `AuthMiddleware`
2. **Autorização:** O `AuthMiddleware` repassa a requisição (após a validação do token do professor) para o `TurmaController`
3. **Acionamento:** O `TurmaController` encaminha os dados da requisição para o `TurmaService`
4. **Comando de Persistência:** O `TurmaService` envia a entidade do desafio formatada para o `TurmaRepository`
5. **Gravação:** O `TurmaRepository` envia o comando SQL de escrita para o `Banco de Dados` (PostgreSQL)
6. **Acionamento de Alerta (Assíncrono):** Paralelamente à gravação, o `TurmaService` envia os dados do novo desafio para o `NotificationService`
7. **Disparo Externo:** O `NotificationService` despacha a carga útil (payload) do alerta de "Novo Desafio" para o sistema externo `Firebase Cloud Messaging (FCM)`

---

## 🎯 US05: Acessar Relatórios de Desempenho

<blockquote>
  <i>"Como professor, desejo acessar relatórios analíticos de desempenho da turma para monitorar o impacto real das atividades práticas, o engajamento dos estudantes e a evolução pedagógica deles, aplicando filtros por período e por escopo (individual ou geral)."</i>
</blockquote>

### 🔍 Evidência no Modelo C4
* **Diagrama de Containers:** Comunicação entre o `Aplicativo Móvel`, a `API de Backend` e o `Banco de Dados` (PostgreSQL).
* **Diagrama de Componentes:** Fluxo interno passando pela autenticação e pela consulta de dados analíticos no módulo de Turmas.

<br>

<div align="center">
  <img width="100%" style="max-width: 900px; border-radius: 8px;" alt="US5 Fluxo d<img width="6404" height="3356" alt="US5Component drawio" src="https://github.com/user-attachments/assets/71057e81-2df2-4081-929d-1be64ceea43e" />
  <br><br>
  <em><b>Figura 5:</b> Rastreabilidade do fluxo de execução da US05.</em>
</div>

<br>

### ⚙️ Passos de Execução (Nível 3)

1. **Requisição:** O `Aplicativo Móvel` envia os parâmetros de filtro (período e escopo do relatório) para o `AuthMiddleware`.
2. **Autorização:** O `AuthMiddleware` repassa a requisição (após validar o token de permissão do professor) para o `TurmaController`.
3. **Acionamento:** O `TurmaController` encaminha os parâmetros de busca para o `TurmaService` processar a lógica do relatório.
4. **Comando de Busca:** O `TurmaService` envia os critérios de filtragem (consolidação de métricas e evolução) para o `TurmaRepository`.
5. **Consulta SQL:** O `TurmaRepository` envia a instrução de leitura estruturada para o `Banco de Dados` (PostgreSQL) para extrair o histórico de atividades.

---

## 🎯 US06: Configurar Acessibilidade Visual

<blockquote>
  <i>"Enquanto usuário com baixa visão, desejo configurar recursos de acessibilidade visual para facilitar a navegação e o consumo de conteúdo na plataforma."</i>
</blockquote>

### 🔍 Evidência no Modelo C4
* **Diagrama de Containers:** Comunicação entre o `Aplicativo Móvel`, a `API de Backend` e o `Banco de Dados` (PostgreSQL).
* **Diagrama de Componentes:** Fluxo interno passando pela autenticação e pela atualização de dados no módulo de gerenciamento de Usuário/Perfil.

<br>

<div align="center">
  <img width="6404" height="3356" alt="US6Componen drawio" src="https://github.com/user-attachments/assets/f16f9cae-ac09-45e6-ae79-8a5f17c85c57" />
  <br><br>
  <em><b>Figura 6:</b> Rastreabilidade do fluxo de execução da US06.</em>
</div>

<br>

### ⚙️ Passos de Execução (Nível 3)

1. **Atualização de Perfil:** O `Aplicativo Móvel` envia as configurações de acessibilidade (paleta de cores e escala de fonte) através do SDK nativo diretamente para o `Firebase Auth` armazenar como metadados vinculados à conta

---


