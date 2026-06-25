import 'package:flutter/material.dart';
import 'package:jornada_verde/core/theme/app_colors.dart';
import 'package:jornada_verde/core/utils/api_feedback.dart';
import 'package:jornada_verde/services/api_service.dart';

class AccessibilityScreen extends StatefulWidget {
  const AccessibilityScreen({super.key});

  @override
  State<AccessibilityScreen> createState() => _AccessibilityScreenState();
}

class _AccessibilityScreenState extends State<AccessibilityScreen> {
  final _api = ApiService.instance;

  bool _darkMode = false;
  bool _colorBlindMode = false;
  double _fontSize = 16;

  Future<void> _salvarPreferencias({bool popOnSuccess = true}) async {
    await ApiFeedback.execute(
      context: context,
      request: () => _api.salvarPreferenciasAcessibilidade(
        modoEscuro: _darkMode,
        modoDaltonismo: _colorBlindMode,
        tamanhoFonte: _fontSize,
      ),
      successMessage: 'Preferências salvas com sucesso!',
      onSuccess: (_) {
        if (popOnSuccess && mounted) Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      appBar: AppBar(
        title: const Text(
          'Configurações',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppColors.headerForestDark,
        foregroundColor: AppColors.white,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Acessibilidade',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: AppColors.cardBackground,
            elevation: 2,
            shadowColor: Colors.black12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text(
                    'Modo Escuro',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text('Reduz o brilho da interface'),
                  value: _darkMode,
                  activeThumbColor: AppColors.primaryGreen,
                  onChanged: (value) => setState(() => _darkMode = value),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                SwitchListTile(
                  title: const Text(
                    'Modo Daltonismo',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text('Ajusta cores para melhor contraste'),
                  value: _colorBlindMode,
                  activeThumbColor: AppColors.primaryGreen,
                  onChanged: (value) => setState(() => _colorBlindMode = value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Card(
            color: AppColors.cardBackground,
            elevation: 2,
            shadowColor: Colors.black12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tamanho da Fonte',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_fontSize.round()} px',
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: _fontSize,
                    ),
                  ),
                  Slider(
                    value: _fontSize,
                    min: 12,
                    max: 24,
                    divisions: 12,
                    label: '${_fontSize.round()}',
                    activeColor: AppColors.primaryGreen,
                    onChanged: (value) => setState(() => _fontSize = value),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Exemplo de texto com o tamanho selecionado.',
                    style: TextStyle(fontSize: _fontSize),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: _salvarPreferencias,
              child: const Text('Salvar Preferências'),
            ),
          ),
        ],
      ),
    );
  }
}
