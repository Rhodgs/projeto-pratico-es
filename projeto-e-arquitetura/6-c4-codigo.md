<h1 align="center">C4 Código</h1>

<p align="center">
  Este documento apresenta o Diagrama de Código (Nível 4) focado na estrutura de classes e modelo de domínio do sistema Jornada Verde. O objetivo é detalhar a organização interna do código, identificando as principais entidades, seus atributos, métodos e regras de encapsulamento e relacionamento.
</p>

## O que é o Diagrama de Código e Como Ele é Usado?

> O Diagrama de Código (Nível 4) do modelo C4 fornece o nível máximo de detalhamento da arquitetura. Ele mapeia os elementos internos de um contêiner ou componente de software diretamente para construções de código real, detalhando a modelagem orientada a objetos (classes, modificadores de acesso, atributos, métodos e multiplicidades) que estruturam o domínio da aplicação.

Este diagrama é utilizado para:
* Demonstrar como os conceitos de negócio estão mapeados em entidades programáticas estruturadas.
* Mapear de forma clara os modificadores de acesso, atributos essenciais e assinaturas de métodos.
* Guiar diretamente os desenvolvedores na implementação das classes de modelo e lógica interna da API.
* Servir como documentação viva do padrão de arquitetura orientada a objetos (POO) adotado no projeto.

---

<div align="center">
  <img width="1000" alt="c4-codigo" src="https://github.com/user-attachments/assets/4cd5c498-eb12-4cb1-b98e-537bcf992920" />
  <br>
  <em><b>Figura 1:</b> Diagrama de Código (Nível 4) focado nas Entidades de Domínio da Jornada Verde.</em>
</div>

---

## Catálogo de Elementos

### Classes e Entidades de Domínio

| Elemento | Tipo | Descrição/Comportamento |
| :--- | :---: | :--- |
| **Usuario** | Abstract Class | Classe abstrata que serve como base para todos os usuários do sistema. Centraliza dados de autenticação e perfil. |
| **Estudante** | Class | Especialização de `Usuario`. Representa o aluno na plataforma, gerenciando sua pontuação de XP, ofensivas e envios de tarefas. |
| **Professor** | Class | Especialização de `Usuario`. Representa o educador (Super-Usuário), responsável por gerenciar turmas, desafios e avaliações. |
| **ConfiguracaoAcessibilidade** | Class | Armazena e aplica as preferências de usabilidade visual do usuário, como modo de contraste, escala de fonte e leitor de tela. |
| **ConteudoEducativo** | Class | Representa os materiais de estudo em vídeo, fornecendo controles de reprodução e suporte a recursos de acessibilidade. |
| **Turma** | Class | Espaço de agrupamento acadêmico que vincula alunos a um professor administrador por meio de um código de acesso exclusivo. |
| **Desafio** | Class | Atividade ou missão lançada em uma turma, associada a uma recompensa em XP e controle rígido de prazos. |
| **Evidencia** | Class | Arquivo ou mídia enviada por um estudante para comprovar a realização e conclusão de um desafio específico. |
| **Notificacao** | Class | Estrutura de mensagens e alertas de sistema (push notifications) disparados para engajamento dos usuários. |
| **Selo de conquista** | Class | Recompensas e medalhas digitais atribuídas a estudantes por mérito acadêmico ou cumprimento de metas. |

---

## Glossário Técnico

Para garantir a total compreensão dos conceitos de Orientação a Objetos aplicados no diagrama, seguem as definições estruturais:

* **Classe Abstrata (Abstract Class):** Uma classe que não pode ser instanciada diretamente. Serve exclusivamente como modelo (esqueleto) para que outras classes herdem seus atributos e métodos.
* **Modificadores de Acesso (- / +):** Definem a visibilidade dos membros da classe. O sinal de menos (`-`) indica atributos **privados** (protegidos por encapsulamento), enquanto o sinal de mais (`+`) indica métodos **públicos** acessíveis por outros componentes.
* **Herança (<\|--):** Mecanismo que permite a uma classe (filha) estender o comportamento e a estrutura de outra classe (pai), promovendo o reaproveitamento de código.
* **Associação e Multiplicidade:** Indica a quantidade de instâncias de uma classe que podem se relacionar com uma única instância de outra classe (ex: `1..*` significa de um a muitos, `0..10` impõe um limite numérico restrito).

---

## Relações e Protocolos

Esta seção mapeia a conectividade estrutural e as regras de multiplicidade configuradas no diagrama de classes.

* **Usuario <\|-- Estudante / Professor:** Relacionamento de herança. Tanto `Estudante` quanto `Professor` herdam os atributos base (`id`, `nome`, `email`, `firebaseAuthToken`) e métodos de `Usuario`.
* **Usuario → ConfiguracaoAcessibilidade `[1 para 1]`:** Cada conta de usuário possui exatamente uma instância vinculada para gerenciamento do layout acessível.
* **Usuario → ConteudoEducativo `[Muitos para Muitos]`:** Usuários interagem e consomem múltiplos vídeos e conteúdos didáticos mapeados na base.
* **Professor → Turma `[1 para Muitos]`:** Um educador pode abrir e administrar diversas turmas, mas cada turma responde a um único professor.
* **Turma → Estudante `[1..* para 0..10]`:** Uma turma exige no mínimo um aluno ativo para existir e um estudante pode estar matriculado em até 10 turmas simultâneas.
* **Turma → Desafio `[1 para 1..*]`:** Uma turma centraliza o lançamento de um ou mais desafios acadêmicos ao longo do período.
* **Desafio → Evidencia `[1 para Muitos]`:** Um desafio recebe múltiplas submissões de evidências encaminhadas pelos alunos daquela turma.
* **Estudante → Evidencia `[1 para Muitos]`:** O aluno cria e gerencia o histórico de envio de suas próprias evidências.
* **Desafio → Notificacao `[1 para Muitos]`:** O ciclo de vida de um desafio dispara alertas e notificações push estruturadas para a base de usuários.
* **Estudante → Notificacao `[1 para Muitos]`:** O estudante acumula um painel de notificações pendentes e recebidas do sistema.
* **Estudante → Selo de conquista `[Muitos para Muitos]`:** Alunos acumulam e exibem múltiplos selos digitais obtidos por mérito em seus perfis.
