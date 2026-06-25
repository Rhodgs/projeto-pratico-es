import 'package:flutter/material.dart';
import 'package:jornada_verde/core/theme/app_colors.dart';
import 'package:jornada_verde/core/utils/api_feedback.dart';
import 'package:jornada_verde/core/widgets/app_logo.dart';
import 'package:jornada_verde/core/widgets/jv_text_field.dart';
import 'package:jornada_verde/screens/login_screen.dart';
import 'package:jornada_verde/screens/student_dashboard_screen.dart';
import 'package:jornada_verde/screens/teacher_dashboard_screen.dart';
import 'package:jornada_verde/services/api_service.dart';

enum UserRole { aluno, professor }

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _api = ApiService.instance;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _classCodeController = TextEditingController();

  UserRole _selectedRole = UserRole.aluno;
  bool _acceptedTerms = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _classCodeController.dispose();
    super.dispose();
  }

  void _openTerms() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Termos de Uso e Política de Privacidade'),
        content: const Text(
          'Leia atentamente nossos termos antes de continuar.',
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

  Future<void> _submit() async {
    final role = _selectedRole == UserRole.aluno ? 'aluno' : 'professor';

    await ApiFeedback.execute(
      context: context,
      request: () => _api.cadastrarUsuario(
        nome: _nameController.text.trim(),
        email: _emailController.text.trim(),
        senha: _passwordController.text,
        role: role,
        codigoTurma: _selectedRole == UserRole.aluno
            ? _classCodeController.text.trim()
            : null,
      ),
      successMessage: 'Cadastro realizado com sucesso!',
      onSuccess: (_) {
        final destination = _selectedRole == UserRole.aluno
            ? const StudentDashboardScreen()
            : const TeacherDashboardScreen();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => destination),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 20),
              child: AppLogo(size: 64, showTagline: true),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    JvTextField(
                      label: 'Nome Completo',
                      controller: _nameController,
                      hint: 'Alex da Cruz',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _RoleChip(
                            label: 'ALUNO',
                            selected: _selectedRole == UserRole.aluno,
                            onTap: () {
                              setState(() => _selectedRole = UserRole.aluno);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _RoleChip(
                            label: 'PROFESSOR',
                            selected: _selectedRole == UserRole.professor,
                            onTap: () {
                              setState(() => _selectedRole = UserRole.professor);
                            },
                          ),
                        ),
                      ],
                    ),
                    if (_selectedRole == UserRole.aluno) ...[
                      const SizedBox(height: 20),
                      JvTextField(
                        label: 'Código da Turma (6 caracteres)',
                        controller: _classCodeController,
                        hint: 'ABC123',
                        icon: Icons.waves_outlined,
                        keyboardType: TextInputType.text,
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _acceptedTerms,
                          activeColor: AppColors.primaryGreen,
                          onChanged: (v) {
                            setState(() => _acceptedTerms = v ?? false);
                          },
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: _openTerms,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    color: AppColors.textDark,
                                    fontSize: 14,
                                    height: 1.4,
                                  ),
                                  children: [
                                    TextSpan(text: 'Li e aceito os '),
                                    TextSpan(
                                      text:
                                          'Termos de Uso e Política de Privacidade',
                                      style: TextStyle(
                                        color: AppColors.linkAccent,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _acceptedTerms ? _submit : null,
                        style: ElevatedButton.styleFrom(
                          disabledBackgroundColor:
                              AppColors.primaryGreen.withValues(alpha: 0.35),
                        ),
                        child: const Text('Cadastrar'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute<void>(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Já tenho uma conta',
                        style: TextStyle(color: AppColors.linkAccent),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  const _RoleChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.mintGreen : AppColors.cardBackground,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: selected ? AppColors.primaryGreen : AppColors.textLight,
              width: selected ? 2 : 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 13,
              letterSpacing: 0.5,
              color: selected ? AppColors.primaryGreen : AppColors.textLight,
            ),
          ),
        ),
      ),
    );
  }
}
