import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_firebase_app/screens/login_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('LoginScreen Widget Test', () {
    testWidgets('displays title and sign in button', (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginScreen(),
        ),
      );

      expect(find.text('Welcome to Weather App'), findsOneWidget);

      // Verify Sign in button
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Sign in with Google'), findsOneWidget);
    });

    testWidgets('taps Sign in with Google button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginScreen(),
        ),
      );

      final signInButton = find.widgetWithText(ElevatedButton, 'Sign in with Google');

      expect(signInButton, findsOneWidget);
      await tester.tap(signInButton);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}





