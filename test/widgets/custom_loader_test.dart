import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_usage_example/presentation/widgets/custom_loader.dart';

void main() {
  group('CustomLoader', () {
    testWidgets('displays default message', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CustomLoader())),
      );

      expect(find.text('Generating your image...'), findsOneWidget);
    });

    testWidgets('displays custom message when provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CustomLoader(message: 'Loading...')),
        ),
      );

      expect(find.text('Loading...'), findsOneWidget);
    });

    testWidgets('displays loading icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CustomLoader())),
      );

      expect(find.byIcon(Icons.auto_awesome), findsOneWidget);
    });

    testWidgets('has circular container with gradient', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CustomLoader())),
      );

      // Find container with BoxDecoration that has circle shape
      Container? circleContainer;
      for (var widget in tester.allWidgets) {
        if (widget is Container &&
            widget.decoration != null &&
            widget.decoration is BoxDecoration) {
          final decoration = widget.decoration as BoxDecoration;
          if (decoration.shape == BoxShape.circle &&
              decoration.gradient != null) {
            circleContainer = widget;
          }
        }
      }

      expect(circleContainer, isNotNull);
      final decoration = circleContainer!.decoration as BoxDecoration;
      expect(decoration.shape, equals(BoxShape.circle));
      expect(decoration.gradient, isNotNull);
    });

    testWidgets('has semi-transparent background', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CustomLoader())),
      );

      final rootContainer = tester.widget<Container>(
        find.byType(Container).first,
      );

      expect(rootContainer.color, isNotNull);
    });

    testWidgets('centers content', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CustomLoader())),
      );

      final centers = find.byType(Center);
      expect(centers, findsWidgets);

      final columns = find.byType(Column);
      expect(columns, findsWidgets);
    });
  });
}
