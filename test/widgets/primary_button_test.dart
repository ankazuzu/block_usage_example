import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_usage_example/presentation/widgets/primary_button.dart';

void main() {
  group('PrimaryButton', () {
    testWidgets('displays correct text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PrimaryButton(text: 'Test Button'),
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
            body: PrimaryButton(
              text: 'Test Button',
              onPressed: () {
                wasPressed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(PrimaryButton));
      await tester.pumpAndSettle();

      expect(wasPressed, isTrue);
    });

    testWidgets('does not call onPressed when disabled', (WidgetTester tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Test Button',
              onPressed: null,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(PrimaryButton));
      await tester.pumpAndSettle();

      expect(wasPressed, isFalse);
    });

    testWidgets('uses custom fontSize when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PrimaryButton(text: 'Test', fontSize: 20),
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
            body: PrimaryButton(text: 'Test'),
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
            body: PrimaryButton(text: 'Test', height: 64),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(PrimaryButton),
          matching: find.byType(Container),
        ).first,
      );

      expect(container.constraints?.maxHeight, equals(64));
    });

    testWidgets('uses default height when not provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PrimaryButton(text: 'Test'),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(PrimaryButton),
          matching: find.byType(Container),
        ).first,
      );

      expect(container.constraints?.maxHeight, equals(56));
    });

    testWidgets('has gradient when enabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(text: 'Test', onPressed: () {}),
          ),
        ),
      );

      final decoration = tester.widget<Container>(
        find.descendant(
          of: find.byType(PrimaryButton),
          matching: find.byType(Container),
        ).first,
      ).decoration as BoxDecoration;

      expect(decoration.gradient, isNotNull);
      expect(decoration.color, isNull);
    });

    testWidgets('has solid color when disabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PrimaryButton(text: 'Test', onPressed: null),
          ),
        ),
      );

      final decoration = tester.widget<Container>(
        find.descendant(
          of: find.byType(PrimaryButton),
          matching: find.byType(Container),
        ).first,
      ).decoration as BoxDecoration;

      expect(decoration.gradient, isNull);
      expect(decoration.color, isNotNull);
    });
  });
}

