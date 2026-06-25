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

// A CHAVE MESTRA: Controla o aplicativo de qualquer lugar
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const JornadaVerdeApp());
}

class JornadaVerdeApp extends StatelessWidget {
  const JornadaVerdeApp({super.key});

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
    return MaterialApp(
      navigatorKey: navigatorKey, // ENTREGAMOS A CHAVE AQUI PARA O FLUTTER
      title: 'Jornada Verde',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
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
            child: child ?? const SizedBox(),
          ),
        );
      },
      home: const WelcomeScreen(),
    );
  }
}
