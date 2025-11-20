import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_usage_example/presentation/bloc/image_generation_state.dart';

void main() {
  group('ImageGenerationState', () {
    test('ImageGenerationInitial is equal to another ImageGenerationInitial', () {
      const state1 = ImageGenerationInitial();
      const state2 = ImageGenerationInitial();

      expect(state1, equals(state2));
      expect(state1.hashCode, equals(state2.hashCode));
    });

    test('ImageGenerationLoading is equal to another ImageGenerationLoading', () {
      const state1 = ImageGenerationLoading();
      const state2 = ImageGenerationLoading();

      expect(state1, equals(state2));
      expect(state1.hashCode, equals(state2.hashCode));
    });

    test('ImageGenerationSuccess is equal when URLs match', () {
      const state1 = ImageGenerationSuccess('https://example.com/image.jpg');
      const state2 = ImageGenerationSuccess('https://example.com/image.jpg');

      expect(state1, equals(state2));
      expect(state1.hashCode, equals(state2.hashCode));
    });

    test('ImageGenerationSuccess is not equal when URLs differ', () {
      const state1 = ImageGenerationSuccess('https://example.com/image1.jpg');
      const state2 = ImageGenerationSuccess('https://example.com/image2.jpg');

      expect(state1, isNot(equals(state2)));
    });

    test('ImageGenerationError is equal when messages match', () {
      const state1 = ImageGenerationError('Error message');
      const state2 = ImageGenerationError('Error message');

      expect(state1, equals(state2));
      expect(state1.hashCode, equals(state2.hashCode));
    });

    test('ImageGenerationError is not equal when messages differ', () {
      const state1 = ImageGenerationError('Error 1');
      const state2 = ImageGenerationError('Error 2');

      expect(state1, isNot(equals(state2)));
    });

    test('different state types are not equal', () {
      const initial = ImageGenerationInitial();
      const loading = ImageGenerationLoading();
      const success = ImageGenerationSuccess('url');
      const error = ImageGenerationError('error');

      expect(initial, isNot(equals(loading)));
      expect(loading, isNot(equals(success)));
      expect(success, isNot(equals(error)));
      expect(error, isNot(equals(initial)));
    });
  });
}

