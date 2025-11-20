import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_usage_example/presentation/bloc/image_generation_event.dart';

void main() {
  group('ImageGenerationEvent', () {
    test('GenerateImageEvent is equal when prompts match', () {
      const event1 = GenerateImageEvent('test prompt');
      const event2 = GenerateImageEvent('test prompt');

      expect(event1, equals(event2));
      expect(event1.hashCode, equals(event2.hashCode));
    });

    test('GenerateImageEvent is not equal when prompts differ', () {
      const event1 = GenerateImageEvent('prompt 1');
      const event2 = GenerateImageEvent('prompt 2');

      expect(event1, isNot(equals(event2)));
    });

    test('RetryGenerationEvent instances are equal', () {
      const event1 = RetryGenerationEvent();
      const event2 = RetryGenerationEvent();

      expect(event1, equals(event2));
      expect(event1.hashCode, equals(event2.hashCode));
    });

    test('different event types are not equal', () {
      const generateEvent = GenerateImageEvent('test');
      const retryEvent = RetryGenerationEvent();

      expect(generateEvent, isNot(equals(retryEvent)));
    });
  });
}

