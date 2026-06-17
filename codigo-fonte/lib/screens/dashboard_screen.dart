import 'package:flutter/material.dart';
import 'challenge_detail_screen.dart';
import 'notifications_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _carouselIndex = 0;

  final List<Map<String, dynamic>> _missions = [
    {
      'title': 'Herói da Reciclagem',
      'description': 'Separe 10 itens recicláveis esta semana',
      'xp': 150,
      'icon': Icons.recycling_rounded,
      'color': const Color(0xFF2196F3),
      'progress': 0.6,
      'difficulty': 'Médio',
    },
    {
      'title': 'Guardião das Águas',
      'description': 'Reduza o consumo de água em 20% por 7 dias',
      'xp': 200,
      'icon': Icons.water_drop_rounded,
      'color': const Color(0xFF00BCD4),
      'progress': 0.3,
      'difficulty': 'Difícil',
    },
    {
      'title': 'Plantador Urbano',
      'description': 'Plante uma muda e documente o crescimento',
      'xp': 120,
      'icon': Icons.local_florist_rounded,
      'color': const Color(0xFF4CAF50),
      'progress': 0.0,
      'difficulty': 'Fácil',
    },
    {
      'title': 'Ciclista Verde',
      'description': 'Substitua 5 trajetos de carro por bicicleta',
      'xp': 180,
      'icon': Icons.directions_bike_rounded,
      'color': const Color(0xFFFF9800),
      'progress': 0.8,
      'difficulty': 'Médio',
    },
  ];

  final List<Map<String, dynamic>> _recentGrades = [
    {
      'subject': 'Ciências',
      'grade': 9.5,
      'icon': Icons.science_outlined,
      'color': const Color(0xFF4CAF50),
    },
    {
      'subject': 'Geografia',
      'grade': 8.0,
      'icon': Icons.public_outlined,
      'color': const Color(0xFF2196F3),
    },
    {
      'subject': 'Biologia',
      'grade': 9.0,
      'icon': Icons.biotech_outlined,
      'color': const Color(0xFF9C27B0),
    },
    {
      'subject': 'Matemática',
      'grade': 7.5,
      'icon': Icons.calculate_outlined,
      'color': const Color(0xFFFF9800),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F5),
      body: CustomScrollView(
        slivers: [
          // App Bar customizada
          SliverAppBar(
            expandedHeight: 160,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF2D7A3E),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1B5E20), Color(0xFF2D7A3E)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '🌿 Olá, João!',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const Text(
                                  'Continue sua jornada verde',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                            // Notificações
                            Stack(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.notifications_outlined,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const NotificationsScreen(),
                                      ),
                                    );
                                  },
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFF5722),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Barra de XP
                        _XpBar(currentXp: 1240, maxXp: 2000, level: 7),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Conteúdo
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cards de stats
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.local_fire_department_rounded,
                          iconColor: const Color(0xFFFF5722),
                          value: '12',
                          label: 'Dias seguidos',
                          bgColor: const Color(0xFFFFF3E0),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.eco_rounded,
                          iconColor: const Color(0xFF2D7A3E),
                          value: '28',
                          label: 'Missões completas',
                          bgColor: const Color(0xFFE8F5E9),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.star_rounded,
                          iconColor: const Color(0xFFFFD700),
                          value: '#4',
                          label: 'No ranking',
                          bgColor: const Color(0xFFFFFDE7),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Ofensiva diária
                  _buildStreakSection(),

                  const SizedBox(height: 24),

                  // Carrossel de missões
                  const Text(
                    'Missões Ecológicas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Complete missões e ganhe XP',
                    style: TextStyle(fontSize: 13, color: Color(0xFF888888)),
                  ),
                  const SizedBox(height: 12),
                  _buildMissionCarousel(),

                  // Dots do carrossel
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _missions.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: _carouselIndex == index ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _carouselIndex == index
                              ? const Color(0xFF2D7A3E)
                              : const Color(0xFFCCCCCC),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Notas recentes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Notas Recentes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Ver todas',
                          style: TextStyle(color: Color(0xFF2D7A3E)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...List.generate(
                    _recentGrades.length,
                    (index) => _GradeCard(grade: _recentGrades[index]),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakSection() {
    final weekDays = ['S', 'T', 'Q', 'Q', 'S', 'S', 'D'];
    final completed = [true, true, true, true, true, false, false];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_fire_department_rounded,
                color: Color(0xFFFF5722),
                size: 22,
              ),
              const SizedBox(width: 8),
              const Text(
                'Ofensiva Diária',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF5722).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '🔥 12 dias',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF5722),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              7,
              (index) => Column(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: completed[index]
                          ? const Color(0xFF2D7A3E)
                          : const Color(0xFFF0F0F0),
                      shape: BoxShape.circle,
                      border: index == 4
                          ? Border.all(
                              color: const Color(0xFFFF5722),
                              width: 2,
                            )
                          : null,
                    ),
                    child: Center(
                      child: completed[index]
                          ? const Icon(
                              Icons.check_rounded,
                              size: 18,
                              color: Colors.white,
                            )
                          : Text(
                              weekDays[index],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF999999),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    weekDays[index],
                    style: TextStyle(
                      fontSize: 11,
                      color: completed[index]
                          ? const Color(0xFF2D7A3E)
                          : const Color(0xFF999999),
                      fontWeight: completed[index]
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionCarousel() {
    final PageController controller = PageController(viewportFraction: 0.9);

    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: controller,
        itemCount: _missions.length,
        onPageChanged: (index) => setState(() => _carouselIndex = index),
        itemBuilder: (context, index) {
          final mission = _missions[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChallengeDetailScreen(mission: mission),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    (mission['color'] as Color),
                    (mission['color'] as Color).withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: (mission['color'] as Color).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          mission['icon'] as IconData,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '+${mission['xp']} XP',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    mission['title'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mission['description'] as String,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: mission['progress'] as double,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _XpBar extends StatelessWidget {
  final int currentXp;
  final int maxXp;
  final int level;

  const _XpBar({
    required this.currentXp,
    required this.maxXp,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    final progress = currentXp / maxXp;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD700),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Nível $level',
                      style: const TextStyle(
                        color: Color(0xFF1A1A1A),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Eco Explorador',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Text(
                '$currentXp / $maxXp XP',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final Color bgColor;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF666666),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}

class _GradeCard extends StatelessWidget {
  final Map<String, dynamic> grade;

  const _GradeCard({required this.grade});

  Color _gradeColor(double g) {
    if (g >= 9) return const Color(0xFF2D7A3E);
    if (g >= 7) return const Color(0xFF2196F3);
    if (g >= 5) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }

  @override
  Widget build(BuildContext context) {
    final g = grade['grade'] as double;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: (grade['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              grade['icon'] as IconData,
              color: grade['color'] as Color,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  grade['subject'] as String,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const Text(
                  'Avaliação bimestral',
                  style: TextStyle(fontSize: 12, color: Color(0xFF888888)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: _gradeColor(g).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              g.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _gradeColor(g),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

