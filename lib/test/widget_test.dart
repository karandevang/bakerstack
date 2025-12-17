import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'package:bakerstack/services/auth_service.dart';

void main() {
  testWidgets('BakerStack app launches without errors', (WidgetTester tester) async {
    // Build app
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => AuthService(),
        child: BakerStackApp(),
      ),
    );

    // Wait for async operations
    await tester.pumpAndSettle();

    // Verify MaterialApp exists
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}