import 'package:flutter/material.dart';
import 'package:jornada_verde/core/theme/app_colors.dart';
import 'package:jornada_verde/core/utils/api_feedback.dart';
import 'package:jornada_verde/services/api_service.dart';

class _PendingEvidence {
  const _PendingEvidence({
    required this.id,
    required this.studentName,
    required this.challengeTitle,
  });

  final String id;
  final String studentName;
  final String challengeTitle;
}

class TeacherValidationScreen extends StatefulWidget {
  const TeacherValidationScreen({super.key});

  @override
  State<TeacherValidationScreen> createState() =>
      _TeacherValidationScreenState();
}

class _TeacherValidationScreenState extends State<TeacherValidationScreen> {
  final _api = ApiService.instance;

  final List<_PendingEvidence> _pending = [
    const _PendingEvidence(
      id: '1',
      studentName: 'Ana Silva',
      challengeTitle: 'Coleta de Plástico',
    ),
    const _PendingEvidence(
      id: '2',
      studentName: 'Bruno Costa',
      challengeTitle: 'Coleta de Plástico',
    ),
    const _PendingEvidence(
      id: '3',
      studentName: 'Carla Dias',
      challengeTitle: 'Horta Comunitária',
    ),
    const _PendingEvidence(
      id: '4',
      studentName: 'Daniel Rocha',
      challengeTitle: 'Economia de Água',
    ),
  ];

  void _remove(String id) => setState(() {
        _pending.removeWhere((e) => e.id == id);
      });

  Future<void> _aprovar(String id) async {
    await ApiFeedback.execute(
      context: context,
      request: () => _api.aprovarEvidencia(id),
      successMessage: 'Evidência aprovada!',
      onSuccess: (_) => _remove(id),
    );
  }

  Future<void> _recusar(String id) async {
    await ApiFeedback.execute(
      context: context,
      request: () => _api.recusarEvidencia(id, ''),
      successMessage: 'Evidência recusada.',
      onSuccess: (_) => _remove(id),
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
              padding: const EdgeInsets.fromLTRB(4, 8, 20, 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: AppColors.white),
                  ),
                  const Expanded(
                    child: Text(
                      'Validar Evidências',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.darkGreen,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_pending.length} pendentes',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                itemCount: _pending.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final evidence = _pending[index];
                  return _EvidenceCard(
                    evidence: evidence,
                    onApprove: () => _aprovar(evidence.id),
                    onReject: () => _recusar(evidence.id),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EvidenceCard extends StatelessWidget {
  const _EvidenceCard({
    required this.evidence,
    required this.onApprove,
    required this.onReject,
  });

  final _PendingEvidence evidence;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 160,
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.mintGreen,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image_outlined,
                    size: 48, color: AppColors.textLight),
                SizedBox(height: 8),
                Text(
                  'Foto de evidência',
                  style: TextStyle(color: AppColors.textLight),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, color: AppColors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    evidence.studentName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    'Desafio: ${evidence.challengeTitle}',
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onApprove,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('Aprovar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReject,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.red,
                      side: const BorderSide(color: AppColors.red, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Recusar',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
