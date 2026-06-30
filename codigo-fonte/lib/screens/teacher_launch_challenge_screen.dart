import 'package:flutter/material.dart';
import 'package:jornada_verde/core/theme/app_colors.dart';
import 'package:jornada_verde/core/utils/api_feedback.dart';
import 'package:jornada_verde/core/widgets/jv_text_field.dart';
import 'package:jornada_verde/services/api_service.dart';

class TeacherLaunchChallengeScreen extends StatefulWidget {
  const TeacherLaunchChallengeScreen({super.key});

  @override
  State<TeacherLaunchChallengeScreen> createState() =>
      _TeacherLaunchChallengeScreenState();
}

class _TeacherLaunchChallengeScreenState
    extends State<TeacherLaunchChallengeScreen> {
  final _api = ApiService.instance;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _deadlineController = TextEditingController();
  DateTime? _selectedDeadline;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primaryGreen),
        ),
        child: child!,
      ),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 23, minute: 59),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primaryGreen),
        ),
        child: child!,
      ),
    );
    if (time == null) return;

    final selectedDeadline = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(() {
      _selectedDeadline = selectedDeadline;
      _deadlineController.text = '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year} '
          '${time.hour.toString().padLeft(2, '0')}:'
          '${time.minute.toString().padLeft(2, '0')}';
    });
  }

  Future<void> _lancarDesafio() async {
    if (_selectedDeadline == null) return;

    await ApiFeedback.execute(
      context: context,
      request: () => _api.lancarDesafio(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        points: 0,
        deadline: _selectedDeadline!,
      ),
      successMessage: 'Desafio lançado com sucesso!',
      onSuccess: (_) {
        if (mounted) Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: AppColors.white),
                  ),
                  const Text(
                    'Lançar Desafio',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      JvTextField(
                        label: 'Título do Desafio',
                        controller: _titleController,
                        hint: 'Ex: Coleta de Plástico',
                        icon: Icons.public_rounded,
                      ),
                      const SizedBox(height: 20),
                      JvTextField(
                        label: 'Descrição',
                        controller: _descriptionController,
                        hint:
                            'Descreva o objetivo e as instruções do desafio...',
                        maxLines: 4,
                      ),
                      const SizedBox(height: 20),
                      JvTextField(
                        label: 'Prazo Limite (Data e Hora)',
                        controller: _deadlineController,
                        hint: 'dd/mm/aaaa --:--',
                        readOnly: true,
                        onTap: _pickDeadline,
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _lancarDesafio,
                          child: const Text('Lançar Desafio para a Turma'),
                        ),
                      ),
                    ],
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
