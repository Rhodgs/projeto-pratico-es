import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _grades = [
    {
      'subject': 'Ciências',
      'grades': [9.5, 8.0, 9.5, 9.0],
      'avg': 9.0,
      'icon': Icons.science_outlined,
      'color': const Color(0xFF4CAF50),
    },
    {
      'subject': 'Geografia',
      'grades': [8.0, 7.5, 8.5, 8.0],
      'avg': 8.0,
      'icon': Icons.public_outlined,
      'color': const Color(0xFF2196F3),
    },
    {
      'subject': 'Biologia',
      'grades': [9.0, 8.5, 8.0, 9.5],
      'avg': 8.75,
      'icon': Icons.biotech_outlined,
      'color': const Color(0xFF9C27B0),
    },
    {
      'subject': 'Matemática',
      'grades': [7.5, 7.0, 8.0, 7.5],
      'avg': 7.5,
      'icon': Icons.calculate_outlined,
      'color': const Color(0xFFFF9800),
    },
    {
      'subject': 'Português',
      'grades': [8.5, 9.0, 8.0, 8.5],
      'avg': 8.5,
      'icon': Icons.menu_book_outlined,
      'color': const Color(0xFFE91E63),
    },
    {
      'subject': 'História',
      'grades': [8.0, 7.5, 8.5, 8.0],
      'avg': 8.0,
      'icon': Icons.history_edu_outlined,
      'color': const Color(0xFF795548),
    },
  ];

  final List<Map<String, dynamic>> _achievements = [
    {
      'title': 'Primeiro Passo',
      'description': 'Complete sua primeira missão',
      'emoji': '🌱',
      'unlocked': true,
      'date': 'há 30 dias',
    },
    {
      'title': 'Reciclador Júnior',
      'description': 'Complete 5 missões de reciclagem',
      'emoji': '♻️',
      'unlocked': true,
      'date': 'há 20 dias',
    },
    {
      'title': 'Sequência de Fogo',
      'description': 'Mantenha 7 dias de ofensiva',
      'emoji': '🔥',
      'unlocked': true,
      'date': 'há 15 dias',
    },
    {
      'title': 'Eco Explorador',
      'description': 'Alcance o Nível 7',
      'emoji': '⭐',
      'unlocked': true,
      'date': 'há 10 dias',
    },
    {
      'title': 'Top 5 Ranking',
      'description': 'Entre no Top 5 do ranking semanal',
      'emoji': '🏆',
      'unlocked': false,
      'date': null,
    },
    {
      'title': 'Guardião da Água',
      'description': 'Complete todas as missões de água',
      'emoji': '💧',
      'unlocked': false,
      'date': null,
    },
    {
      'title': 'Mestre Verde',
      'description': 'Alcance o Nível 15',
      'emoji': '🌿',
      'unlocked': false,
      'date': null,
    },
    {
      'title': 'Cientista Ambiental',
      'description': 'Leia 20 artigos de sustentabilidade',
      'emoji': '🔬',
      'unlocked': false,
      'date': null,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _avgColor(double avg) {
    if (avg >= 9) return const Color(0xFF2D7A3E);
    if (avg >= 7) return const Color(0xFF2196F3);
    if (avg >= 5) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F5),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 260,
              pinned: true,
              backgroundColor: const Color(0xFF2D7A3E),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings_outlined, color: Colors.white),
                  onPressed: () {},
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF1B5E20), Color(0xFF2D7A3E)],
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),
                        // Avatar
                        Stack(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFFFD700),
                                  width: 3,
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'JS',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2D7A3E),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'João Santos',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFD700),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Nível 7 • Eco Explorador',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Stats em linha
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _StatItem(label: '1.240', sublabel: 'XP Total'),
                            Container(
                              width: 1,
                              height: 30,
                              color: Colors.white30,
                            ),
                            _StatItem(label: '28', sublabel: 'Missões'),
                            Container(
                              width: 1,
                              height: 30,
                              color: Colors.white30,
                            ),
                            _StatItem(label: '12🔥', sublabel: 'Dias'),
                            Container(
                              width: 1,
                              height: 30,
                              color: Colors.white30,
                            ),
                            _StatItem(label: '#4', sublabel: 'Ranking'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              title: const Text('Perfil'),
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white54,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                tabs: const [
                  Tab(text: 'Boletim'),
                  Tab(text: 'Conquistas'),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // Aba Boletim
            _buildBoletim(),
            // Aba Conquistas
            _buildConquistas(),
          ],
        ),
      ),
    );
  }

  Widget _buildBoletim() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Resumo
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2D7A3E).withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF2D7A3E).withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.school_rounded,
                  color: Color(0xFF2D7A3E), size: 28),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '8º Ano • Turma B',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D7A3E),
                    ),
                  ),
                  Text(
                    '2º Bimestre • 2024',
                    style:
                        TextStyle(fontSize: 13, color: Color(0xFF666666)),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: const [
                  Text(
                    '8.5',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D7A3E),
                    ),
                  ),
                  Text(
                    'Média',
                    style:
                        TextStyle(fontSize: 11, color: Color(0xFF666666)),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Legenda bimestres
        Row(
          children: ['1º Bi', '2º Bi', '3º Bi', '4º Bi']
              .asMap()
              .entries
              .map((e) => Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: e.key == 0 ? 0 : 4),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: e.key == 1
                            ? const Color(0xFF2D7A3E)
                            : const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          e.value,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: e.key == 1
                                ? Colors.white
                                : const Color(0xFF666666),
                          ),
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 16),
        ..._grades.map((g) => _GradeRow(grade: g, avgColor: _avgColor(g['avg'] as double))).toList(),
      ],
    );
  }

  Widget _buildConquistas() {
    final unlocked = _achievements.where((a) => a['unlocked'] == true).toList();
    final locked = _achievements.where((a) => a['unlocked'] == false).toList();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Progresso
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2D7A3E), Color(0xFF4CAF50)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Text('🏅', style: TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${unlocked.length} de ${_achievements.length} conquistas',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: unlocked.length / _achievements.length,
                        backgroundColor: Colors.white30,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Desbloqueadas',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 10),
        ...unlocked.map((a) => _AchievementCard(achievement: a)).toList(),
        const SizedBox(height: 20),
        const Text(
          'Bloqueadas',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 10),
        ...locked.map((a) => _AchievementCard(achievement: a)).toList(),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String sublabel;

  const _StatItem({required this.label, required this.sublabel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          sublabel,
          style: const TextStyle(fontSize: 11, color: Colors.white60),
        ),
      ],
    );
  }
}

class _GradeRow extends StatelessWidget {
  final Map<String, dynamic> grade;
  final Color avgColor;

  const _GradeRow({required this.grade, required this.avgColor});

  @override
  Widget build(BuildContext context) {
    final grades = grade['grades'] as List<double>;
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
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (grade['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  grade['icon'] as IconData,
                  color: grade['color'] as Color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  grade['subject'] as String,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: avgColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  (grade['avg'] as double).toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: avgColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: grades.asMap().entries.map((e) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: e.key == 0 ? 0 : 6),
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${e.key + 1}º Bi',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF888888),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        e.value.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final Map<String, dynamic> achievement;

  const _AchievementCard({required this.achievement});

  @override
  Widget build(BuildContext context) {
    final unlocked = achievement['unlocked'] as bool;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: unlocked ? Colors.white : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(14),
        border: unlocked
            ? Border.all(color: const Color(0xFF2D7A3E).withOpacity(0.3))
            : null,
        boxShadow: unlocked
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: unlocked
                  ? const Color(0xFF2D7A3E).withOpacity(0.1)
                  : const Color(0xFFE0E0E0),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                unlocked ? achievement['emoji'] as String : '🔒',
                style: TextStyle(
                  fontSize: unlocked ? 24 : 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement['title'] as String,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: unlocked
                        ? const Color(0xFF1A1A1A)
                        : const Color(0xFF999999),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  achievement['description'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: unlocked
                        ? const Color(0xFF666666)
                        : const Color(0xFFBBBBBB),
                  ),
                ),
              ],
            ),
          ),
          if (unlocked && achievement['date'] != null) ...[
            Text(
              achievement['date'] as String,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF2D7A3E),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
