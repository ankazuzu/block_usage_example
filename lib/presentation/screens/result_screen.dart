import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:bloc_usage_example/presentation/bloc/image_generation_bloc.dart';
import 'package:bloc_usage_example/presentation/bloc/image_generation_event.dart';
import 'package:bloc_usage_example/presentation/bloc/image_generation_state.dart';
import 'package:bloc_usage_example/presentation/widgets/primary_button.dart';
import 'package:bloc_usage_example/presentation/widgets/secondary_button.dart';
import 'package:bloc_usage_example/presentation/widgets/custom_loader.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<ImageGenerationBloc>();
      final state = bloc.state;
      final prompt = bloc.currentPrompt;

      if (prompt == null) {
        context.go('/');
        return;
      }

      if (state is ImageGenerationInitial) {
        bloc.add(GenerateImageEvent(prompt));
      }
    });
  }

  void _handleTryAnother() {
    final bloc = context.read<ImageGenerationBloc>();
    if (bloc.currentPrompt != null) {
      bloc.add(RetryGenerationEvent());
    }
  }

  void _handleNewPrompt() {
    final bloc = context.read<ImageGenerationBloc>();
    final prompt = bloc.currentPrompt;
    if (prompt != null) {
      context.go('/?prompt=${Uri.encodeComponent(prompt)}');
    } else {
      context.go('/');
    }
  }

  void _handleRetry() {
    final bloc = context.read<ImageGenerationBloc>();
    if (bloc.currentPrompt != null) {
      bloc.add(RetryGenerationEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
          onPressed: () => context.go('/'),
        ),
        title: const Text(
          'AI Image Generator',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<ImageGenerationBloc, ImageGenerationState>(
        builder: (context, state) {
          if (state is ImageGenerationLoading) {
            return const CustomLoader();
          }

          if (state is ImageGenerationError) {
            return _ErrorView(
              message: state.message,
              onRetry: _handleRetry,
              onNewPrompt: _handleNewPrompt,
            );
          }

          if (state is ImageGenerationSuccess) {
            return _SuccessView(
              imageUrl: state.imageUrl,
              prompt: context.read<ImageGenerationBloc>().currentPrompt ?? '',
              onTryAnother: _handleTryAnother,
              onNewPrompt: _handleNewPrompt,
            );
          }

          return const CustomLoader();
        },
      ),
    );
  }
}

class _SuccessView extends StatefulWidget {
  final String imageUrl;
  final String prompt;
  final VoidCallback onTryAnother;
  final VoidCallback onNewPrompt;

  const _SuccessView({
    required this.imageUrl,
    required this.prompt,
    required this.onTryAnother,
    required this.onNewPrompt,
  });

  @override
  State<_SuccessView> createState() => _SuccessViewState();
}

class _SuccessViewState extends State<_SuccessView>
    with TickerProviderStateMixin {
  late AnimationController _imageController;
  late AnimationController _buttonsController;
  late Animation<double> _imageScaleAnimation;
  late Animation<double> _imageOpacityAnimation;
  late Animation<double> _buttonsOpacityAnimation;

  @override
  void initState() {
    super.initState();

    _imageController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _imageScaleAnimation = Tween<double>(
      begin: 0.96,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _imageController, curve: Curves.easeOut));

    _imageOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _imageController, curve: Curves.easeOut));

    _buttonsController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _buttonsOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonsController, curve: Curves.easeOut),
    );

    _imageController.forward();
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        _buttonsController.forward();
      }
    });
  }

  @override
  void dispose() {
    _imageController.dispose();
    _buttonsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FadeTransition(
              opacity: _imageOpacityAnimation,
              child: ScaleTransition(
                scale: _imageScaleAnimation,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: const Color(0xFF6C63FF).withValues(alpha: 0.1),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                          child: Image.network(
                            widget.imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: 400,
                                color: const Color(0xFFF7F7FA),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value:
                                        loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes!
                                        : null,
                                    color: const Color(0xFF6C63FF),
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 400,
                                color: const Color(0xFFF7F7FA),
                                child: const Center(
                                  child: Icon(
                                    Icons.error_outline,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            FadeTransition(
              opacity: _buttonsOpacityAnimation,
              child: Column(
                children: [
                  PrimaryButton(
                    text: 'Try another',
                    onPressed: widget.onTryAnother,
                    height: 56,
                  ),
                  const SizedBox(height: 16),
                  SecondaryButton(
                    text: 'New prompt',
                    onPressed: widget.onNewPrompt,
                    height: 56,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final VoidCallback onNewPrompt;

  const _ErrorView({
    required this.message,
    required this.onRetry,
    required this.onNewPrompt,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFF4D4F).withValues(alpha: 0.1),
              ),
              child: Icon(
                Icons.error_outline,
                size: 48,
                color: const Color(0xFFFF4D4F).withValues(alpha: 0.9),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please try again.',
              style: TextStyle(
                fontSize: 16,
                color: const Color(0xFF1A1A1A).withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: 'Retry',
                onPressed: onRetry,
                height: 56,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: onNewPrompt,
              child: const Text(
                'New prompt',
                style: TextStyle(fontSize: 16, color: Color(0xFF6C63FF)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
