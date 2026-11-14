import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_epi/main.dart';

void main() {
  testWidgets('exibe a tela inicial e o menu principal', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Empréstimos de EPIs'), findsOneWidget);
    expect(find.text('Selecione uma opção no menu lateral'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    expect(find.text('Menu Principal'), findsOneWidget);
    expect(find.text('Funcionários'), findsOneWidget);
  });
}
