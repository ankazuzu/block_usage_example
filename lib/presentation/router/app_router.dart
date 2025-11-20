import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bloc_usage_example/presentation/screens/prompt_screen.dart';
import 'package:bloc_usage_example/presentation/screens/result_screen.dart';
import 'package:bloc_usage_example/presentation/bloc/image_generation_bloc.dart';
import 'package:bloc_usage_example/data/repositories/image_generation_repository_impl.dart';
import 'package:bloc_usage_example/domain/repositories/image_generation_repository.dart';

final ImageGenerationRepository _imageGenerationRepository =
    ImageGenerationRepositoryImpl();

final ImageGenerationBloc _imageGenerationBloc = ImageGenerationBloc(
  _imageGenerationRepository,
);

class FadeSlidePage extends Page<void> {
  final Widget child;

  const FadeSlidePage({required this.child, super.key});

  @override
  Route<void> createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0.0, 0.1),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOut),
                ),
            child: child,
          ),
        );
      },
    );
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) {
        final prompt = state.uri.queryParameters['prompt'];
        return FadeSlidePage(
          key: state.pageKey,
          child: PromptScreen(initialPrompt: prompt),
        );
      },
    ),
    GoRoute(
      path: '/result',
      pageBuilder: (context, state) {
        return FadeSlidePage(key: state.pageKey, child: const ResultScreen());
      },
    ),
  ],
);

ImageGenerationBloc get imageGenerationBloc => _imageGenerationBloc;
