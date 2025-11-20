import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_usage_example/domain/repositories/image_generation_repository.dart';
import 'package:bloc_usage_example/presentation/bloc/image_generation_bloc.dart';
import 'package:bloc_usage_example/presentation/bloc/image_generation_event.dart';
import 'package:bloc_usage_example/presentation/bloc/image_generation_state.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([ImageGenerationRepository])
import 'image_generation_bloc_test.mocks.dart';

void main() {
  group('ImageGenerationBloc', () {
    late MockImageGenerationRepository mockRepository;
    late ImageGenerationBloc bloc;

    setUp(() {
      mockRepository = MockImageGenerationRepository();
      bloc = ImageGenerationBloc(mockRepository);
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state is ImageGenerationInitial', () {
      expect(bloc.state, equals(const ImageGenerationInitial()));
      expect(bloc.currentPrompt, isNull);
    });

    blocTest<ImageGenerationBloc, ImageGenerationState>(
      'emits [Loading, Success] when GenerateImageEvent succeeds',
      build: () {
        when(
          mockRepository.generate(any),
        ).thenAnswer((_) async => 'https://picsum.photos/400/400');
        return bloc;
      },
      act: (bloc) => bloc.add(const GenerateImageEvent('test prompt')),
      expect: () => [
        const ImageGenerationLoading(),
        const ImageGenerationSuccess('https://picsum.photos/400/400'),
      ],
      verify: (_) {
        verify(mockRepository.generate('test prompt')).called(1);
        expect(bloc.currentPrompt, equals('test prompt'));
      },
    );

    blocTest<ImageGenerationBloc, ImageGenerationState>(
      'emits [Loading, Error] when GenerateImageEvent fails',
      build: () {
        when(
          mockRepository.generate(any),
        ).thenThrow(Exception('Failed to generate image. Please try again.'));
        return bloc;
      },
      act: (bloc) => bloc.add(const GenerateImageEvent('test prompt')),
      expect: () => [
        const ImageGenerationLoading(),
        const ImageGenerationError(
          'Failed to generate image. Please try again.',
        ),
      ],
      verify: (_) {
        verify(mockRepository.generate('test prompt')).called(1);
        expect(bloc.currentPrompt, equals('test prompt'));
      },
    );

    blocTest<ImageGenerationBloc, ImageGenerationState>(
      'emits [Loading, Success] when RetryGenerationEvent succeeds',
      build: () {
        when(
          mockRepository.generate(any),
        ).thenAnswer((_) async => 'https://picsum.photos/400/400');
        final testBloc = ImageGenerationBloc(mockRepository);
        // First generate to set currentPrompt
        testBloc.add(const GenerateImageEvent('test prompt'));
        return testBloc;
      },
      wait: const Duration(milliseconds: 50),
      act: (bloc) => bloc.add(const RetryGenerationEvent()),
      skip: 2, // Skip initial Loading and Success from build
      expect: () => [
        const ImageGenerationLoading(),
        const ImageGenerationSuccess('https://picsum.photos/400/400'),
      ],
      verify: (_) {
        verify(
          mockRepository.generate('test prompt'),
        ).called(2); // Once for initial, once for retry
      },
    );

    blocTest<ImageGenerationBloc, ImageGenerationState>(
      'does not emit when RetryGenerationEvent called without prompt',
      build: () => bloc,
      act: (bloc) => bloc.add(const RetryGenerationEvent()),
      expect: () => [],
      verify: (_) {
        verifyNever(mockRepository.generate(any));
      },
    );

    blocTest<ImageGenerationBloc, ImageGenerationState>(
      'emits [Loading, Error] when RetryGenerationEvent fails',
      build: () {
        when(
          mockRepository.generate(any),
        ).thenThrow(Exception('Network error'));
        final testBloc = ImageGenerationBloc(mockRepository);
        // First generate to set currentPrompt
        testBloc.add(const GenerateImageEvent('test prompt'));
        return testBloc;
      },
      wait: const Duration(milliseconds: 50),
      act: (bloc) => bloc.add(const RetryGenerationEvent()),
      skip: 2, // Skip initial Loading and Error from build
      expect: () => [
        const ImageGenerationLoading(),
        const ImageGenerationError('Network error'),
      ],
    );

    test('currentPrompt returns null initially', () {
      expect(bloc.currentPrompt, isNull);
    });

    test('currentPrompt returns prompt after GenerateImageEvent', () async {
      when(
        mockRepository.generate(any),
      ).thenAnswer((_) async => 'https://picsum.photos/400/400');

      bloc.add(const GenerateImageEvent('test prompt'));
      await bloc.stream.first;

      expect(bloc.currentPrompt, equals('test prompt'));
    });
  });
}
