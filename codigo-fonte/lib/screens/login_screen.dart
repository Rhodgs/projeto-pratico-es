import 'package:flutter/material.dart';
import 'package:jornada_verde/core/theme/app_colors.dart';
import 'package:jornada_verde/core/utils/api_feedback.dart';
import 'package:jornada_verde/core/widgets/app_logo.dart';
import 'package:jornada_verde/core/widgets/jv_text_field.dart';
import 'package:jornada_verde/screens/register_screen.dart';
import 'package:jornada_verde/screens/student_dashboard_screen.dart';
import 'package:jornada_verde/screens/teacher_dashboard_screen.dart';
import 'package:jornada_verde/services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _api = ApiService.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    await ApiFeedback.execute(
      context: context,
      request: () => _api.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
      successMessage: 'Login realizado com sucesso!',
      onSuccess: (data) {
        final role = data['role'] as String? ?? 'aluno';
        final destination = role == 'professor'
            ? const TeacherDashboardScreen()
            : const StudentDashboardScreen();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => destination),
        );
      },
    );
  }

  Future<void> _forgotPassword() async {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe seu e-mail para recuperar a senha.'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    await ApiFeedback.execute(
      context: context,
      request: () => _api.recuperarSenha(email: _emailController.text.trim()),
      successMessage: 'Link de recuperação enviado para seu e-mail.',
    );
  }

  void _openTerms() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Termos de Uso e Política de Privacidade'),
        content: const SingleChildScrollView(
          child: Text(
            'Ao utilizar o Jornada Verde, você concorda com nossos termos '
            'de uso e política de privacidade.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 32),
            const AppLogo(size: 72),
            const SizedBox(height: 28),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      JvTextField(
                        label: 'Email',
                        controller: _emailController,
                        hint: 'seu@email.com',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      JvTextField(
                        label: 'Senha',
                        controller: _passwordController,
                        hint: '••••••••',
                        icon: Icons.lock_outline,
                        obscureText: _obscurePassword,
                        suffix: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textLight,
                          ),
                          onPressed: () {
                            setState(() => _obscurePassword = !_obscurePassword);
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _forgotPassword,
                          child: const Text(
                            'Esqueci a senha',
                            style: TextStyle(color: AppColors.linkAccent),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text('Entrar'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Não possui uma conta? ',
                            style: TextStyle(color: AppColors.textLight),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute<void>(
                                  builder: (_) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Cadastra-se',
                              style: TextStyle(
                                color: AppColors.linkAccent,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: TextButton(
                onPressed: _openTerms,
                child: Text(
                  'Termos de Uso e Política de Privacidade',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.white.withValues(alpha: 0.95),
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.white.withValues(alpha: 0.95),
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
