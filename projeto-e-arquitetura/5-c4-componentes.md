<h1 align="center">C4 Componentes</h1>

<p align="center">
  Este documento apresenta o Diagrama de Componentes (Nível 3) focado na API de Backend do sistema Jornada Verde. O objetivo é detalhar a estrutura interna do contêiner, identificando seus componentes lógicos de código, suas respectivas responsabilidades e as interações internas e externas.
</p>

## O que é o Diagrama de Componentes e Como Ele é Usado?

> O Diagrama de Componentes (Nível 3) do modelo C4 realiza um "zoom" detalhado em um contêiner específico do sistema. Ele decompõe o contêiner em componentes lógicos de software (como módulos, controladores, serviços e repositórios), explicitando as dependências internas e mapeando a comunicação direta com elementos e serviços que residem fora do contêiner.

Este diagrama é utilizado para:
* Demonstrar como a arquitetura interna do código está organizada e estruturada em camadas de responsabilidade.
* Mapear de forma clara quais componentes tratam a segurança, a lógica de negócio e o acesso aos dados.
* Detalhar o fluxo exato que uma requisição percorre por dentro dos arquivos do sistema desde a sua entrada até a persistência final.
* Servir como o mapa de engenharia de software definitivo para guiar os desenvolvedores na implementação do código-fonte.

---

<div align="center">
  <img width="6728" height="3440" alt="3componentCORRIGIDO drawio" src="https://github.com/user-attachments/assets/b6221e86-b4fb-4cda-9889-83dbce1f28cb" />
  <br>
  <em><b>Figura 1:</b> Diagrama de Componentes (Nível 3) para a API de Backend do Jornada Verde.</em>
</div>

---

## Catálogo de Elementos

### Componentes Internos (API de Backend)

| Elemento | Tipo | Descrição/Tecnologia |
| :--- | :---: | :--- |
| **AuthMiddleware** | Component | Intercepta as requisições do aplicativo móvel, lê o token de acesso no Firebase Auth e identifica os privilégios do usuário (Aluno ou Professor). Desenvolvido em **Node.js / Express Middleware**. |
| **TurmaController** | Component | Recebe as requisições HTTPS vindas do aplicativo móvel associadas ao gerenciamento de turmas acadêmicas. Desenvolvido em **TypeScript / Express Router**. |
| **TurmaService** | Component | Aplica as regras de negócio de turmas: gera o código único de 6 caracteres em caixa alta (ex: AM42XP) e gerencia o arquivamento de históricos por 90 dias. Desenvolvido em **TypeScript Class**. |
| **TurmaRepository** | Component | Executa as operações de escrita e leitura de dados das turmas diretamente no container do Banco de Dados (PostgreSQL). Desenvolvido em **TypeScript / Prisma ORM**. |
| **RankingController** | Component | Recebe as requisições do aplicativo móvel associadas à visualização do Top 50 dos utilizadores e ao estado das ofensivas diárias. Desenvolvido em **TypeScript / Express Router**. |
| **RankingService** | Component | Processa as regras de pontuação, calcula a ordenação dos alunos no ranking e valida a sequência de dias ativos na plataforma. Desenvolvido em **TypeScript Class**. |
| **RankingRepository** | Component | Executa as operações de leitura e escrita rápidas de dados voláteis diretamente no container de Cache/Ranking (Redis). Desenvolvido em **TypeScript / Redis Client**. |
| **NotificationService** | Component | Responsável por estruturar os alertas de novos desafios ou prazos críticos e efetuar as chamadas externas para o Firebase Cloud Messaging (FCM). Desenvolvido em **TypeScript / Firebase Admin SDK**. |

### Elementos Externos ao Contêiner

| Elemento | Tipo | Descrição/Tecnologia |
| :--- | :---: | :--- |
| **Aplicativo Móvel** | Container | Interface principal para alunos e professores interagirem com a plataforma, desenvolvida em **Flutter**. |
| **Banco de Dados** | Container | Armazena os dados de alta integridade do sistema, mapeado em **PostgreSQL**. |
| **Cache/Ranking** | Container | Gerencia dados voláteis de alta velocidade para cálculo do Top 50 e ofensivas em **Redis**. |
| **Firebase Auth** | External System | Serviço de nuvem de terceiros responsável por garantir o login seguro, validar credenciais e armazenar metadados do perfil do usuário (ex: preferências de acessibilidade). |
| **Firebase Cloud Messaging (FCM)** | External System | Serviço externo para gerenciamento e envio de notificações push para os dispositivos móveis. |

---

## Glossário Técnico

Para garantir a total compreensão das tecnologias listadas na arquitetura da API, seguem as definições dos principais conceitos e bibliotecas utilizados:

* **Express Middleware:** O "segurança" da API. Intercepta requisições para validar acessos (como checar tokens) ou alterar dados antes de chegarem ao destino final.
* **Express Router:** O "guarda de trânsito" do sistema. Direciona cada URL acessada (ex: `/turmas`) para o controlador correto.
* **TypeScript Class:** O "molde" de código (baseado em Orientação a Objetos) onde ficam organizadas e encapsuladas as regras de negócio.
* **Prisma ORM:** O "tradutor" de banco de dados. Converte automaticamente o código TypeScript em comandos SQL, dispensando a escrita manual de *queries*.
* **Redis Client / IORedis:** A biblioteca que faz a ponte de conexão ultra veloz entre o Node.js e o banco de dados em memória Redis.
* **SDK (Software Development Kit):** O "kit de ferramentas" oficial (ex: da Google) com códigos prontos para facilitar a integração com serviços externos, como o Firebase.

---

## Relações e Protocolos

Esta seção mapeia os fluxos e as mensagens trafegadas através dos relacionamentos internos e externos da API de Backend.

* **Aplicativo Móvel → AuthMiddleware `[HTTPS / JSON]`:** Faz requisições HTTPS portando Token de acesso do usuário.
* **Aplicativo Móvel → Firebase Auth `[HTTPS / SDK]`:** Comunica-se diretamente via SDK nativo para realizar autenticação e gerenciar metadados da conta do usuário.
* **AuthMiddleware → Firebase Auth `[HTTPS]`:** Efetua a chamada externa para validação do token de acesso recebido.
* **AuthMiddleware → TurmaController:** Repassa a requisição devidamente validada e autorizada de um perfil do tipo Professor.
* **AuthMiddleware → RankingController:** Repassa a requisição autorizada para leitura de dados de engajamento do usuário.
* **TurmaController → TurmaService:** Transmite os parâmetros recebidos e chama as regras de criação da nova turma.
* **TurmaService → TurmaRepository:** Solicita a persistência dos dados estruturados da turma após a validação das regras.
* **TurmaService → NotificationService:** Dispara internamente um evento informando a criação de uma turma ou desafio para os estudantes.
* **TurmaRepository → Banco de Dados (PostgreSQL) `[SQL]`:** Executa comandos estruturados de inserção (INSERT) ou consulta das turmas.
* **NotificationService → Firebase Cloud Messaging (FCM) `[HTTPS / JSON]`:** Envia o payload estruturado contendo a notificação push via protocolo seguro HTTPS.
* **RankingController → RankingService:** Aciona a lógica de negócio associada ao cálculo de pontuações e listagem do Top 50.
* **RankingService → RankingRepository:** Solicita a busca ou atualização dos dados voláteis de progresso dos alunos.
* **RankingRepository → Cache/Ranking (Redis) `[Em Memória]`:** Consulta e atualiza as chaves binárias em memória RAM para leitura ultra veloz.
