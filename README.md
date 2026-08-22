# 🌿 Jornada Verde

<div align="center">
  <img src="https://github.com/user-attachments/assets/36cf6e78-2263-405e-a017-cc993c0e26c3" alt="Símbolo Play Verde" width="200" />
  <p><i>Transformando a conscientização ambiental em uma jornada interativa e gamificada.</i></p>
</div>

---

## 📌 Sobre o Projeto

O **Jornada Verde** é uma plataforma mobile desenvolvida para a disciplina de Engenharia de Software I (UFAM/ICET). O objetivo é converter a teoria ambiental em práticas engajadoras para jovens, conectando a consciência ecológica ao universo tecnológico através de missões reais e recompensas digitais.

### 🚀 Funcionalidades Principais
* **Gamificação de Impacto:** Sistema de XP, medalhas e rankings para incentivar hábitos sustentáveis.
* **Registro de Missões:** Validação de ações ecológicas através de fotos e geolocalização.
* **Módulo do Professor:** Criação de turmas e acompanhamento analítico do impacto ambiental gerado pelos alunos 442-449, 479-483].
* **Design Inclusivo:** Interface otimizada com suporte a alto contraste e leitores de tela para plena acessibilidade 452-463].

---

### 💡Inovação

* Uso através de lincenças, tendo foco principal em ser uma ferramenta de ensino inovador para a área de educação sobre conscientização ambiental

---

## 📂 Estrutura do Repositório

O projeto segue a organização de diretórios exigida pelas especificações :

* **`/especificacao`**: IP1: Documentação técnica de design thinking:
* **`/projeto-e-arquitetura`** IP2: Documentação da Arquitetura do Software: 

## 🛠️ Execução Local do Backend

### Pré-requisitos

Instale o [Docker Desktop](https://www.docker.com/products/docker-desktop/) e o Node.js com npm.

### Configuração e execução

1. Entre na pasta do backend:

  ```bash
  cd backend
  ```

2. Crie o arquivo local de ambiente a partir do exemplo:

  ```bash
  copy .env.example .env
  ```

  No Linux ou macOS, use `cp .env.example .env`. Ajuste os valores do `.env` conforme necessário.

3. Inicie os serviços do Docker:

  ```bash
  docker compose up -d
  ```

4. Instale as dependências do backend:

  ```bash
  npm install
  ```

5. Execute as migrações do Prisma:

  ```bash
  npx prisma migrate dev
  ```

6. Inicie o servidor em modo de desenvolvimento:

  ```bash
  npm run dev
  ```

O backend ficará disponível em `http://localhost:3000`.

---

## 📈 Gestão e Relatórios (Notion)
* **IP1**
  * [**Link: Sessão de Ideação**]([COLE_AQUI_O_LINK_DO_NOTION]) - Registro do brainstorming da equipe.
  * [**Link: Daily Scrum**]([COLE_AQUI_O_LINK_DO_NOTION]) - Relatório semanal de progresso e impedimentos.

---

## 👥 Equipe e Matrícula

| Nome Completo | Matrícula |
| :--- | :--- | 
| Rhuan Lucas Cunha Rodrigues | 22552289 |
| Pâmela Asmin de Almeida da Silva | 22551474 |
| Letícia Samara Paz da Silva | 22552722 |
| Thamires Mendes | 22552723 | 

---

## 🤖 Declaração de Uso de Inteligência Artificial

Em conformidade com as boas práticas de transparência e integridade acadêmica, os autores declaram que ferramentas de Inteligência Artificial Generativa (como o Google Gemini) foram utilizadas como assistentes durante o desenvolvimento do projeto **Jornada Verde**.

* **Estruturação de Texto e Markdown:** Auxílio na escrita, formatação e organização de textos na linguagem Markdown.
* **Argumentação e Ideação:** Apoio na fundamentação de ideias, discussões conceituais e refinamento de argumentos.
* **Geração de Imagens:** Utilização de ferramentas de IA para a confecção de elementos visuais.
* **Texto e Documentação:** Auxílio na escrita, estruturação e revisão textual.


Ressaltamos que a idealização do sistema, a definição das regras de negócio, a aprovação do design arquitetural e a validação técnica de todos os artefatos gerados foram realizadas exclusivamente e de forma autoral pela equipe de desenvolvimento. A IA atuou estritamente como uma ferramenta de apoio à produtividade, não sendo autora primária de nenhuma funcionalidade crítica, decisão de negócio ou código-fonte não revisado.

---

## 📝 Licença
Este projeto foi desenvolvido para fins estritamente acadêmicos na **Universidade Federal do Amazonas (UFAM - ICET)**.

---
<div align="center">
  <b>Engenharia de Software I - Prof. Dr. Andrey Rodrigues</b>
</div>
