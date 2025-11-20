import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_usage_example/presentation/router/app_router.dart';
import 'package:bloc_usage_example/presentation/bloc/image_generation_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ImageGenerationBloc>(
      create: (_) => imageGenerationBloc,
      child: MaterialApp.router(
        title: 'Image Generator',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.light(
            primary: const Color(0xFF6C63FF),
            surface: Colors.white,
            error: const Color(0xFFFF4D4F),
            onPrimary: Colors.white,
            onSurface: const Color(0xFF1A1A1A),
            onError: Colors.white,
          ),
          scaffoldBackgroundColor: const Color(0xFFF7F7FA),
          useMaterial3: true,
          fontFamily: 'SF Pro',
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Color(0xFF1A1A1A), fontSize: 16),
            bodyMedium: TextStyle(color: Color(0xFF1A1A1A), fontSize: 14),
          ),
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            },
          ),
        ),
        routerConfig: appRouter,
      ),
    );
  }
}
