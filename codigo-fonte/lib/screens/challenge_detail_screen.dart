import 'package:flutter/material.dart';

class ChallengeDetailScreen extends StatefulWidget {
  final Map<String, dynamic> mission;

  const ChallengeDetailScreen({super.key, required this.mission});

  @override
  State<ChallengeDetailScreen> createState() => _ChallengeDetailScreenState();
}

class _ChallengeDetailScreenState extends State<ChallengeDetailScreen> {
  bool _evidenceUploaded = false;
  bool _isUploading = false;
  String? _uploadedImageName;

  void _simulateUpload() async {
    setState(() => _isUploading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isUploading = false;
        _evidenceUploaded = true;
        _uploadedImageName = 'evidencia_${DateTime.now().millisecondsSinceEpoch}.jpg';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white),
              SizedBox(width: 8),
              Text('Evidência enviada com sucesso!'),
            ],
          ),
          backgroundColor: const Color(0xFF2D7A3E),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Enviar Evidência',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Escolha como deseja enviar sua foto',
                  style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                ),
                const SizedBox(height: 24),
                _SourceOption(
                  icon: Icons.camera_alt_rounded,
                  label: 'Tirar foto com a câmera',
                  color: const Color(0xFF2D7A3E),
                  onTap: () {
                    Navigator.pop(context);
                    _simulateUpload();
                  },
                ),
                const SizedBox(height: 12),
                _SourceOption(
                  icon: Icons.photo_library_rounded,
                  label: 'Escolher da galeria',
                  color: const Color(0xFF2196F3),
                  onTap: () {
                    Navigator.pop(context);
                    _simulateUpload();
                  },
                ),
                const SizedBox(height: 12),
                _SourceOption(
                  icon: Icons.cancel_outlined,
                  label: 'Cancelar',
                  color: const Color(0xFF888888),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mission = widget.mission;
    final color = mission['color'] as Color;
    final progress = mission['progress'] as double;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F5),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: color,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color.withOpacity(0.9),
                      color,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          mission['icon'] as IconData,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        mission['title'] as String,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          mission['difficulty'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            title: Text(mission['title'] as String),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cards de info
                  Row(
                    children: [
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.star_rounded,
                          iconColor: const Color(0xFFFFD700),
                          label: 'Recompensa',
                          value: '+${mission['xp']} XP',
                          bgColor: const Color(0xFFFFFDE7),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.timer_outlined,
                          iconColor: const Color(0xFF2196F3),
                          label: 'Prazo',
                          value: '7 dias',
                          bgColor: const Color(0xFFE3F2FD),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.people_outline_rounded,
                          iconColor: const Color(0xFF9C27B0),
                          label: 'Participantes',
                          value: '142',
                          bgColor: const Color(0xFFF3E5F5),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Progresso
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Progresso',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            Text(
                              '${(progress * 100).toInt()}%',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: const Color(0xFFF0F0F0),
                            valueColor:
                                AlwaysStoppedAnimation<Color>(color),
                            minHeight: 10,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Descrição
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sobre o Desafio',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          mission['description'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF444444),
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Como participar:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...const [
                          '1. Realize a ação descrita no desafio',
                          '2. Tire uma foto como evidência',
                          '3. Envie a foto usando o botão abaixo',
                          '4. Aguarde a validação e receba seu XP!',
                        ].map(
                          (step) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.check_circle_outline_rounded,
                                  size: 18,
                                  color: Color(0xFF2D7A3E),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    step,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF555555),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Seção de envio de evidência
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Enviar Evidência',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Envie uma foto provando que você completou o desafio.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF666666),
                          ),
                        ),
                        const SizedBox(height: 16),

                        if (_evidenceUploaded) ...[
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2D7A3E).withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF2D7A3E).withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2D7A3E)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.check_circle_rounded,
                                    color: Color(0xFF2D7A3E),
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Evidência enviada!',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF2D7A3E),
                                        ),
                                      ),
                                      Text(
                                        _uploadedImageName ?? '',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF666666),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _evidenceUploaded = false;
                                      _uploadedImageName = null;
                                    });
                                  },
                                  child: const Text(
                                    'Trocar',
                                    style:
                                        TextStyle(color: Color(0xFF2D7A3E)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          // Área de upload
                          GestureDetector(
                            onTap: _showImageSourceSheet,
                            child: Container(
                              width: double.infinity,
                              height: 120,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F9F5),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFBBBBBB),
                                  style: BorderStyle.solid,
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_a_photo_outlined,
                                    size: 36,
                                    color: color,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Toque para adicionar foto',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: color,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'JPG, PNG • máx 10MB',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF888888),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Botão principal
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _evidenceUploaded
                            ? const Color(0xFF2D7A3E)
                            : color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _isUploading
                          ? null
                          : (_evidenceUploaded
                              ? () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                          'Missão enviada para validação! ✅'),
                                      backgroundColor:
                                          const Color(0xFF2D7A3E),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                    ),
                                  );
                                  Navigator.pop(context);
                                }
                              : _showImageSourceSheet),
                      child: _isUploading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Enviando...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _evidenceUploaded
                                      ? Icons.send_rounded
                                      : Icons.camera_alt_rounded,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _evidenceUploaded
                                      ? 'Enviar para Validação'
                                      : 'Enviar Evidência Fotográfica',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color bgColor;

  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
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
          ),
        ],
      ),
    );
  }
}

class _SourceOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SourceOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
