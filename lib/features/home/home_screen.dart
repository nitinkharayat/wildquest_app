import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/creature_catalog.dart';
import '../../providers/providers.dart';
import '../../routing/app_router.dart';
import '../../widgets/wild_widgets.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(progressProvider);
    final companion = CreatureCatalog.byId(p.discoveredCreatures.firstOrNull ?? 'mossling');
    final need = 300 + (p.level - 1) * 250;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                Text('WILDQUEST', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 2, color: WildColors.mintDeep)),
                SizedBox(height: 5),
                Text('Ready to explore?', style: AppTheme.display),
              ]),
              const Spacer(),
              IconButton(onPressed: () => context.push(AppRoutes.settings), icon: const Icon(Icons.tune_rounded)),
            ]),
            const SizedBox(height: 22),
            SoftCard(
              color: WildColors.ink,
              padding: const EdgeInsets.all(22),
              child: Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('YOUR NEXT ADVENTURE', style: TextStyle(color: Color(0xFFBFE7CF), fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.4)),
                  const SizedBox(height: 9),
                  const Text('A fresh quest is waiting outside.', style: TextStyle(color: Colors.white, fontSize: 22, height: 1.15, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 17),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: WildColors.ink),
                    onPressed: () => context.push(AppRoutes.quests),
                    icon: const Icon(Icons.explore_rounded),
                    label: const Text('CREATE QUEST'),
                  ),
                ])),
                const SizedBox(width: 10),
                CreatureAvatar(creature: companion, size: 92),
              ]),
            ),
            const SizedBox(height: 18),
            SoftCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text('Explorer Level ${p.level}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                const Spacer(),
                Text('${p.xp}/$need XP', style: const TextStyle(color: WildColors.inkSoft, fontWeight: FontWeight.w700, fontSize: 12)),
              ]),
              const SizedBox(height: 12),
              ProgressBar(value: p.xp / need),
              const SizedBox(height: 8),
              Text('${need - p.xp} XP to level ${p.level + 1}', style: const TextStyle(color: WildColors.inkSoft, fontSize: 12)),
            ])),
            const SizedBox(height: 18),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.42,
              children: [
                StatCard(label: 'Outdoor distance', value: formatDistance(p.totalDistanceMeters), icon: Icons.route_rounded, color: WildColors.mintDeep),
                StatCard(label: 'Screen-free time', value: formatMinutes(p.totalScreenFreeMinutes), icon: Icons.phone_locked_rounded, color: WildColors.sky),
                StatCard(label: 'Quests completed', value: '${p.questsCompleted}', icon: Icons.flag_rounded, color: WildColors.peach),
                StatCard(label: 'Creatures found', value: '${p.discoveredCreatures.length}/6', icon: Icons.auto_awesome_rounded, color: WildColors.lavender),
              ],
            ),
            const SizedBox(height: 22),
            const SectionLabel('Keep exploring'),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: OutlinedButton.icon(onPressed: () => context.push(AppRoutes.collection), icon: const Icon(Icons.grid_view_rounded), label: const Text('COLLECTION'))),
              const SizedBox(width: 10),
              Expanded(child: OutlinedButton.icon(onPressed: () => context.push(AppRoutes.progress), icon: const Icon(Icons.insights_rounded), label: const Text('PROGRESS'))),
            ]),
          ]),
        ),
      ),
    );
  }
}

extension _FirstOrNull<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
