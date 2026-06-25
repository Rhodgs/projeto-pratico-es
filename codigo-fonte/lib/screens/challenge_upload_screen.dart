import 'package:flutter/material.dart';
import 'package:jornada_verde/core/theme/app_colors.dart';
import 'package:jornada_verde/core/utils/api_feedback.dart';
import 'package:jornada_verde/core/widgets/dashed_border_box.dart';
import 'package:jornada_verde/services/api_service.dart';

class ChallengeUploadScreen extends StatefulWidget {
  const ChallengeUploadScreen({super.key});

  @override
  State<ChallengeUploadScreen> createState() => _ChallengeUploadScreenState();
}

class _ChallengeUploadScreenState extends State<ChallengeUploadScreen> {
  static const _desafioId = 'coleta-plastico';
  final _api = ApiService.instance;

  Future<void> _anexarEvidencia() async {
    await ApiFeedback.execute(
      context: context,
      request: () => _api.anexarEvidencia(
        desafioId: _desafioId,
        arquivoNome: 'evidencia_${DateTime.now().millisecondsSinceEpoch}.jpg',
      ),
      successMessage: 'Evidência enviada com sucesso!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF4F7F6), // Fundo cinza bem clarinho igual a foto
      appBar: AppBar(
        backgroundColor: Colors.blue.shade500,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Column(
          children: [
            Text(
              'Herói da Reciclagem',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
            Icon(Icons.recycling, size: 20, color: Colors.white70),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. CARDS DE STATUS (XP, Prazo, Participantes)
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    color: Colors.yellow.shade50,
                    icon: Icons.star,
                    iconColor: Colors.amber,
                    value: '+150 XP',
                    label: 'Recompensa',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    color: Colors.blue.shade50,
                    icon: Icons.timer_outlined,
                    iconColor: Colors.blue,
                    value: '7 dias',
                    label: 'Prazo',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    color: Colors.purple.shade50,
                    icon: Icons.groups,
                    iconColor: Colors.purple.shade300,
                    value: '142',
                    label: 'Participantes',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 2. CARD DE PROGRESSO
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10),
                ],
              ),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progresso',
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 16),
                      ),
                      Text(
                        '60%',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: const LinearProgressIndicator(
                      value: 0.6,
                      minHeight: 8,
                      backgroundColor: Color(0xFFEEEEEE),
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. CARD DE INSTRUÇÕES
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sobre o Desafio',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Separe 10 itens recicláveis esta semana',
                    style: TextStyle(color: AppColors.textDark, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Como participar:',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  _ChecklistItem('1. Realize a ação descrita no desafio'),
                  _ChecklistItem('2. Tire uma foto como evidência'),
                  _ChecklistItem('3. Envie a foto usando o botão abaixo'),
                  _ChecklistItem('4. Aguarde a validação e receba seu XP!'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 4. CARD DE ENVIAR EVIDÊNCIA
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enviar Evidência',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Envie uma foto provando que você completou o desafio.',
                    style: TextStyle(color: AppColors.textLight, fontSize: 13),
                  ),
                  const SizedBox(height: 16),

                  // CAIXA PONTILHADA
                  Material(
                    color: const Color(0xFFF9F9F9),
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      onTap: _anexarEvidencia,
                      borderRadius: BorderRadius.circular(16),
                      child: DashedBorderBox(
                        radius: 16,
                        color: Colors.grey.shade400,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: const Column(
                            children: [
                              Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.blue,
                                size: 36,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Toque para adicionar foto',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'JPG, PNG • máx 10MB',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
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
            ),
            const SizedBox(height: 24),

            // BOTÃO FINAL AZUL
            SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _anexarEvidencia,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade500,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.camera_alt, size: 20),
                label: const Text(
                  'Enviar Evidência Fotográfica',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// Widget auxiliar para os cards do topo (XP, Prazo, Participantes)
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.color,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final Color color;
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.black54, fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Widget auxiliar para a lista com certinho verde
class _ChecklistItem extends StatelessWidget {
  const _ChecklistItem(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: AppColors.textDark, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
