import 'package:flutter/material.dart';
import 'package:jornada_verde/core/theme/app_colors.dart';
import 'package:jornada_verde/core/widgets/student_bottom_nav.dart';
import 'package:jornada_verde/screens/student_dashboard_screen.dart';

class _RankingEntry {
  const _RankingEntry({
    required this.position,
    required this.name,
    required this.xp,
    this.isCurrentUser = false,
  });

  final int position;
  final String name;
  final int xp;
  final bool isCurrentUser;

  // ── Mover Método: _formatXp saiu de _PositionCard e veio para cá ──
  // Agora qualquer widget que use _RankingEntry pode formatar o XP
  // sem duplicar a lógica de formatação.
  String get xpFormatado => xp.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );
}

class ProgressRankingScreen extends StatelessWidget {
  const ProgressRankingScreen({super.key});

  static const _ranking = [
    _RankingEntry(position: 1, name: 'Ana Silva', xp: 1800),
    _RankingEntry(position: 2, name: 'Bruno Costa', xp: 1650),
    _RankingEntry(position: 3, name: 'Carla Dias', xp: 1500),
  ];

  static const _currentUser = _RankingEntry(
    position: 4,
    name: 'Alex (você)',
    xp: 1250,
    isCurrentUser: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: AppColors.cardBackground,
                                ),
                              ),
                              const Expanded(
                                child: Text(
                                  'PROGRESSO',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.cardBackground,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: AppColors.darkGreen,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: AppColors.textDark,
                                  size: 22,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Text(
                              'TURMA',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _PositionCard(user: _currentUser),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _QuickStatCard(
                                    icon: Icons.star_rounded,
                                    iconColor: AppColors.orange,
                                    label: 'Medalhas',
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _QuickStatCard(
                                    icon: Icons.trending_up_rounded,
                                    iconColor: AppColors.primaryGreen,
                                    label: 'Estatísticas',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Top Recicladores',
                                style: TextStyle(
                                  color: AppColors.cardBackground,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _RankingRow(entry: _ranking[index]),
                        );
                      },
                      childCount: _ranking.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen,
              border: Border(
                top: BorderSide(
                  color: AppColors.white.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: _RankingRow(entry: _currentUser, highlighted: true),
          ),
          StudentBottomNav(
            current: StudentNavItem.impacto,
            onTap: (item) {
              if (item == StudentNavItem.inicio) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute<void>(
                    builder: (_) => const StudentDashboardScreen(),
                  ),
                  (_) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _PositionCard extends StatelessWidget {
  const _PositionCard({required this.user});

  final _RankingEntry user;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.positionCardGreen.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        children: [
          Text(
            'SUA POSIÇÃO',
            style: TextStyle(
              color: AppColors.white.withValues(alpha: 0.8),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '#${user.position}',
            style: const TextStyle(
              color: AppColors.cardBackground,
              fontSize: 56,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Subiu 2 posições hoje',
            style: TextStyle(
              color: AppColors.white.withValues(alpha: 0.85),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: AppColors.white.withValues(alpha: 0.3)),
          const SizedBox(height: 12),
          Text(
            'Pontos XP',
            style: TextStyle(
              color: AppColors.white.withValues(alpha: 0.8),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          // Antes: _formatXp(user.xp)  — método local do widget
          // Depois: user.xpFormatado   — método na classe de dados
          Text(
            user.xpFormatado,
            style: const TextStyle(
              color: AppColors.cardBackground,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  const _QuickStatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _RankingRow extends StatelessWidget {
  const _RankingRow({
    required this.entry,
    this.highlighted = false,
  });

  final _RankingEntry entry;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: highlighted
            ? AppColors.rankingRowGreen
            : AppColors.cardDarkGreen,
        borderRadius: BorderRadius.circular(16),
        border: highlighted
            ? Border.all(
                color: AppColors.white.withValues(alpha: 0.4), width: 2)
            : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Text(
              '${entry.position}º',
              style: const TextStyle(
                color: AppColors.cardBackground,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.darkGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: AppColors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              entry.name,
              style: const TextStyle(
                color: AppColors.cardBackground,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          // Usando xpFormatado em vez de '${entry.xp} XP' bruto
          Text(
            '${entry.xpFormatado} XP',
            style: const TextStyle(
              color: AppColors.cardBackground,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}