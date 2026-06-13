# Escolha de Padrões Arquiteturais: Jornada Verde
Para o sistema Jornada Verde, a solução ideal é combinar o padrão de Arquitetura em Camadas com o padrão Publisher/Subscriber (Pub/Sub).

## 1. 📝Descrição dos Padrões

* **Arquitetura em Camadas**: Organiza o sistema em níveis independentes (Apresentação, Negócio e Persistência), onde cada camada tem uma responsabilidade específica e se comunica apenas com a camada imediatamente inferior. 

* **Publisher/Subscriber (Pub/Sub)**: É um padrão de mensagens assíncronas onde os "publicadores" de mensagens não as enviam diretamente para "assinantes" específicos. Em vez disso, as mensagens são publicadas em tópicos, e os interessados as recebem conforme a necessidade.

<div align="center">
  <img width="1536" height="815" alt="imagem 1" src="https://github.com/user-attachments/assets/2a530e93-b274-41c6-8a55-121faa2461b7" />
  <br>
  <em><b>Figura 1:</b> Representação visual da Arquitetura em Camadas integrada ao barramento de eventos assíncronos (Pub/Sub) do Jornada Verde.</em>
</div>

---

## 2. 🔍Justificativa da Escolha

* **Escalabilidade e Manutenção**: A separação em camadas facilita a manutenção do código, permitindo que alterações na interface (Flutter) não afetem diretamente as regras de negócio da gamificação.
  
* **Feedback em Tempo Real**: O uso do padrão Pub/Sub no Jornada Verde justifica-se pela necessidade de um sistema altamente interativo e voltado para o engajamento. Como o sistema lida com rankings de turmas e notificações de prazos  (como o lembrete de 1 dia para acabar a atividade ou a manutenção da 'ofensiva' diária), o Pub/Sub permite que esses eventos ocorram de forma assíncrona.
  
* **Performance**: Isso evita que a interface do usuário (Flutter) trave enquanto o servidor processa as regras de gamificação e dispara mensagens para centenas de alunos simultaneamente.
  
* **Desacoplamento**: Permite que o serviço de badges funcione de forma independente do sistema de login ou do feed de conteúdos ambientais. 

---

## 3. 💻Aplicação no Sistema


### Exemplos de Aplicação da Camada de Apresentação

A camada de apresentação do sistema **Jornada Verde** é construída utilizando o framework [**`Flutter`**](https://flutter.dev/) o que permite uma interface reativa e centrada na experiência do usuário. 

*   **Responsabilidade:** Traduzir as intenções dos alunos e professores em ações dentro do sistema.
  
*   **Visão do Aluno:** No dashboard principal, o aluno visualiza o seu progresso através de uma barra de experiência e um card dinâmico que exibe a sua posição na comunidade, extraindo esses dados diretamente do serviço de ranking.

*   **Central de Aprendizagem:** A interface organiza conteúdos educativos em formatos de cards interativos para vídeos e artigos, permitindo que o usuário filtre materiais por categorias específicas como reciclagem ou preservação da água.
  
*   **Visão do Docente:** Oferece um painel de controle administrativo onde é possível gerenciar turmas e monitorar métricas de desempenho coletivo através de indicadores visuais. 

> **Destaque:** Um ponto crucial desta camada é a gestão do **perfil privado** (vitrine de troféus). Todo o feedback visual ocorre de forma imediata por meio de componentes que **reagem aos eventos processados pelo backend**, mantendo o engajamento sem a necessidade de recarregar o aplicativo.

---

### Exemplos de Aplicação da Camada de Negócio

Esta camada funciona como o **"cérebro" do sistema**, processando as regras de gamificação e validando se as ações do utilizador cumprem os requisitos para ganhar selos ou subir de nível. 

*   **Lógica de Gamificação:** Gere a lógica da "ofensiva" diária e assegura que, embora o ranking seja público, a vitrine de broches permaneça privada. 
*   **Validação:** Além de validar quizzes e atividades, a camada de negócio é a **origem dos eventos** que alimentam o sistema.
*   **Comunicação:** Publica atualizações no **barramento de mensagens** sempre que um objetivo é atingido. 

> **Benefício Arquitetural:** Essa organização permite que as regras pedagógicas evoluam de forma isolada, **sem afetar a interface ou o armazenamento de dados**, garantindo o desacoplamento do sistema.

---

## 4. 📄Exemplos de Aplicação do Padrão Publisher/Subscriber (Pub/Sub)

Abaixo estão os cenários do sistema Jornada Verde onde o padrão Pub/Sub é aplicado para garantir o desacoplamento e a reatividade:

---

### 4.1 Publicação de Nova Atividade
* **Cenário**: O professor disponibiliza um novo desafio ambiental para a turma.
* **Publicador**: Módulo de Gestão de Conteúdo (Painel do Professor).
* **Tópico**: `atividade.nova_postada`.
* **Mensagem (Payload)**: ID da atividade, prazo de entrega, descrição e recompensa (pontos/broches).
* **Assinantes & Ações**:
    * **Serviço de Notificação**: Dispara push notification para os alunos: "Uma nova jornada ambiental começou! Confira a atividade $X^{n}$".
    * **Serviço de Analytics**: Registra a criação da oportunidade para métricas de engajamento da turma.
 
---

### 4.2 Lembrete de Prazo Crítico
* **Cenário**: Alerta automático quando falta apenas 1 dia para o encerramento de uma atividade.
* **Publicador**: Serviço de Agendamento (Worker/Cron Job).
* **Tópico**: `atividade.prazo_urgente`.
* **Mensagem (Payload)**: Lista de IDs de alunos pendentes e nome da tarefa.
* **Assinantes & Ações**:
    * **Serviço de Notificação**: Envia alerta personalizado para o dispositivo do aluno.
    * **Serviço de Gamificação**: Envia mensagem de incentivo: "Você está prestes a perder os 50 pontos de 'Protetor da Fauna' desta atividade. Conclua agora!".

---

### 4.3 Manutenção da "Ofensiva" (Engajamento Diário)
* **Cenário**: Garantir que o aluno mantenha sua sequência de dias ativos (estilo Duolingo).
* **Publicador**: Serviço de Monitoramento de Presença.
* **Tópico**: `usuario.alerta_ofensiva`.
* **Mensagem (Payload)**: ID do usuário e status atual da sequência (ex: 3 dias).
* **Assinantes & Ações**:
    * **Serviço de Notificação**: Dispara lembrete: "Sua sequência de preservação está em perigo! Entre agora para garantir seu progresso".
    * **Módulo de Perfil**: Atualiza o status interno. Caso o acesso não ocorra, publica no tópico `ofensiva.resetada` para atualizar o ícone no perfil privado do aluno.

---

### 4.4 Divulgação de Novos Conteúdos Educativos
* **Cenário**: Inclusão de novos vídeos ou artigos na seção "Aprender".
* **Publicador**: Módulo de Conteúdo.
* **Tópico**: `conteudo.novo`.
* **Mensagem (Payload)**: Tipo de mídia, categoria (ex: Reciclagem) e link.
* **Assinantes & Ações**:
    * **Serviço de Notificações (FCM)**: Filtra alunos com interesse no tema e envia: "Novo vídeo disponível! Aprenda a fazer brinquedos com garrafa pet".

---

### 4.5 Atualização de Ranking e Comunidade
* **Cenário**: Recálculo imediato das posições após a conclusão de atividades.
* **Publicador**: Módulo de Gamificação.
* **Tópico**: `pontuacao.atualizada`.
* **Mensagem (Payload)**: ID do aluno, pontos ganhos e ID da turma.
* **Assinantes & Ações**:
    * **Serviço de Ranking**: Recebe os dados e processa a nova classificação da turma em tempo real.
    * **Interface do Usuário (Frontend)**: Atualiza a tela "Minha Comunidade", refletindo a nova posição do aluno no ranking global ou de grupo.

---
