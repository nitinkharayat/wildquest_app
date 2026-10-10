import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/creature_catalog.dart';
import '../../providers/providers.dart';
import '../../routing/app_router.dart';
import '../../widgets/wild_widgets.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(progressProvider);
    final need = 300 + (p.level - 1) * 250;
    return PageScaffold(appBar: AppBar(title: const Text('Progress', style: TextStyle(fontWeight: FontWeight.w900))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SoftCard(color: WildColors.mintPale, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('EXPLORER LEVEL', style: AppTheme.section),
        const SizedBox(height: 4),
        Text('${p.level}', style: const TextStyle(fontSize: 52, fontWeight: FontWeight.w900)),
        const SizedBox(height: 10),
        ProgressBar(value: p.xp / need),
        const SizedBox(height: 8),
        Text('${p.xp}/$need XP toward the next level', style: const TextStyle(color: WildColors.inkSoft, fontWeight: FontWeight.w700, fontSize: 12)),
      ])),
      const SizedBox(height: 18),
      const SectionLabel('Your milestones'),
      const SizedBox(height: 10),
      GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.45, children: [
        StatCard(label: 'Outdoor distance', value: formatDistance(p.totalDistanceMeters), icon: Icons.route_rounded, color: WildColors.mintDeep),
        StatCard(label: 'Screen-free time', value: formatMinutes(p.totalScreenFreeMinutes), icon: Icons.phone_locked_rounded, color: WildColors.sky),
        StatCard(label: 'Quests completed', value: '${p.questsCompleted}', icon: Icons.flag_rounded, color: WildColors.peach),
        StatCard(label: 'Outdoor streak', value: '${p.streakDays} days', icon: Icons.local_fire_department_rounded, color: WildColors.lavender),
      ]),
      const SizedBox(height: 20),
      SoftCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Collection progress', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        const SizedBox(height: 10),
        ProgressBar(value: p.discoveredCreatures.length / CreatureCatalog.all.length, foreground: WildColors.lavender),
        const SizedBox(height: 9),
        Text('${p.discoveredCreatures.length} of ${CreatureCatalog.all.length} creatures discovered', style: const TextStyle(color: WildColors.inkSoft, fontWeight: FontWeight.w700, fontSize: 12)),
      ])),
    ]));
  }
}

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(progressProvider);
    return PageScaffold(appBar: AppBar(title: const Text('Quest history', style: TextStyle(fontWeight: FontWeight.w900))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionLabel('Recent activity'),
      const SizedBox(height: 10),
      if (p.questsCompleted == 0) const Padding(padding: EdgeInsets.only(top: 80), child: EmptyState(icon: Icons.history_rounded, title: 'No quests yet', message: 'Your first adventure will appear here.'))
      else ...[
        _HistoryTile(title: 'The Hidden Grove', meta: '15 min • 0.8 km', color: WildColors.mintPale, icon: Icons.eco_rounded),
        _HistoryTile(title: 'Quiet Reset', meta: '10 min • 0.6 km', color: WildColors.skyPale, icon: Icons.self_improvement_rounded),
      ],
      const SizedBox(height: 18),
      OutlinedButton.icon(onPressed: () => context.push(AppRoutes.collection), icon: const Icon(Icons.auto_awesome_rounded), label: const Text('VIEW COLLECTION')),
    ]));
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.title, required this.meta, required this.color, required this.icon});
  final String title;
  final String meta;
  final Color color;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 10), child: SoftCard(child: Row(children: [Container(width: 46, height: 46, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)), child: Icon(icon, color: WildColors.ink)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 4), Text(meta, style: const TextStyle(color: WildColors.inkSoft, fontSize: 12, fontWeight: FontWeight.w700))])), const Icon(Icons.check_circle_rounded, color: WildColors.mintDeep)])));
}
