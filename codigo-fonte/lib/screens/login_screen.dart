// Importa a biblioteca principal do Flutter que contém os componentes visuais padrão (Material Design)
import 'package:flutter/material.dart';

// Define a tela de Login. Ela herda de "StatefulWidget", o que significa 
// que esta tela possui informações (estado) que podem mudar ao longo do tempo 
// (como mostrar/ocultar a senha ou exibir uma rodinha de carregamento).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// Esta é a classe que gerencia o "Estado" da tela de Login.
class _LoginScreenState extends State<LoginScreen> {
  // Chave global usada para identificar o formulário e disparar a validação dos campos.
  final _formKey = GlobalKey<FormState>();
  // Controladores que capturam o texto que o usuário digita nos campos.
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // Variáveis de estado: controlam a exibição da senha e o botão de carregamento.
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    // O método dispose é chamado quando a tela é destruída/fechada.
    // É obrigatório limpar os controladores da memória para evitar travamentos.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Função assíncrona (async) que executa a lógica de login.
  void _login() async {
    // Valida o formulário. Se todos os 'validators' retornarem null, o form é válido.
    if (_formKey.currentState!.validate()) {
      // Atualiza a tela (setState) para mostrar a rodinha de carregamento.
      setState(() => _isLoading = true);
      // Simula uma espera de 1.2 segundos (como se estivesse acessando uma API no backend).
      await Future.delayed(const Duration(milliseconds: 1200));
      // "mounted" verifica se a tela ainda existe antes de tentar alterá-la ou navegar.
      if (mounted) {
        setState(() => _isLoading = false);
        // Troca de tela, jogando o usuário para a rota '/home' (a tela principal do app).
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // O método "build" é onde desenhamos a tela. Ele retorna os componentes visuais (Widgets).
    // Scaffold é a "tela" em si (estrutura básica com fundo branco/cinza).
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F5),
      // SafeArea evita que a interface fique "escondida" pelo entalhe da câmera do celular.
      body: SafeArea(
        // Permite rolar a tela, o que é crucial para não quebrar a tela quando o teclado do celular abrir.
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          // Form agrupa nossos campos de texto e aplica a validação quando a formKey é ativada.
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 48),
                // Cria a Logo desenhando um quadrado (Container) verde escuro e bordas arredondadas.
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D7A3E),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2D7A3E).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.eco_rounded,
                    size: 52,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                // Textos simples exibindo o título e o subtítulo do app.
                const Text(
                  'Jornada Verde',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D7A3E),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Aprenda, aja e transforme o mundo',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 40),
                // Card branco com elevação (sombra) onde ficam os campos de digitação.
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Entrar',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Bem-vindo(a) de volta!',
                        style: TextStyle(fontSize: 14, color: Color(0xFF888888)),
                      ),
                      const SizedBox(height: 24),
                      // Campo de texto para o E-mail.
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        // Regra de validação: diz se o e-mail está certo ou não.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe o e-mail';
                          }
                          if (!value.contains('@')) {
                            return 'E-mail inválido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Campo de texto para a Senha.
                      TextFormField(
                        controller: _passwordController,
                        // obscureText esconde a senha (transforma em bolinhas) se for 'true'.
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            // Altera o ícone baseado na variável de estado.
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            // Quando clica no olho, inverte a variável e recarrega a tela (setState).
                            onPressed: () {
                              setState(() => _obscurePassword = !_obscurePassword);
                            },
                          ),
                        ),
                        // Regra de validação: exige que a senha tenha no mínimo 6 letras.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe a senha';
                          }
                          if (value.length < 6) {
                            return 'Mínimo de 6 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Esqueci minha senha',
                            style: TextStyle(color: Color(0xFF2D7A3E)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Botão de login ("Entrar")
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          // Se _isLoading for true, o botão é desabilitado (null). Senão, ele roda _login().
                          onPressed: _isLoading ? null : _login,
                          child: _isLoading
                              // Se estiver carregando, mostra o CircularProgressIndicator (rodinha).
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              // Se não, exibe a palavra "Entrar".
                              : const Text('Entrar'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Rodapé com link para se cadastrar (troca de tela).
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Não tem uma conta? ',
                      style: TextStyle(color: Color(0xFF666666)),
                    ),
                    GestureDetector(
                      // Vai para a rota da tela de registro quando clicado.
                      onTap: () => Navigator.pushNamed(context, '/register'),
                      child: const Text(
                        'Cadastre-se',
                        style: TextStyle(
                          color: Color(0xFF2D7A3E),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
