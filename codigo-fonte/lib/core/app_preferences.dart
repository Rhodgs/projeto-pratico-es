import 'package:flutter/material.dart';

class AppPreferences extends InheritedWidget {
  const AppPreferences({
    super.key,
    required this.fontSize,
    required this.isDarkMode, // ADICIONADO AQUI
    required super.child,
  });

  final double fontSize;
  final bool isDarkMode; // ADICIONADO AQUI

  static AppPreferences? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppPreferences>();
  }

  @override
  bool updateShouldNotify(AppPreferences oldWidget) {
    // Agora verifica se a fonte OU o modo escuro mudaram
    return oldWidget.fontSize != fontSize || oldWidget.isDarkMode != isDarkMode;
  }
}
