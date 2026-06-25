import 'package:flutter_test/flutter_test.dart';
import 'package:jornada_verde/main.dart';

void main() {
  testWidgets('App inicia na tela de boas-vindas', (WidgetTester tester) async {
    await tester.pumpWidget(const JornadaVerdeApp());

    expect(find.text('Cadastrar'), findsOneWidget);
    expect(find.text('Já tenho uma conta'), findsOneWidget);
    expect(find.text('Sua missão começa aqui'), findsOneWidget);
  });
}
