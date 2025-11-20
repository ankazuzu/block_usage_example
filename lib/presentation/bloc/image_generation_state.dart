import 'package:equatable/equatable.dart';

abstract class ImageGenerationState extends Equatable {
  const ImageGenerationState();

  @override
  List<Object?> get props => [];
}

class ImageGenerationInitial extends ImageGenerationState {
  const ImageGenerationInitial();
}

class ImageGenerationLoading extends ImageGenerationState {
  const ImageGenerationLoading();
}

class ImageGenerationSuccess extends ImageGenerationState {
  final String imageUrl;

  const ImageGenerationSuccess(this.imageUrl);

  @override
  List<Object?> get props => [imageUrl];
}

class ImageGenerationError extends ImageGenerationState {
  final String message;

  const ImageGenerationError(this.message);

  @override
  List<Object?> get props => [message];
}
