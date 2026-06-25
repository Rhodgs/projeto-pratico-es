import 'package:flutter/material.dart';
import 'package:jornada_verde/core/theme/app_colors.dart';
import 'package:jornada_verde/core/utils/api_feedback.dart';
import 'package:jornada_verde/core/widgets/student_bottom_nav.dart';
import 'package:jornada_verde/screens/accessibility_screen.dart';
import 'package:jornada_verde/screens/challenge_upload_screen.dart';
import 'package:jornada_verde/screens/progress_ranking_screen.dart';
import 'package:jornada_verde/services/api_service.dart';

class StudentDashboardScreen extends StatelessWidget {
  const StudentDashboardScreen({super.key});

  static final _api = ApiService.instance;

  Future<void> _iniciarQuiz(BuildContext context) async {
    await ApiFeedback.execute(
      context: context,
      request: () => _api.iniciarQuiz(quizId: 'amazonia'),
      successMessage: 'Quiz iniciado! Boa sorte!',
    );
  }

  Future<void> _carregarAprender(BuildContext context) async {
    await ApiFeedback.execute(
      context: context,
      request: _api.listarConteudosAprendizado,
      successMessage: 'Conteúdos carregados com sucesso!',
    );
  }

  Future<void> _buscarPerfil(BuildContext context) async {
    await ApiFeedback.execute(
      context: context,
      request: _api.buscarPerfil,
      successMessage: 'Perfil carregado com sucesso!',
      onSuccess: (_) {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const AccessibilityScreen(),
          ),
        );
      },
      showSuccessSnackBar: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeaderSection(
                    onSettings: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const AccessibilityScreen(),
                        ),
                      );
                    },
                    onProfile: () => _buscarPerfil(context),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _QuizHeroCard(
                            onPlay: () => _iniciarQuiz(context),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // ===== A SEÇÃO NOVA DO CARROSSEL AQUI =====
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Missões Ecológicas',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Complete missões e ganhe XP',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textLight,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // O Carrossel que arrasta para o lado
                        SizedBox(
                          height: 180,
                          child: PageView(
                            controller: PageController(viewportFraction: 0.88),
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: _CarouselMissionCard(
                                  title: 'Herói da Reciclagem',
                                  subtitle:
                                      'Separe 10 itens recicláveis esta semana',
                                  xp: 150,
                                  progress: 0.6,
                                  icon: Icons.recycling_rounded,
                                  color: Colors.blue.shade400,
                                  onTap: () {
                                    // Abre a nova tela de Upload Azul
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (_) =>
                                            const ChallengeUploadScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: _CarouselMissionCard(
                                  title: 'Guardião da Água',
                                  subtitle: 'Tome banhos mais curtos',
                                  xp: 100,
                                  progress: 0.3,
                                  icon: Icons.water_drop_rounded,
                                  color: Colors.teal.shade400,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (_) =>
                                            const ChallengeUploadScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        // ==========================================

                        const SizedBox(height: 28),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'MINHA COMUNIDADE E PROGRESSO',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                              color: AppColors.textLight,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _LinkCard(
                            icon: Icons.groups_rounded,
                            title: 'Turma 2º 04',
                            subtitle: 'Ranking: Você está em 5º',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const ProgressRankingScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          StudentBottomNav(
            current: StudentNavItem.inicio,
            onTap: (item) => _handleNav(context, item),
          ),
        ],
      ),
    );
  }

  void _handleNav(BuildContext context, StudentNavItem item) {
    switch (item) {
      case StudentNavItem.inicio:
        break;
      case StudentNavItem.aprender:
        _carregarAprender(context);
        break;
      case StudentNavItem.impacto:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const ProgressRankingScreen(),
          ),
        );
        break;
      case StudentNavItem.perfil:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const AccessibilityScreen(),
          ),
        );
        break;
    }
  }
}

// Widget do Cartão Azul que fica dentro do Carrossel
class _CarouselMissionCard extends StatelessWidget {
  const _CarouselMissionCard({
    required this.title,
    required this.subtitle,
    required this.xp,
    required this.progress,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final int xp;
  final double progress;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '+$xp XP',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ================= OUTROS COMPONENTES =================
class _HeaderSection extends StatelessWidget {
  const _HeaderSection({
    required this.onSettings,
    required this.onProfile,
  });

  final VoidCallback onSettings;
  final VoidCallback onProfile;

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
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _CircleIconButton(
                    icon: Icons.settings_rounded,
                    onTap: onSettings,
                  ),
                  const SizedBox(width: 10),
                  _CircleIconButton(
                    icon: Icons.person_rounded,
                    onTap: onProfile,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Bem Vindo ao Jornada Verde',
                style: TextStyle(
                  color: AppColors.white.withValues(alpha: 0.65),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Text(
                    'Olá, Alex!',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('🔥', style: TextStyle(fontSize: 16)),
                        SizedBox(width: 4),
                        Text(
                          '7',
                          style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'NÍVEL 8',
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    '1250/2000 XP',
                    style: TextStyle(
                      color: AppColors.white.withValues(alpha: 0.8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: 1250 / 2000,
                  minHeight: 8,
                  backgroundColor: Colors.black26,
                  color: AppColors.lightGreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white24,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: AppColors.white, size: 22),
        ),
      ),
    );
  }
}

class _QuizHeroCard extends StatelessWidget {
  const _QuizHeroCard({required this.onPlay});

  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: Icon(
              Icons.star_rounded,
              color: AppColors.gold.withValues(alpha: 0.9),
              size: 36,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Quiz: Amazônia',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Preserve a nossa biodiversidade',
                style: TextStyle(color: AppColors.textLight, fontSize: 14),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onPlay,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text('Jogar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LinkCard extends StatelessWidget {
  const _LinkCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardBackground,
      borderRadius: BorderRadius.circular(20),
      elevation: 2,
      shadowColor: Colors.black12,
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
                  color: AppColors.mintGreen,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: AppColors.primaryGreen, size: 28),
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
                        color: AppColors.textDark,
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
