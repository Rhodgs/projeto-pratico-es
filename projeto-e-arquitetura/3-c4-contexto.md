<h1 align="center">C4 Contexto</h1>

<p align="center">
  Este documento apresenta o Diagrama de Contexto (Nível 1) do sistema Jornada Verde. O objetivo é detalhar o escopo global da plataforma, seus atores (usuários) e os sistemas externos com os quais ela se integra, tratando o sistema como uma caixa preta
</p>

## O que é o Diagrama de Contexto e Como Ele é Usado?

> O Diagrama de Contexto (Nível 1) do modelo C4 representa o ponto de partida para entender o ecossistema de um software. Ele define as fronteiras do sistema, mostrando como ele se posiciona no mundo real. Neste nível, os detalhes internos de implementação, frameworks ou bancos de dados são completamente omitidos, focando exclusivamente nas interações de alto nível com pessoas e outros sistemas de software

Este diagrama é utilizado para:
* Mostrar o sistema como uma única unidade centralizada ("caixa preta") sem expor complexidades técnicas
* Identificar claramente quem são os usuários diretos da plataforma (ex: Aluno, Professor) e seus objetivos de negócio
* Mapear os sistemas de terceiros e dependências externas que limitam ou auxiliam o funcionamento do ecossistema
* Servir como uma excelente ferramenta de comunicação visual tanto para desenvolvedores quanto para stakeholders não técnicos

---

<div align="center">
  <img width="8192" height="5546" alt="contexto v2" src="https://github.com/user-attachments/assets/86d1a7de-0318-46e8-9357-5c898e8e11e3" />


  <em>*Figura 1: Diagrama de Contexto (Nível 1) para o ecossistema Jornada Verde*</em>
</div>

---

## Catálogo de Elementos

| Elemento | Tipo | Descrição/Tecnologia |
| :--- | :---: | :--- |
| **Aluno** | Person | Principal usuário, resolve atividades na plataforma |
| **Professor** | Person | Super-Usuário, capaz de administrar turmas com alunos, criar atividades |
| **Jornada Verde** | Software System | Plataforma gamificada de educação ambiental que gerencia missões, turmas, evidências e pontuações |
| **Firebase Auth** | External System | Serviço responsável por garantir o login seguro e validar as credenciais de acesso |
| **Firebase Cloud Messaging (FCM)** | External System | Serviço de mensageria que gerencia e dispara as notificações push para os dispositivos |
| **Google Maps API** | External System | Serviço de geolocalização que fornece mapas para encontrar pontos de reciclagem |

---

## Relações e Protocolos

Esta seção descreve a dinâmica de comunicação entre os elementos do ecossistema, mapeando a origem, o destino e as intenções de negócio das interações de alto nível

* **Aluno → Jornada Verde:** Resolve atividades, acompanha ranking e visualiza conquistas
* **Professor → Jornada Verde:** Administra turmas, cria atividades e recebe tarefas
* **Jornada Verde → Firebase Auth:** Delega autenticação e valida credenciais
* **Jornada Verde → Firebase Cloud Messaging (FCM):** Publica eventos de novos desafios e prazos críticos
* **Jornada Verde → Google Maps API:** Consome mapas e localizações de postos de reciclagem
