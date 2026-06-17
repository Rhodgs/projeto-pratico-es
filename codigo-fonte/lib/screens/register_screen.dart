import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _codigoTurmaController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _acceptedTerms = false;
  bool _isLoading = false;

  String _selectedProfile = 'Aluno';
  final List<String> _perfis = ['Aluno', 'Professor'];

  String? _selectedSerie;
  String? _selectedTurma;

  final List<String> _series = [
    '6º ano',
    '7º ano',
    '8º ano',
    '9º ano',
    '1º ano EM',
    '2º ano EM',
    '3º ano EM',
  ];

  final List<String> _turmas = [
    'Turma A',
    'Turma B',
    'Turma C',
    'Turma D',
    'Turma E',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _codigoTurmaController.dispose();
    super.dispose();
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      if (!_acceptedTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Você precisa aceitar os termos de uso para continuar.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 1400));
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
      ),
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(12),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Selecione $label';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F5),
      appBar: AppBar(
        title: const Text('Criar Conta'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D7A3E).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.eco_rounded, color: Color(0xFF2D7A3E)),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jornada Verde',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D7A3E),
                          ),
                        ),
                        Text(
                          'Comece sua missão hoje',
                          style: TextStyle(fontSize: 12, color: Color(0xFF888888)),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Card principal
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
                        'Dados Pessoais',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D7A3E),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Nome completo',
                          prefixIcon: Icon(Icons.person_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Informe o nome completo';
                          }
                          if (value.trim().split(' ').length < 2) {
                            return 'Informe nome e sobrenome';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe o e-mail';
                          }
                          if (!value.contains('@') || !value.contains('.')) {
                            return 'E-mail inválido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(() => _obscurePassword = !_obscurePassword);
                            },
                          ),
                        ),
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
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirm,
                        decoration: InputDecoration(
                          labelText: 'Confirmar senha',
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirm
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(() => _obscureConfirm = !_obscureConfirm);
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Confirme a senha';
                          }
                          if (value != _passwordController.text) {
                            return 'As senhas não coincidem';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildDropdown(
                        label: 'Tipo de Perfil',
                        value: _selectedProfile,
                        items: _perfis,
                        onChanged: (value) => setState(() => _selectedProfile = value ?? 'Aluno'),
                      ),
                      if (_selectedProfile == 'Aluno') ...[
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _codigoTurmaController,
                          maxLength: 6,
                          textCapitalization: TextCapitalization.characters,
                          decoration: const InputDecoration(
                            labelText: 'Código da Turma (Ex: AM42XP)',
                            prefixIcon: Icon(Icons.group_outlined),
                            counterText: '',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Informe o código da turma';
                            }
                            return null;
                          },
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Card Escola
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
                        'Dados Escolares',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D7A3E),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDropdown(
                        label: 'Série',
                        value: _selectedSerie,
                        items: _series,
                        onChanged: (value) => setState(() => _selectedSerie = value),
                      ),
                      const SizedBox(height: 16),
                      _buildDropdown(
                        label: 'Turma',
                        value: _selectedTurma,
                        items: _turmas,
                        onChanged: (value) => setState(() => _selectedTurma = value),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Termos de uso
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _acceptedTerms
                          ? const Color(0xFF2D7A3E)
                          : const Color(0xFFE0E0E0),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _acceptedTerms,
                          activeColor: const Color(0xFF2D7A3E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          onChanged: (value) {
                            setState(() => _acceptedTerms = value ?? false);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _acceptedTerms = !_acceptedTerms);
                          },
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF444444),
                                height: 1.5,
                              ),
                              children: [
                                TextSpan(text: 'Li e aceito os '),
                                TextSpan(
                                  text: 'Termos de Uso',
                                  style: TextStyle(
                                    color: Color(0xFF2D7A3E),
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                TextSpan(text: ' e a '),
                                TextSpan(
                                  text: 'Política de Privacidade',
                                  style: TextStyle(
                                    color: Color(0xFF2D7A3E),
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                TextSpan(
                                  text: ' do Jornada Verde. (obrigatório)',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text('Criar Conta'),
                  ),
                ),

                const SizedBox(height: 16),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Já tem uma conta? ',
                        style: TextStyle(color: Color(0xFF666666)),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          'Entrar',
                          style: TextStyle(
                            color: Color(0xFF2D7A3E),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
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
