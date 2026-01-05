// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../main.dart';

void main() {
  testWidgets('BakerStack app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget( BakerStackApp());

    // Wait for splash screen animation
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verify that we navigate to login screen (if not authenticated)
    // or home screen (if authenticated from previous session)
    expect(
      find.byType(MaterialApp),
      findsOneWidget,
    );
  });

  testWidgets('Splash screen displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget( BakerStackApp());

    // Verify splash screen elements
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for navigation
    await tester.pumpAndSettle(const Duration(seconds: 3));
  });

  testWidgets('App has correct theme colors', (WidgetTester tester) async {
    await tester.pumpWidget( BakerStackApp());

    final BuildContext context = tester.element(find.byType(MaterialApp));
    final ThemeData theme = Theme.of(context);

    // Verify primary color
    expect(theme.primaryColor, const Color(0xFF7B2CBF));

    // Verify color scheme
    expect(theme.colorScheme.primary, const Color(0xFF7B2CBF));
    expect(theme.colorScheme.secondary, const Color(0xFF9D4EDD));
  });

  testWidgets('Navigation routes are configured', (WidgetTester tester) async {
    await tester.pumpWidget(BakerStackApp());

    final BuildContext context = tester.element(find.byType(MaterialApp));
    final materialApp = context.widget as MaterialApp;

    // Verify routes exist
    expect(materialApp.routes, isNotEmpty);
    expect(materialApp.routes!.containsKey('/'), true);
    expect(materialApp.routes!.containsKey('/login'), true);
    expect(materialApp.routes!.containsKey('/register'), true);
    expect(materialApp.routes!.containsKey('/home'), true);
    expect(materialApp.routes!.containsKey('/cart'), true);
    expect(materialApp.routes!.containsKey('/profile'), true);
  });

  testWidgets('404 screen displays on unknown route', (WidgetTester tester) async {
    await tester.pumpWidget( BakerStackApp());
    await tester.pumpAndSettle();

    final BuildContext context = tester.element(find.byType(MaterialApp));

    // Navigate to unknown route
    Navigator.of(context).pushNamed('/unknown-route');
    await tester.pumpAndSettle();

    // Verify 404 screen elements
    expect(find.text('404'), findsOneWidget);
    expect(find.text('Page Not Found'), findsOneWidget);
    expect(find.text('GO TO HOME'), findsOneWidget);
  });
}