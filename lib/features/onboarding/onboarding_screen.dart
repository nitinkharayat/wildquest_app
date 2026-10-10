import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../providers/providers.dart';
import '../../routing/app_router.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});
  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final controller = PageController();
  int index = 0;
  final slides = const [
    ('Meet WildQuest', 'A real-world adventure game where movement becomes your progress.', Icons.explore_rounded, Color(0xFFE7F7EE)),
    ('Choose a quest', 'Pick a short walk, a discovery challenge, or let the world surprise you.', Icons.route_rounded, Color(0xFFEAF5FC)),
    ('Put your phone away', 'Start Pocket Mode, put the screen down, and let the walk become the game.', Icons.phone_locked_rounded, Color(0xFFFFF0E8)),
    ('Come back for the reveal', 'Finish your walk and unlock creatures, XP, achievements, and your next adventure.', Icons.auto_awesome_rounded, Color(0xFFF1EEFD)),
  ];

  Future<void> finish() async {
    await ref.read(progressProvider.notifier).finishOnboarding();
    if (mounted) context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final last = index == slides.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            child: Row(children: [
              const Text('WILDQUEST', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2)),
              const Spacer(),
              Text('${index + 1}/${slides.length}', style: const TextStyle(color: WildColors.inkSoft, fontWeight: FontWeight.w700)),
            ]),
          ),
          Expanded(
            child: PageView.builder(
              controller: controller,
              itemCount: slides.length,
              onPageChanged: (value) => setState(() => index = value),
              itemBuilder: (_, i) {
                final slide = slides[i];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(26, 22, 26, 20),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                      width: 190,
                      height: 190,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: slide.$4, border: Border.all(color: Colors.white, width: 5)),
                      child: Icon(slide.$3, size: 78, color: WildColors.ink),
                    ),
                    const SizedBox(height: 44),
                    Text(slide.$1, textAlign: TextAlign.center, style: AppTheme.display),
                    const SizedBox(height: 15),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: Text(slide.$2, textAlign: TextAlign.center, style: const TextStyle(color: WildColors.inkSoft, fontSize: 17, height: 1.55)),
                    ),
                  ]),
                );
              },
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            for (var i = 0; i < slides.length; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: i == index ? 28 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(color: i == index ? WildColors.mintDeep : WildColors.border, borderRadius: BorderRadius.circular(99)),
              ),
          ]),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: FilledButton(
              onPressed: last ? finish : () => controller.nextPage(duration: const Duration(milliseconds: 280), curve: Curves.easeOut),
              child: Text(last ? 'START ADVENTURE' : 'CONTINUE'),
            ),
          ),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
