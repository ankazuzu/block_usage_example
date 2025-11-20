import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_usage_example/domain/repositories/image_generation_repository.dart';
import 'package:bloc_usage_example/presentation/bloc/image_generation_event.dart';
import 'package:bloc_usage_example/presentation/bloc/image_generation_state.dart';

class ImageGenerationBloc
    extends Bloc<ImageGenerationEvent, ImageGenerationState> {
  final ImageGenerationRepository _repository;
  String? _currentPrompt;

  ImageGenerationBloc(this._repository)
    : super(const ImageGenerationInitial()) {
    on<GenerateImageEvent>(_onGenerateImage);
    on<RetryGenerationEvent>(_onRetryGeneration);
  }

  String? get currentPrompt => _currentPrompt;

  Future<void> _onGenerateImage(
    GenerateImageEvent event,
    Emitter<ImageGenerationState> emit,
  ) async {
    _currentPrompt = event.prompt;
    emit(const ImageGenerationLoading());

    try {
      final imageUrl = await _repository.generate(event.prompt);
      emit(ImageGenerationSuccess(imageUrl));
    } catch (e) {
      emit(
        ImageGenerationError(
          e is Exception
              ? e.toString().replaceFirst('Exception: ', '')
              : 'An error occurred',
        ),
      );
    }
  }

  Future<void> _onRetryGeneration(
    RetryGenerationEvent event,
    Emitter<ImageGenerationState> emit,
  ) async {
    if (_currentPrompt == null) return;

    emit(const ImageGenerationLoading());

    try {
      final imageUrl = await _repository.generate(_currentPrompt!);
      emit(ImageGenerationSuccess(imageUrl));
    } catch (e) {
      emit(
        ImageGenerationError(
          e is Exception
              ? e.toString().replaceFirst('Exception: ', '')
              : 'An error occurred',
        ),
      );
    }
  }
}
