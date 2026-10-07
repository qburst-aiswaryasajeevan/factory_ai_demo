import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:factory_ai_demo/main.dart';

void main() {
  testWidgets('empty fields show required validation errors', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
    expect(find.text('Login failed. Please try again.'), findsNothing);
  });

  testWidgets('email is required when password is populated', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));
    await tester.enterText(find.byType(TextFormField).at(1), 'secret');

    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsNothing);
  });

  testWidgets('password is required when email is populated', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));
    await tester.enterText(
      find.byType(TextFormField).first,
      'user@example.com',
    );

    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(find.text('Email is required'), findsNothing);
    expect(find.text('Password is required'), findsOneWidget);
  });

  testWidgets('valid submission shows loading and passes credentials', (
    WidgetTester tester,
  ) async {
    final loginCompleter = Completer<void>();
    String? submittedEmail;
    String? submittedPassword;
    var requestCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(
          onLogin: (email, password) {
            requestCount++;
            submittedEmail = email;
            submittedPassword = password;
            return loginCompleter.future;
          },
        ),
      ),
    );
    await tester.enterText(
      find.byType(TextFormField).first,
      'user@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'secret');

    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(find.text('Logging in...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
    expect(submittedEmail, 'user@example.com');
    expect(submittedPassword, 'secret');

    await tester.tap(find.byType(FilledButton), warnIfMissed: false);
    await tester.pump();
    expect(requestCount, 1);

    loginCompleter.complete();
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byKey(const Key('login-error')), findsNothing);
  });

  testWidgets('login failure is shown and loading ends', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(
          onLogin: (email, password) =>
              Future<void>.error(Exception('Invalid credentials')),
        ),
      ),
    );
    await tester.enterText(
      find.byType(TextFormField).first,
      'user@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'wrong');

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    expect(find.text('Login failed. Please try again.'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNotNull,
    );
  });

  testWidgets('unconfigured login fails visibly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));
    await tester.enterText(
      find.byType(TextFormField).first,
      'user@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'secret');

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    expect(find.text('Login failed. Please try again.'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
