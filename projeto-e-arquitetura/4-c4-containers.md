<h1 align="center">C4 Container </h1>

<p align="center">
  Este documento apresenta o Diagrama de Containers (Nível 2) do sistema Jornada Verde. O objetivo é detalhar as unidades de execução de software, suas tecnologias e como os dados trafegam entre o aplicativo e os serviços de backend
</p>

## O que é o Diagrama de Containers e Como Ele é Usado?

> O Diagrama de Containers (Nível 2) do modelo C4 representa um "zoom" dentro do sistema de software definido no Nível 1 (Contexto). Um "container" no C4 não se refere necessariamente a Docker ou conteinerização física, mas sim a qualquer unidade executável ou de armazenamento de dados que precisa estar rodando para que o sistema funcione como um todo 

Este diagrama é utilizado para:
* Mostrar explicitamente quais frameworks, linguagens e bancos de dados foram escolhidos (ex: Flutter, Node.js, PostgreSQL, Redis)
* Demonstrar onde a lógica de negócio é executada e onde os dados são armazenados ou cacheados
* Indicar como essas unidades conversam entre si, detalhando os protocolos de rede (ex: HTTPS) e formatos de dados (ex: JSON, SQL)
* Servir como o mapa de engenharia principal para que os desenvolvedores saibam como construir e integrar as partes do ecossistema

---

<div align="center">
  <img width="8192" height="5546" alt="containerJV drawio" src="https://github.com/user-attachments/assets/1ad622aa-f9a4-474e-9b9a-d28cb46e03b4" />
  <br>
  <em>*Figura 1: Diagrama de Containers (Nível 2) para o ecossistema Jornada Verde*</em>
</div>


---

## Catálogo de Elementos

| Elemento | Tipo | Descrição/Tecnologia |
| :--- | :---: | :--- |
| **Aplicativo Móvel** | Container (Mobile App) | Interface reativa para alunos e professores desenvolvida em [**Flutter**](https://flutter.dev/) |
| **API de Backend** | Container (API) | Centraliza as regras de negócio e validações em [**Node.js + TypeScript**](https://nodejs.org/learn/typescript/introduction) |
| **Banco de Dados** | Container (Database) | Banco relacional [**PostgreSQL**](https://www.postgresql.org/) para persistência de dados íntegros |
| **Cache/Ranking** | Container (NoSQL) | Banco em memória [**Redis**](https://redis.io/) para cache e cálculo de ranking veloz |
| **Firebase Auth** | External System | Serviço de nuvem de terceiros para [autenticação segura](https://firebase.google.com/docs/auth?hl=pt-br) |
| **Firebase Cloud Messaging (FCM)** | External System | Serviço externo para gerenciamento e envio de [notificações push](https://firebase.google.com/docs/cloud-messaging?hl=pt-br) |
| **Google Maps API** | External System | Serviço externo para fornecimento de [mapas e geolocalização](https://www.google.com/maps) |

---

## Relações e Protocolos

Esta seção descreve a dinâmica de comunicação entre os elementos do ecossistema, mapeando a origem, o destino e as tecnologias de transporte de dados utilizadas nas setas do diagrama.

* **Aluno → Aplicativo Móvel:** Interage com a interface para responder quizzes e ver progresso.
* **Professor → Aplicativo Móvel:** Interage com a interface para gerenciar turmas e lançar desafios.
* **Aplicativo Móvel → API de Backend `[HTTPS / JSON]`:** Envia chaves de acesso, respostas e requisições do app.
* **Aplicativo Móvel → Firebase Auth `[HTTPS]`:** Autentica usuários e valida credenciais de acesso.
* **Aplicativo Móvel → Google Maps API `[HTTPS / JSON]`:** Consome dados de mapas e pontos de reciclagem.
* **API de Backend → Banco de Dados (PostgreSQL) `[SQL]`:** Persiste perfis, dados de turmas e histórico de atividades.
* **API de Backend → Cache/Ranking (Redis) `[Em Memória]`:** Atualiza posições do ranking e armazena ofensivas diárias.
* **API de Backend → Firebase Cloud Messaging (FCM) `[HTTPS / JSON]`:** Publica eventos de novos desafios e prazos críticos.
* **Firebase Cloud Messaging (FCM) → Aplicativo Móvel `[Push Notification]`:** Dispara notificações push de engajamento para o dispositivo.
