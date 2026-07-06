import 'package:flutter/material.dart';
import 'package:jornada_verde/core/theme/app_colors.dart';
import 'package:jornada_verde/core/utils/api_feedback.dart';
import 'package:jornada_verde/screens/teacher_launch_challenge_screen.dart';
import 'package:jornada_verde/screens/teacher_validation_screen.dart';
import 'package:jornada_verde/services/api_service.dart';
import 'package:jornada_verde/screens/accessibility_screen.dart';
import 'package:jornada_verde/services/usuario_session.dart';
import 'package:flutter/services.dart';

class _ActiveClass {
  _ActiveClass({
    required this.id,
    required this.name,
    required this.students,
    required this.codigo,
  });

  final String id;
  final String name;
  final int students;
  final String codigo;
}

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  final _api = ApiService.instance;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carregarPerfil();
      _carregarTurmas();
    });
  }

  String _professorNome = 'Professor';

  Future<void> _carregarPerfil() async {
    // Debug: verifica se o id do usuário está definido na sessão
    print(UsuarioSession.id);
    await ApiFeedback.execute(
      context: context,
      request: _api.buscarPerfil,
      successMessage: 'Perfil carregado com sucesso!',
      onSuccess: (data) {
        final nome = (data['usuario']?['nome'] as String?) ?? 'Professor';
        setState(() {
          _professorNome = nome;
        });
      },
      showSuccessSnackBar: false,
    );
  }

  Future<void> _carregarTurmas() async {
    try {
      final lista = await _api.listarTurmas();
      setState(() {
        _classes.clear();
        for (final t in lista) {
          _classes.add(_ActiveClass(
            id: t['id'].toString(),
            name: t['nome'] as String,
            students: (t['alunos'] as List).length,
            codigo: t['codigo']?.toString() ?? '',
          ));
        }
        _carregando = false;
      });
    } catch (_) {
      setState(() => _carregando = false);
    }
  }

  final List<_ActiveClass> _classes = [];
  bool _carregando = true;

  void _showCreateClassDialog() {
    final screenContext = context; // 👈 linha nova
    // 1. Nossas opções fixas
    final List<String> anos = ['1º Ano', '2º Ano', '3º Ano'];
    final List<String> turmas = ['01', '02', '03', '04', '05'];

    // 2. Variáveis para guardar as seleções
    String? anoSelecionado;
    String? turmaSelecionada;

    showDialog<void>(
      context: context,
      builder: (dialogContext) =>
          StatefulBuilder(// StatefulBuilder é o segredo pro Modal atualizar!
              builder: (context, setStateDialog) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Nova Turma'),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Pro modal não ocupar a tela toda
            children: [
              // --- MENU DO ANO ---
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Ano',
                  border: OutlineInputBorder(),
                ),
                value: anoSelecionado,
                items: anos.map((String ano) {
                  return DropdownMenuItem<String>(
                    value: ano,
                    child: Text(ano),
                  );
                }).toList(),
                onChanged: (String? novoValor) {
                  setStateDialog(() {
                    // Atualiza SÓ o modal
                    anoSelecionado = novoValor;
                  });
                },
              ),
              const SizedBox(height: 16), // Espacinho
              // --- MENU DA TURMA ---
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Turma',
                  border: OutlineInputBorder(),
                ),
                value: turmaSelecionada,
                items: turmas.map((String turma) {
                  return DropdownMenuItem<String>(
                    value: turma,
                    child: Text('Turma $turma'),
                  );
                }).toList(),
                onChanged: (String? novoValor) {
                  setStateDialog(() {
                    turmaSelecionada = novoValor;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext); // Apenas fecha o modal
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Se o cara não selecionou algum dos dois, não deixa criar
                if (anoSelecionado == null || turmaSelecionada == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Por favor, selecione o Ano e a Turma!')),
                  );
                  return;
                }

                // 3. Monta o nome perfeito para o banco de dados
                final nome = '$anoSelecionado - Turma $turmaSelecionada';
                Navigator.pop(dialogContext); // Fecha o modal

                // 4. Chama a API usando a estrutura que a sua equipe já montou
                await ApiFeedback.execute(
                  context: screenContext,
                  request: () => _api.criarTurma(nome: nome),
                  successMessage: 'Turma criada com sucesso!',
                  onSuccess: (data) {
                    setState(() {
                      // Esse setState atualiza a lista de trás (da tela principal)
                      _classes.add(
                        _ActiveClass(
                          id: data['id']?.toString() ??
                              DateTime.now().millisecondsSinceEpoch.toString(),
                          name: nome,
                          students: 0,
                          codigo: data['codigo']?.toString() ?? '',
                        ),
                      );
                    });
                  },
                );
              },
              child: const Text('Criar'),
            ),
          ],
        );
      }),
    );
  }

  Future<void> _deleteClass(String id, String nome) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Excluir Turma'),
        content: Text(
          'Esta ação desvinculará todos os alunos de "$nome". '
          'O histórico será arquivado por 90 dias. Confirmar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmado != true) return;

    await ApiFeedback.execute(
      context: context,
      request: () => _api.excluirTurma(turmaId: id),
      successMessage: 'Turma excluída com sucesso!',
      onSuccess: (_) {
        setState(() => _classes.removeWhere((c) => c.id == id));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      body: Column(
        children: [
          _TeacherHeader(
              activeClasses: _classes.length, professorNome: _professorNome),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const _SectionTitle('TURMAS ATIVAS'),
                  const SizedBox(height: 12),
                  ..._classes.map(
                    (turma) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _ClassCard(
                        turma: turma,
                        onDelete: () => _deleteClass(turma.id, turma.name),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const _SectionTitle('AÇÕES RÁPIDAS'),
                  const SizedBox(height: 12),
                  _ActionCard(
                    icon: Icons.eco_rounded,
                    iconColor: AppColors.primaryGreen,
                    title: 'Lançar Desafio',
                    subtitle: 'Criar um novo desafio para a turma',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const TeacherLaunchChallengeScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  _ActionCard(
                    icon: Icons.image_rounded,
                    iconColor: AppColors.darkGreen,
                    title: 'Validar Evidências',
                    subtitle: '12 pendentes de aprovação',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const TeacherValidationScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateClassDialog,
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.white,
        elevation: 6,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}

class _TeacherHeader extends StatelessWidget {
  const _TeacherHeader(
      {required this.activeClasses, required this.professorNome});

  final int activeClasses;
  final String professorNome;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.headerForestDark, AppColors.headerForestLight],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const AccessibilityScreen(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: const Padding(
                      padding: EdgeInsets.all(6.0),
                      child: _HeaderIconButton(icon: Icons.settings_rounded),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: AppColors.lightGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, color: AppColors.textDark),
                  ),
                ],
              ),
              Text(
                'Bem Vindo, Professor',
                style: TextStyle(
                  color: AppColors.white.withValues(alpha: 0.65),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Olá, $professorNome!',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$activeClasses turmas ativas',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: activeClasses / 5,
                        minHeight: 6,
                        backgroundColor: Colors.white24,
                        color: AppColors.lightGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white24,
      shape: const CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Icon(icon, color: AppColors.white, size: 22),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
        color: AppColors.textLight,
      ),
    );
  }
}

class _ClassCard extends StatelessWidget {
  const _ClassCard({required this.turma, required this.onDelete});

  final _ActiveClass turma;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardBackground,
      borderRadius: BorderRadius.circular(20),
      elevation: 2,
      shadowColor: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.mintGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.groups_rounded,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    turma.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '${turma.students} alunos',
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 13,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Código: ${turma.codigo}',
                        style: const TextStyle(
                          color: AppColors.primaryGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: turma.codigo));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Código copiado!')),
                          );
                        },
                        child: const Icon(
                          Icons.copy,
                          size: 14,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: AppColors.textLight),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardBackground,
      borderRadius: BorderRadius.circular(20),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.textLight,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textLight),
            ],
          ),
        ),
      ),
    );
  }
}
