import 'package:flutter/material.dart';
import 'package:jornada_verde/core/theme/app_colors.dart';

enum StudentNavItem { inicio, aprender, impacto, perfil }

class StudentBottomNav extends StatelessWidget {
  const StudentBottomNav({
    super.key,
    required this.current,
    this.onTap,
  });

  final StudentNavItem current;
  final ValueChanged<StudentNavItem>? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Início',
                active: current == StudentNavItem.inicio,
                onTap: () => onTap?.call(StudentNavItem.inicio),
              ),
              _NavItem(
                icon: Icons.bolt_rounded,
                label: 'Aprender',
                active: current == StudentNavItem.aprender,
                onTap: () => onTap?.call(StudentNavItem.aprender),
              ),
              _NavItem(
                icon: Icons.emoji_events_rounded,
                label: 'Impacto',
                active: current == StudentNavItem.impacto,
                onTap: () => onTap?.call(StudentNavItem.impacto),
              ),
              _NavItem(
                icon: Icons.person_rounded,
                label: 'Perfil',
                active: current == StudentNavItem.perfil,
                onTap: () => onTap?.call(StudentNavItem.perfil),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primaryGreen : AppColors.textLight;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
