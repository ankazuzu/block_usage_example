import 'dart:math';
import 'package:bloc_usage_example/domain/repositories/image_generation_repository.dart';

class ImageGenerationRepositoryImpl implements ImageGenerationRepository {
  final Random _random = Random();

  @override
  Future<String> generate(String prompt) async {
    // Simulate network delay (2-3 seconds)
    final delay = 2000 + _random.nextInt(1000);
    await Future.delayed(Duration(milliseconds: delay));

    // ~50% chance of throwing an exception
    if (_random.nextDouble() < 0.5) {
      throw Exception('Failed to generate image. Please try again.');
    }

    // Return placeholder image path
    return 'https://picsum.photos/400/400';
  }
}
