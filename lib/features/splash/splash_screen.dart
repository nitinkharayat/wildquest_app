import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../providers/providers.dart';
import '../../routing/app_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});
  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      final complete = ref.read(progressProvider).onboardingComplete;
      context.go(complete ? AppRoutes.home : AppRoutes.onboarding);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFE8F7EE), Color(0xFFF7F8F3), Color(0xFFFFF0E8)],
            ),
          ),
          child: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                width: 104,
                height: 104,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: WildColors.mintDeep.withValues(alpha: .14), blurRadius: 32, spreadRadius: 4)],
                  border: Border.all(color: WildColors.border),
                ),
                child: const Icon(Icons.explore_rounded, size: 52, color: WildColors.mintDeep),
              ),
              const SizedBox(height: 24),
              const Text('WILDQUEST', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, letterSpacing: 3)),
              const SizedBox(height: 7),
              const Text('The game you play by putting your phone away.', style: TextStyle(color: WildColors.inkSoft)),
            ]),
          ),
        ),
      );
}
