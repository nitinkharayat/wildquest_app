import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../models/quest.dart';
import '../../providers/providers.dart';
import '../../routing/app_router.dart';
import '../../widgets/wild_widgets.dart';

class WalkingScreen extends ConsumerStatefulWidget {
  const WalkingScreen({super.key, required this.quest});
  final Quest quest;
  @override
  ConsumerState<WalkingScreen> createState() => _WalkingScreenState();
}

class _WalkingScreenState extends ConsumerState<WalkingScreen> {
  Timer? timer;
  bool started = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(walkProvider.notifier).start(widget.quest);
      started = true;
      timer = Timer.periodic(const Duration(seconds: 1), (_) => ref.read(walkProvider.notifier).tick());
      if (mounted) setState(() {});
    });
  }

  Future<void> finish() async {
    await ref.read(walkProvider.notifier).complete();
    if (mounted) context.go(AppRoutes.complete);
  }

  @override
  Widget build(BuildContext context) {
    final walk = ref.watch(walkProvider);
    final progress = walk.progress;
    final complete = progress >= 1;
    return Scaffold(
      backgroundColor: const Color(0xFFF0F5EF),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
              child: Column(children: [
                Row(children: [
                  const Text('POCKET MODE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.5, color: WildColors.mintDeep)),
                  const Spacer(),
                  IconButton(onPressed: () { ref.read(walkProvider.notifier).reset(); context.go(AppRoutes.home); }, icon: const Icon(Icons.close_rounded)),
                ]),
                const Spacer(),
                Container(width: 100, height: 100, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white), child: const Icon(Icons.phone_locked_rounded, size: 50, color: WildColors.mintDeep)),
                const SizedBox(height: 24),
                const Text('PHONE IN POCKET', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 1.8)),
                const SizedBox(height: 10),
                Text(widget.quest.title, textAlign: TextAlign.center, style: AppTheme.display),
                const SizedBox(height: 12),
                const Text('Keep exploring. The game will be here when you return.', textAlign: TextAlign.center, style: TextStyle(color: WildColors.inkSoft, fontSize: 16, height: 1.45)),
                const SizedBox(height: 30),
                SoftCard(child: Column(children: [
                  Row(children: [
                    Expanded(child: _Metric(label: 'Elapsed', value: formatDuration(Duration(seconds: walk.seconds)), icon: Icons.timer_outlined)),
                    Expanded(child: _Metric(label: 'Distance', value: formatDistance(walk.meters), icon: Icons.route_rounded)),
                  ]),
                  const SizedBox(height: 20),
                  ProgressBar(value: progress),
                  const SizedBox(height: 8),
                  Align(alignment: Alignment.centerRight, child: Text('${(progress * 100).round()}% complete', style: const TextStyle(color: WildColors.inkSoft, fontSize: 12, fontWeight: FontWeight.w700))),
                ])),
                const SizedBox(height: 18),
                FilledButton(onPressed: (!started || !complete) ? null : finish, child: Text(complete ? 'REVEAL REWARD' : 'KEEP EXPLORING')),
                const SizedBox(height: 10),
                if (started && walk.seconds >= 3 && !complete)
                  OutlinedButton.icon(
                    onPressed: finish,
                    icon: const Icon(Icons.fast_forward_rounded),
                    label: const Text('COMPLETE DEMO'),
                  ),
                const SizedBox(height: 10),
                const Text('Prototype mode uses simulated walking so the full loop can be tested indoors.', style: TextStyle(color: WildColors.inkSoft, fontSize: 11), textAlign: TextAlign.center),
                const Spacer(),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}

class QuestCompleteScreen extends ConsumerWidget {
  const QuestCompleteScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walk = ref.watch(walkProvider);
    return PageScaffold(child: Column(children: [
      const SizedBox(height: 60),
      Container(width: 92, height: 92, decoration: const BoxDecoration(shape: BoxShape.circle, color: WildColors.mintPale), child: const Icon(Icons.check_rounded, size: 52, color: WildColors.mintDeep)),
      const SizedBox(height: 24),
      const Text('QUEST COMPLETE', style: AppTheme.display, textAlign: TextAlign.center),
      const SizedBox(height: 10),
      Text('You left the screen behind and kept moving.', textAlign: TextAlign.center, style: const TextStyle(color: WildColors.inkSoft, fontSize: 16)),
      const SizedBox(height: 24),
      SoftCard(child: Row(children: [Expanded(child: _Metric(label: 'Time', value: formatDuration(Duration(seconds: walk.seconds)), icon: Icons.timer_outlined)), Expanded(child: _Metric(label: 'Distance', value: formatDistance(walk.meters), icon: Icons.route_rounded))])),
      const SizedBox(height: 22),
      FilledButton(onPressed: () => context.go(AppRoutes.reward), child: const Text('SEE YOUR DISCOVERY')),
    ]));
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value, required this.icon});
  final String label;
  final String value;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Column(children: [Icon(icon, color: WildColors.mintDeep, size: 20), const SizedBox(height: 7), Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)), const SizedBox(height: 2), Text(label, style: const TextStyle(color: WildColors.inkSoft, fontSize: 11, fontWeight: FontWeight.w700))]);
}
