import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_usage_example/presentation/widgets/secondary_button.dart';

void main() {
  group('SecondaryButton', () {
    testWidgets('displays correct text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SecondaryButton(text: 'Test Button'),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (WidgetTester tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SecondaryButton(
              text: 'Test Button',
              onPressed: () {
                wasPressed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(SecondaryButton));
      await tester.pumpAndSettle();

      expect(wasPressed, isTrue);
    });

    testWidgets('does not call onPressed when disabled', (WidgetTester tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SecondaryButton(
              text: 'Test Button',
              onPressed: null,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(SecondaryButton));
      await tester.pumpAndSettle();

      expect(wasPressed, isFalse);
    });

    testWidgets('uses custom fontSize when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SecondaryButton(text: 'Test', fontSize: 20),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Test'));
      expect(textWidget.style?.fontSize, equals(20));
    });

    testWidgets('uses default fontSize when not provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SecondaryButton(text: 'Test'),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Test'));
      expect(textWidget.style?.fontSize, equals(16));
    });

    testWidgets('uses custom height when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SecondaryButton(text: 'Test', height: 64),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.constraints?.maxHeight, equals(64));
    });

    testWidgets('uses default height when not provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SecondaryButton(text: 'Test'),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.constraints?.maxHeight, equals(56));
    });

    testWidgets('has border with primary color', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SecondaryButton(text: 'Test'),
          ),
        ),
      );

      final decoration = tester.widget<Container>(
        find.byType(Container).first,
      ).decoration as BoxDecoration;

      expect(decoration.border, isNotNull);
      expect(decoration.border?.top.color, equals(const Color(0xFF6C63FF)));
    });

    testWidgets('text has primary color', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SecondaryButton(text: 'Test'),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Test'));
      expect(textWidget.style?.color, equals(const Color(0xFF6C63FF)));
    });
  });
}

