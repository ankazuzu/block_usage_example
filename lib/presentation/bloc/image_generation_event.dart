import 'package:equatable/equatable.dart';

abstract class ImageGenerationEvent extends Equatable {
  const ImageGenerationEvent();

  @override
  List<Object?> get props => [];
}

class GenerateImageEvent extends ImageGenerationEvent {
  final String prompt;

  const GenerateImageEvent(this.prompt);

  @override
  List<Object?> get props => [prompt];
}

class RetryGenerationEvent extends ImageGenerationEvent {
  const RetryGenerationEvent();
}
