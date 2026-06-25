import 'package:flutter/material.dart';
import 'package:jornada_verde/core/theme/app_colors.dart';
import 'package:jornada_verde/core/utils/api_feedback.dart';
import 'package:jornada_verde/screens/teacher_launch_challenge_screen.dart';
import 'package:jornada_verde/screens/teacher_validation_screen.dart';
import 'package:jornada_verde/services/api_service.dart';

class _ActiveClass {
  _ActiveClass({
    required this.id,
    required this.name,
    required this.students,
  });

  final String id;
  final String name;
  final int students;
}

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  final _api = ApiService.instance;

  final List<_ActiveClass> _classes = [
    _ActiveClass(id: '1', name: 'Turma 2º 04', students: 28),
    _ActiveClass(id: '2', name: 'Turma 3º 02', students: 32),
    _ActiveClass(id: '3', name: 'Turma 1º 08', students: 25),
  ];

  void _showCreateClassDialog() {
    final nameController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Nova Turma'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Nome da Turma',
            hintText: 'Ex: Turma 2º 04',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              nameController.dispose();
              Navigator.pop(dialogContext);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final nome = nameController.text.trim();
              nameController.dispose();
              Navigator.pop(dialogContext);

              if (nome.isEmpty) return;

              await ApiFeedback.execute(
                context: context,
                request: () => _api.criarTurma(nome: nome),
                successMessage: 'Turma criada com sucesso!',
                onSuccess: (data) {
                  setState(() {
                    _classes.add(
                      _ActiveClass(
                        id: data['id']?.toString() ??
                            DateTime.now().millisecondsSinceEpoch.toString(),
                        name: nome,
                        students: 0,
                      ),
                    );
                  });
                },
              );
            },
            child: const Text('Criar'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteClass(String id) async {
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
          _TeacherHeader(activeClasses: _classes.length),
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
                        onDelete: () => _deleteClass(turma.id),
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
  const _TeacherHeader({required this.activeClasses});

  final int activeClasses;

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
                  _HeaderIconButton(icon: Icons.settings_rounded),
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
              const Text(
                'Olá, Prof. Carlos!',
                style: TextStyle(
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
