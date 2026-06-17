import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

// Exporta o widget de corpo de notificações para reuso
class NotificationsBody extends StatefulWidget {
  const NotificationsBody({super.key});

  @override
  State<NotificationsBody> createState() => _NotificationsBodyState();
}

class _NotificationsBodyState extends State<NotificationsBody> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'type': 'xp',
      'title': 'XP Ganho!',
      'message': 'Você ganhou 150 XP completando a missão "Herói da Reciclagem"',
      'time': 'Agora mesmo',
      'read': false,
      'icon': Icons.star_rounded,
      'color': const Color(0xFFFFD700),
    },
    {
      'type': 'streak',
      'title': '🔥 Ofensiva de 12 dias!',
      'message':
          'Incrível! Você manteve sua ofensiva por 12 dias seguidos. Continue assim!',
      'time': 'há 2 horas',
      'read': false,
      'icon': Icons.local_fire_department_rounded,
      'color': const Color(0xFFFF5722),
    },
    {
      'type': 'ranking',
      'title': 'Subiu no Ranking!',
      'message': 'Você subiu para o 4º lugar no ranking desta semana. Continue!',
      'time': 'há 5 horas',
      'read': false,
      'icon': Icons.emoji_events_rounded,
      'color': const Color(0xFF2196F3),
    },
    {
      'type': 'mission',
      'title': 'Nova Missão Disponível',
      'message':
          '"Guardião das Águas" está disponível. Complete e ganhe 200 XP!',
      'time': 'há 1 dia',
      'read': true,
      'icon': Icons.water_drop_rounded,
      'color': const Color(0xFF00BCD4),
    },
    {
      'type': 'achievement',
      'title': 'Conquista Desbloqueada!',
      'message': 'Você desbloqueou a conquista "Sequência de Fogo". Parabéns!',
      'time': 'há 2 dias',
      'read': true,
      'icon': Icons.military_tech_rounded,
      'color': const Color(0xFF9C27B0),
    },
    {
      'type': 'content',
      'title': 'Novo Conteúdo',
      'message':
          'Um novo artigo sobre "Biodiversidade da Amazônia" foi publicado. Leia e ganhe 60 XP!',
      'time': 'há 3 dias',
      'read': true,
      'icon': Icons.menu_book_rounded,
      'color': const Color(0xFF4CAF50),
    },
    {
      'type': 'grade',
      'title': 'Nova Nota Lançada',
      'message':
          'Sua nota de Ciências foi lançada: 9,5. Excelente desempenho!',
      'time': 'há 4 dias',
      'read': true,
      'icon': Icons.school_rounded,
      'color': const Color(0xFF2D7A3E),
    },
    {
      'type': 'reminder',
      'title': 'Não perca sua ofensiva!',
      'message':
          'Você ainda não completou sua atividade de hoje. Faça antes que o dia acabe!',
      'time': 'há 5 dias',
      'read': true,
      'icon': Icons.notifications_active_rounded,
      'color': const Color(0xFFFF9800),
    },
  ];

  int get _unreadCount => _notifications.where((n) => !n['read']).length;

  void _markAllRead() {
    setState(() {
      for (final n in _notifications) {
        n['read'] = true;
      }
    });
  }

  void _markRead(int index) {
    setState(() => _notifications[index]['read'] = true);
  }

  @override
  Widget build(BuildContext context) {
    final unread = _notifications.where((n) => !n['read']).toList();
    final read = _notifications.where((n) => n['read']).toList();

    return Column(
      children: [
        if (_unreadCount > 0)
          Container(
            color: const Color(0xFFF5F9F5),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$_unreadCount não lidas',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF666666),
                  ),
                ),
                GestureDetector(
                  onTap: _markAllRead,
                  child: const Text(
                    'Marcar todas como lidas',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF2D7A3E),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              if (unread.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 8, 20, 4),
                  child: Text(
                    'Novas',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF888888),
                    ),
                  ),
                ),
                ...unread.map(
                  (n) => _NotificationTile(
                    notification: n,
                    onTap: () => _markRead(_notifications.indexOf(n)),
                  ),
                ),
              ],
              if (read.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 4),
                  child: Text(
                    'Anteriores',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF888888),
                    ),
                  ),
                ),
                ...read.map(
                  (n) => _NotificationTile(notification: n, onTap: () {}),
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final Map<String, dynamic> notification;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification['read'];
    final color = notification['color'] as Color;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isUnread ? color.withOpacity(0.06) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: isUnread ? Border.all(color: color.withOpacity(0.2)) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                notification['icon'] as IconData,
                color: color,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notification['title'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isUnread
                                ? FontWeight.bold
                                : FontWeight.w600,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification['message'] as String,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF666666),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notification['time'] as String,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Tela standalone de notificações acessível via ícone
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F5),
      appBar: AppBar(
        title: const Text('Notificações'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: const NotificationsBody(),
    );
  }
}
