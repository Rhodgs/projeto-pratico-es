<h1 align="center">Stack Tecnológica e Ferramentas</h1>

<p align="center">
  Este documento detalha as decisões arquiteturais e as tecnologias adotadas no desenvolvimento do sistema Jornada Verde. O objetivo é apresentar o propósito de cada ferramenta e como elas se integram para atender aos requisitos pedagógicos e de gamificação do projeto
</p>

---

<div align="center">
  <img width="1600" height="764" alt="imagem 2" src="https://github.com/user-attachments/assets/94fc63a7-62ff-45a8-b54d-cb654effbe62" />
  <br>
  <em><b>Figura 1:</b> Mapeamento da Stack Tecnológica, ilustrando como as linguagens, os bancos de dados e as ferramentas de apoio se integram nas camadas do sistema Jornada Verde</em>
</div>

### 1. Frontend: Flutter

* **O que é:** Um framework de interface de usuário (UI) criado pelo Google para o desenvolvimento de aplicativos nativos multiplataforma
* **Aplicação no Jornada Verde:** * Criação de uma interface reativa e centrada na experiência do usuário
  * Renderização fluida dos dashboards de progresso (barras de experiência e cards do ranking)
  * Permite que os componentes reajam instantaneamente aos eventos de gamificação sem a necessidade de recarregar o app

---

### 2. Backend: Node.js com TypeScript

* **O que é:** O Node.js é um ambiente de execução JavaScript no servidor, e o TypeScript adiciona tipagem estática ao código
* **Aplicação no Jornada Verde:** * Atua como o "cérebro" do sistema, processando regras de gamificação e validando ações
  * Alta eficiência com operações assíncronas, disparando mensagens via Pub/Sub sem travar o aplicativo
  * O TypeScript garante uma camada de segurança, reduzindo erros e facilitando a manutenção das regras pedagógicas

---

### 3. Banco de Dados Relacional: PostgreSQL

* **O que é:** Um sistema de gerenciamento de banco de dados relacional (SGBD) robusto e de código aberto
* **Aplicação no Jornada Verde:** * Camada de persistência para dados estruturados de alta integridade
  * Gerencia informações críticas como perfis de alunos, turmas dos professores e registro oficial de conquistas
  * Garante que a vitrine de troféus e os selos fiquem armazenados com segurança e exclusividade

---

### 4. Banco de Dados em Memória: Redis

* **O que é:** Um armazenamento de estrutura de dados em memória, amplamente utilizado como banco de dados de alta velocidade e cache
* **Aplicação no Jornada Verde:** * Peça-chave para a interatividade em tempo real da plataforma
  * Gerencia a lógica das "ofensivas" diárias (sequência de dias ativos) e o recálculo imediato do ranking
  * Permite a atualização instantânea do Top 50 sem sobrecarregar a leitura do banco de dados principal

---

### 5. Localização: Google Maps API

* **O que é:** Uma plataforma externa que oferece serviços avançados de mapeamento e geocodificação
* **Aplicação no Jornada Verde:** * Permite filtrar e localizar unidades de preservação da água e postos de coleta seletiva
  * Atua como o elo central na conexão entre o aprendizado digital no app e a ação prática do estudante no mundo real

---

### 6. Autenticação e Notificações: Firebase (Auth & FCM)

* **O que é:** Ecossistema de nuvem do Google que fornece serviços consolidados de backend, incluindo login seguro e mensageria push
* **Aplicação no Jornada Verde:** * O Firebase Auth garante proteção total aos dados sensíveis e credenciais de alunos e professores
  * O Firebase Cloud Messaging (FCM) é o executor do padrão Pub/Sub do sistema
  * Dispara alertas assíncronos de "prazo crítico" e lembretes diários para manter o engajamento e a ofensiva

---
### 7. Design e Prototipagem: Figma

* **O que é:** Uma ferramenta de design de interface de usuário (UI) e prototipagem colaborativa baseada em nuvem.
* **Aplicação no Jornada Verde:** * Utilizado para desenhar a identidade visual do aplicativo, projetar a experiência do usuário (UX) e validar o fluxo de telas de gamificação antes do desenvolvimento.
* Serve como guia visual exato para a programação dos componentes reativos no Flutter.

---
### 8. Ambiente de Desenvolvimento: VS Code (Visual Studio Code)

* **O que é:** Um editor de código-fonte leve, altamente extensível e desenvolvido pela Microsoft, amplamente utilizado no desenvolvimento de software moderno.
* **Aplicação no Jornada Verde:** * O ambiente central de desenvolvimento (IDE) onde todo o código do projeto é escrito e editado.
* Utiliza extensões específicas para agilizar a codificação e depuração tanto do frontend em Flutter (Dart) quanto do backend em Node.js com TypeScript.

---
### 9. Controle de Versão e Colaboração: GitHub (Online)

* **O que é:** Uma plataforma de hospedagem de código-fonte e arquivos em nuvem que utiliza o sistema de controle de versão Git.
* **Aplicação no Jornada Verde:** * Funciona como o repositório central e oficial de todo o código do sistema.
*  Permite o trabalho colaborativo da equipe, o gerenciamento de versões, a revisão de código (Pull Requests) e o acompanhamento de *melhorias ou correções de bugs.

---
### 10. Gerenciamento Local de Repositórios: GitHub Desktop

* **O que é:** Uma interface gráfica de usuário (GUI) oficial do GitHub que simplifica a interação com repositórios locais e remotos sem a *necessidade de usar a linha de comando.
* **Aplicação no Jornada Verde:** * Utilizado localmente na máquina dos desenvolvedores para facilitar o envio de alterações de código
(commits e pushes) e a sincronização com o repositório online de forma visual e intuitiva

---
### 11. Gestão de Conhecimento e Documentação: Notion

* **O que é:** Um espaço de trabalho completo (workspace) em nuvem que combina notas, documentos, quadros Kanban e gerenciamento de bancos de dados textuais.
* **Aplicação no Jornada Verde:** * Centraliza toda a documentação de engenharia de software do projeto, incluindo o levantamento de requisitos, a especificação das regras de gamificação, o dicionário de dados e as atas de reuniões do grupo.


## Catálogo de Padrões Arquiteturais

A tabela a seguir detalha os padrões de arquitetura de software adotados no ecossistema do sistema, mapeando as tecnologias envolvidas e a justificativa prática para sua utilização

| Padrão / Componente Arquitetural | Tecnologias Envolvidas | Onde e como é utilizado no sistema |
| :--- | :--- | :--- |
| **Cliente-Servidor** | Flutter e Node.js | É o modelo base do projeto, onde o aplicativo móvel (**Flutter**) atua como Cliente realizando requisições e renderizando dashboards reativos, enquanto a API em **Node.js** atua como Servidor centralizando as regras de negócio. |
| **Publicar/Assinar (Pub/Sub)** | Node.js, Firebase Cloud Messaging (FCM) e Flutter | Comunicação assíncrona do sistema. O backend gera eventos (*Publisher*) e o **FCM** atua como o intermediário distribuindo alertas de prazos críticos e lembretes de engajamento para os dispositivos (*Subscribers*). |
| **Arquitetura em Camadas** | Node.js (TypeScript) | Organização interna da API com divisões claras de responsabilidades (Borda, Serviços e Persistência). O **TypeScript** adiciona tipagem estática para reduzir erros de execução e proteger as regras pedagógicas. |
| **API RESTful / REST** | Node.js (Express) | Estilo arquitetural adotado para a comunicação e tráfego de dados estruturados em formato JSON entre o cliente mobile e o servidor via protocolo HTTP seguro. |
| **Padrão de Repositório (Repository Pattern)** | TypeScript, PostgreSQL e Redis | Isola a lógica de persistência de dados. O **PostgreSQL** protege dados de alta integridade (perfis e troféus). O **Redis** trata dados em memória para atualização instantânea do Top 50 e ofensivas sem sobrecarregar o banco principal. |
| **Serviço de Localização Externo** | API do Google Maps | Gateway de integração para geolocalização, permitindo filtrar e mapear unidades de preservação da água e postos de coleta seletiva na ação prática do estudante. |
| **Autenticação e Segurança** | Firebase Auth | Componente de infraestrutura em nuvem acoplado à arquitetura para garantir o controle de acesso seguro e proteção total às credenciais de alunos e professores. |
| **Design, Prototipagem e UX** | Figma | Ferramenta de design em nuvem utilizada para projetar a identidade visual e validar os fluxos das telas de gamificação antes de servirem como guia para a codificação reativa. |
| **Ambiente de Desenvolvimento (IDE)** | VS Code | Ambiente central integrado onde a engenharia de software é consolidada, usando extensões para depuração ágil tanto do frontend quanto do backend. |
| **Controle de Versão e Colaboração** | GitHub (Online) e GitHub Desktop | O **GitHub** centraliza o repositório oficial em nuvem, controle de versões e revisões de código (Pull Requests). O **GitHub Desktop** serve como a interface gráfica local para agilizar commits e pushes. |
| **Gestão de Conhecimento e Documentação** | Notion | Workspace em nuvem que centraliza a documentação técnica do sistema, incluindo o levantamento de requisitos, dicionário de dados e regras do motor de gamificação. |

