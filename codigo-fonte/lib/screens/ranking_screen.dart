import 'package:flutter/material.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  static final List<Map<String, dynamic>> _players = [
    {
      'rank': 1,
      'name': 'Maria Silva',
      'xp': 4850,
      'level': 12,
      'avatar': 'MS',
      'badge': '🏆',
      'streak': 21,
    },
    {
      'rank': 2,
      'name': 'Pedro Oliveira',
      'xp': 4320,
      'level': 11,
      'avatar': 'PO',
      'badge': '🥈',
      'streak': 18,
    },
    {
      'rank': 3,
      'name': 'Ana Costa',
      'xp': 3980,
      'level': 10,
      'avatar': 'AC',
      'badge': '🥉',
      'streak': 15,
    },
    {
      'rank': 4,
      'name': 'João Santos',
      'xp': 1240,
      'level': 7,
      'avatar': 'JS',
      'badge': null,
      'streak': 12,
      'isCurrentUser': true,
    },
    {
      'rank': 5,
      'name': 'Lucas Pereira',
      'xp': 3100,
      'level': 9,
      'avatar': 'LP',
      'badge': null,
      'streak': 9,
    },
    {
      'rank': 6,
      'name': 'Beatriz Lima',
      'xp': 2890,
      'level': 8,
      'avatar': 'BL',
      'badge': null,
      'streak': 7,
    },
    {
      'rank': 7,
      'name': 'Carlos Souza',
      'xp': 2640,
      'level': 8,
      'avatar': 'CS',
      'badge': null,
      'streak': 5,
    },
    {
      'rank': 8,
      'name': 'Fernanda Rocha',
      'xp': 2410,
      'level': 7,
      'avatar': 'FR',
      'badge': null,
      'streak': 4,
    },
    {
      'rank': 9,
      'name': 'Rafael Mendes',
      'xp': 2180,
      'level': 7,
      'avatar': 'RM',
      'badge': null,
      'streak': 3,
    },
    {
      'rank': 10,
      'name': 'Isabela Torres',
      'xp': 1950,
      'level': 6,
      'avatar': 'IT',
      'badge': null,
      'streak': 2,
    },
  ];

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700);
      case 2:
        return const Color(0xFFC0C0C0);
      case 3:
        return const Color(0xFFCD7F32);
      default:
        return const Color(0xFF2D7A3E);
    }
  }

  Color _getAvatarColor(int rank) {
    final colors = [
      const Color(0xFF2196F3),
      const Color(0xFF9C27B0),
      const Color(0xFFFF5722),
      const Color(0xFF2D7A3E),
      const Color(0xFFFF9800),
      const Color(0xFF00BCD4),
      const Color(0xFFE91E63),
      const Color(0xFF607D8B),
      const Color(0xFF795548),
      const Color(0xFF009688),
    ];
    return colors[(rank - 1) % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final top3 = _players.sublist(0, 3);
    final rest = _players.sublist(3);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F5),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: const Color(0xFF2D7A3E),
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
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        '🏆 Ranking Global',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Top 10 desta semana',
                        style: TextStyle(fontSize: 13, color: Colors.white70),
                      ),
                      const SizedBox(height: 20),
                      // Pódio Top 3
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // 2º lugar
                          _PodiumItem(
                            player: top3[1],
                            height: 70,
                            avatarSize: 44,
                            avatarColor: _getAvatarColor(2),
                            rankColor: _getRankColor(2),
                          ),
                          const SizedBox(width: 8),
                          // 1º lugar
                          _PodiumItem(
                            player: top3[0],
                            height: 90,
                            avatarSize: 56,
                            avatarColor: _getAvatarColor(1),
                            rankColor: _getRankColor(1),
                          ),
                          const SizedBox(width: 8),
                          // 3º lugar
                          _PodiumItem(
                            player: top3[2],
                            height: 58,
                            avatarSize: 40,
                            avatarColor: _getAvatarColor(3),
                            rankColor: _getRankColor(3),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            title: const Text('Ranking'),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filtros
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['Esta Semana', 'Este Mês', 'Geral', 'Turma']
                          .map((label) => Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: label == 'Esta Semana'
                                      ? const Color(0xFF2D7A3E)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: label == 'Esta Semana'
                                        ? const Color(0xFF2D7A3E)
                                        : const Color(0xFFE0E0E0),
                                  ),
                                ),
                                child: Text(
                                  label,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: label == 'Esta Semana'
                                        ? Colors.white
                                        : const Color(0xFF666666),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '4º ao 10º lugar',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF888888),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final player = rest[index];
                final isCurrentUser = player['isCurrentUser'] == true;
                return Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isCurrentUser
                        ? const Color(0xFF2D7A3E).withOpacity(0.08)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: isCurrentUser
                        ? Border.all(color: const Color(0xFF2D7A3E), width: 1.5)
                        : null,
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
                      // Posição
                      SizedBox(
                        width: 30,
                        child: Text(
                          '${player['rank']}º',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isCurrentUser
                                ? const Color(0xFF2D7A3E)
                                : const Color(0xFF888888),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Avatar
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: isCurrentUser
                              ? const Color(0xFF2D7A3E)
                              : _getAvatarColor(player['rank'] as int),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            player['avatar'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  player['name'] as String,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: isCurrentUser
                                        ? const Color(0xFF2D7A3E)
                                        : const Color(0xFF1A1A1A),
                                  ),
                                ),
                                if (isCurrentUser) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2D7A3E),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'Você',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Nível ${player['level']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF888888),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.local_fire_department_rounded,
                                  size: 13,
                                  color: Color(0xFFFF5722),
                                ),
                                Text(
                                  ' ${player['streak']} dias',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF888888),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${(player['xp'] as int).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')} XP',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isCurrentUser
                              ? const Color(0xFF2D7A3E)
                              : const Color(0xFF444444),
                        ),
                      ),
                    ],
                  ),
                );
              },
              childCount: rest.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}

class _PodiumItem extends StatelessWidget {
  final Map<String, dynamic> player;
  final double height;
  final double avatarSize;
  final Color avatarColor;
  final Color rankColor;

  const _PodiumItem({
    required this.player,
    required this.height,
    required this.avatarSize,
    required this.avatarColor,
    required this.rankColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          player['badge'] as String? ?? '',
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 4),
        Container(
          width: avatarSize,
          height: avatarSize,
          decoration: BoxDecoration(
            color: avatarColor,
            shape: BoxShape.circle,
            border: Border.all(color: rankColor, width: 2.5),
          ),
          child: Center(
            child: Text(
              player['avatar'] as String,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: avatarSize * 0.3,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          (player['name'] as String).split(' ').first,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Container(
          height: height,
          width: 70,
          decoration: BoxDecoration(
            color: rankColor.withOpacity(0.3),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Center(
            child: Text(
              '${player['rank']}º',
              style: TextStyle(
                color: rankColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
