import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:factory_ai_demo/main.dart';

void main() {
  testWidgets(
    'Login button shows loading state and disables while request runs',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final loginButton = find.byType(FilledButton);
      expect(loginButton, findsOneWidget);

      await tester.tap(loginButton);
      await tester.pump();

      expect(find.text('Logging in...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(tester.widget<FilledButton>(loginButton).onPressed, isNull);

      await tester.pump(const Duration(milliseconds: 800));

      expect(find.text('Login'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(tester.widget<FilledButton>(loginButton).onPressed, isNotNull);
    },
  );

  testWidgets('Login button ignores duplicate taps while loading', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    final loginButton = find.byType(FilledButton);

    await tester.tap(loginButton);
    await tester.tap(loginButton);
    await tester.pump();

    expect(find.text('Logging in...'), findsOneWidget);
    expect(find.text('Requests sent: 1'), findsOneWidget);

    await tester.pumpAndSettle();
  });
}
