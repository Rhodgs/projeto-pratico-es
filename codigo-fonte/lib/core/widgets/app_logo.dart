import 'package:flutter/material.dart';
import 'package:jornada_verde/core/theme/app_colors.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 72,
    this.showTitle = true,
    this.showTagline = true,
    this.light = true,
  });

  final double size;
  final bool showTitle;
  final bool showTagline;
  final bool light;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: light ? AppColors.white : AppColors.primaryGreen,
            borderRadius: BorderRadius.circular(size * 0.22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.layers,
            size: size * 0.5,
            color: light ? AppColors.primaryGreen : AppColors.white,
          ),
        ),
        if (showTitle) ...[
          SizedBox(height: size * 0.22),
          Text(
            'Jornada Verde',
            style: TextStyle(
              fontSize: size * 0.38,
              fontWeight: FontWeight.w800,
              color: light ? AppColors.white : AppColors.textDark,
              letterSpacing: -0.5,
            ),
          ),
        ],
        if (showTagline) ...[
          const SizedBox(height: 6),
          Text(
            'Sua missão começa aqui',
            style: TextStyle(
              fontSize: size * 0.2,
              color: light
                  ? AppColors.white.withValues(alpha: 0.9)
                  : AppColors.textLight,
            ),
          ),
        ],
      ],
    );
  }
}
