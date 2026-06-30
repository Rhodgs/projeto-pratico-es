import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jornada_verde/core/theme/app_colors.dart';
import 'package:jornada_verde/core/widgets/dashed_border_box.dart';
import 'package:jornada_verde/screens/student_dashboard_screen.dart';

// ── Tempo total do desafio em segundos (7 dias) ──────────────
const int _prazoTotalSegundos = 7 * 24 * 60 * 60;

class ChallengeUploadScreen extends StatefulWidget {
  const ChallengeUploadScreen({super.key});

  @override
  State<ChallengeUploadScreen> createState() => _ChallengeUploadScreenState();
}

class _ChallengeUploadScreenState extends State<ChallengeUploadScreen> {
  // ── Cronômetro ────────────────────────────────────────────
  late int _segundosRestantes;
  Timer? _timer;

  // ── Toggle de imagem simulada ─────────────────────────────
  bool _imagemAnexada = false;

  @override
  void initState() {
    super.initState();
    _segundosRestantes = _prazoTotalSegundos;
    _iniciarCronometro();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ── Lógica do cronômetro ──────────────────────────────────
  void _iniciarCronometro() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_segundosRestantes <= 0) {
        _timer?.cancel();
        return;
      }
      setState(() => _segundosRestantes--);
    });
  }

  String get _tempoFormatado {
    final dias = _segundosRestantes ~/ 86400;
    final horas = (_segundosRestantes % 86400) ~/ 3600;
    final minutos = (_segundosRestantes % 3600) ~/ 60;
    final segundos = _segundosRestantes % 60;
    return '${dias}d ${horas.toString().padLeft(2, '0')}:'
        '${minutos.toString().padLeft(2, '0')}:'
        '${segundos.toString().padLeft(2, '0')}';
  }

  Color get _corCronometro {
    final proporcao = _segundosRestantes / _prazoTotalSegundos;
    if (proporcao > 0.5) return Colors.green.shade600;
    if (proporcao > 0.2) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  // ── Toggle visual — sem API, sem banco ───────────────────
  void _toggleFoto() {
    setState(() => _imagemAnexada = !_imagemAnexada);
  }

  // ── Envio: só mostra snackbar, sem chamada de rede ───────
  void _enviarEvidencia() {
    if (!_imagemAnexada) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione uma foto antes de enviar.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Evidência enviada com sucesso! 🌱'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade500,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const StudentDashboardScreen(),
            ),
          ),
        ),
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
            // 1. CARDS DE STATUS (XP, Participantes)
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
                    color: Colors.purple.shade50,
                    icon: Icons.groups,
                    iconColor: Colors.purple.shade300,
                    value: '142',
                    label: 'Participantes',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 2. CARD DE CRONÔMETRO
            _CronometroCard(
              tempoFormatado: _tempoFormatado,
              cor: _corCronometro,
              proporcao: _segundosRestantes / _prazoTotalSegundos,
            ),
            const SizedBox(height: 12),

            // 3. CARD DE PROGRESSO
            _SectionCard(
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

            // 4. CARD DE INSTRUÇÕES
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sobre o Desafio',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Separe 10 itens recicláveis esta semana.',
                    style: TextStyle(color: AppColors.textDark, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Como participar:',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  _ChecklistItem('1. Realize a ação descrita no desafio'),
                  _ChecklistItem('2. Toque em "Anexar Evidência" abaixo'),
                  _ChecklistItem('3. Confirme o envio com o botão azul'),
                  _ChecklistItem('4. Aguarde a validação e receba seu XP!'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 5. CARD DE ENVIAR EVIDÊNCIA
            _SectionCard(
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

                  // CAIXA PONTILHADA — toggle visual puro
                  Material(
                    color: _imagemAnexada
                        ? Colors.green.shade50
                        : const Color(0xFFF9F9F9),
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      onTap: _toggleFoto,
                      borderRadius: BorderRadius.circular(16),
                      child: DashedBorderBox(
                        radius: 16,
                        color: _imagemAnexada
                            ? Colors.green.shade400
                            : Colors.grey.shade400,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 28),
                          child: _imagemAnexada
                              ? Column(
                                  children: [
                                    Icon(Icons.check_circle,
                                        color: Colors.green.shade600, size: 40),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Imagem Anexada',
                                      style: TextStyle(
                                        color: Colors.green.shade700,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Toque para remover',
                                      style: TextStyle(
                                          color: Colors.green.shade400,
                                          fontSize: 12),
                                    ),
                                  ],
                                )
                              : const Column(
                                  children: [
                                    Icon(Icons.camera_alt_outlined,
                                        color: Colors.blue, size: 40),
                                    SizedBox(height: 12),
                                    Text(
                                      'Anexar Evidência',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Toque para selecionar foto',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12),
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
                onPressed: _enviarEvidencia,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade500,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.send, size: 20),
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

// ── Widget: card de seção (fundo branco + sombra padrão) ──────
// Extraído para eliminar a duplicação de decoração que existia
// nos cards de Progresso, Instruções e Enviar Evidência.
class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
          ),
        ],
      ),
      child: child,
    );
  }
}

// ── Widget: Cronômetro ────────────────────────────────────────
class _CronometroCard extends StatelessWidget {
  const _CronometroCard({
    required this.tempoFormatado,
    required this.cor,
    required this.proporcao,
  });

  final String tempoFormatado;
  final Color cor;
  final double proporcao;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.03), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.timer, color: cor, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Tempo Restante',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            tempoFormatado,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: cor,
              letterSpacing: 1.5,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: proporcao,
              minHeight: 6,
              backgroundColor: const Color(0xFFEEEEEE),
              color: cor,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Widget auxiliar: card de stat ─────────────────────────────
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

// ── Widget auxiliar: checklist ────────────────────────────────
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