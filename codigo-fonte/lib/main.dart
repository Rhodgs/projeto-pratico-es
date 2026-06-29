import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Importações de todas as suas telas
import 'package:jornada_verde/screens/welcome_screen.dart';
import 'package:jornada_verde/screens/login_screen.dart';
import 'package:jornada_verde/screens/register_screen.dart';
import 'package:jornada_verde/screens/student_dashboard_screen.dart';
import 'package:jornada_verde/screens/challenge_upload_screen.dart';
import 'package:jornada_verde/screens/progress_ranking_screen.dart';
import 'package:jornada_verde/screens/teacher_dashboard_screen.dart';
import 'package:jornada_verde/screens/teacher_launch_challenge_screen.dart';
import 'package:jornada_verde/screens/teacher_validation_screen.dart';
import 'package:jornada_verde/screens/accessibility_screen.dart';
import 'package:jornada_verde/core/app_preferences.dart';

// A CHAVE MESTRA: Controla o aplicativo de qualquer lugar
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const JornadaVerdeApp());
}

class JornadaVerdeApp extends StatefulWidget {
  const JornadaVerdeApp({super.key});

  static _JornadaVerdeAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_JornadaVerdeAppState>();

  @override
  State<JornadaVerdeApp> createState() => _JornadaVerdeAppState();
}

class _JornadaVerdeAppState extends State<JornadaVerdeApp> {
  double fontSize = 16;
  bool isDarkMode = false;

  void setFontSize(double size) => setState(() => fontSize = size);
  void setDarkMode(bool isDark) => setState(() => isDarkMode = isDark);

  void _mostrarDevMenuGlobal() {
    // Usamos a chave mestra para descobrir onde o app está agora
    final context = navigatorKey.currentContext;
    if (context == null) return;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('🚀 Dev Menu - Apresentação'),
        content: SizedBox(
          width: 300,
          height: 400,
          child: ListView(
            children: [
              _botaoTela('1. Boas-Vindas', const WelcomeScreen()),
              _botaoTela('2. Login', const LoginScreen()),
              _botaoTela('3. Cadastro', const RegisterScreen()),
              _botaoTela('4. Dashboard Aluno', const StudentDashboardScreen()),
              _botaoTela('5. Upload Desafio', const ChallengeUploadScreen()),
              _botaoTela('6. Progresso/Ranking', const ProgressRankingScreen()),
              _botaoTela(
                  '7. Dashboard Professor', const TeacherDashboardScreen()),
              _botaoTela(
                  '8. Lançar Desafios', const TeacherLaunchChallengeScreen()),
              _botaoTela(
                  '9. Validar Evidências', const TeacherValidationScreen()),
              _botaoTela('10. Acessibilidade', const AccessibilityScreen()),
              _botaoTela('11. Desafios', const ChallengeUploadScreen()),
              const Divider(),
              ListTile(
                title: const Text('Fechar Menu',
                    style: TextStyle(color: Colors.red)),
                leading: const Icon(Icons.close, color: Colors.red),
                onTap: () => navigatorKey.currentState?.pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _botaoTela(String nome, Widget tela) {
    return ListTile(
      title: Text(nome),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: () {
        navigatorKey.currentState?.pop(); // Fecha o menu usando a chave
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (_) => tela), // Muda a tela usando a chave
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppPreferences(
      fontSize: fontSize,
      isDarkMode: isDarkMode,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Jornada Verde',
        debugShowCheckedModeBanner: false,
        themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness:
                Brightness.dark, // Garante que a paleta verde adapte pro escuro
          ),
          useMaterial3: true,
        ),
        builder: (context, child) {
          return CallbackShortcuts(
            bindings: <ShortcutActivator, VoidCallback>{
              const SingleActivator(LogicalKeyboardKey.f9): () {
                _mostrarDevMenuGlobal();
              },
            },
            child: Focus(
              autofocus: true,
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(fontSize / 16),
                ),
                child: Stack(
                  children: [
                    child ?? const SizedBox(),
                    // Botão flutuante para o DevMenu no celular
                    Positioned(
                      top: 50,
                      right: 20,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _mostrarDevMenuGlobal,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(
                                  0.3), // Fundo semitransparente discreto
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.bug_report,
                                color: Colors.white, size: 24),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        home: const WelcomeScreen(),
      ),
    );
  }
}
