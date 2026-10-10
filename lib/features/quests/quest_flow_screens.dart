import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../models/quest.dart';
import '../../providers/providers.dart';
import '../../routing/app_router.dart';
import '../../widgets/wild_widgets.dart';

class QuestSelectionScreen extends ConsumerStatefulWidget {
  const QuestSelectionScreen({super.key});
  @override
  ConsumerState<QuestSelectionScreen> createState() => _QuestSelectionScreenState();
}

class _QuestSelectionScreenState extends ConsumerState<QuestSelectionScreen> {
  int minutes = 15;
  Difficulty difficulty = Difficulty.easy;
  QuestCategory? category;

  void generate() {
    final quest = ref.read(questGeneratorProvider).generate(minutes: minutes, difficulty: difficulty, category: category);
    ref.read(selectedQuestProvider.notifier).state = quest;
    context.push(AppRoutes.questDetails, extra: quest);
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      appBar: AppBar(title: const Text('Create a quest', style: TextStyle(fontWeight: FontWeight.w900))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Choose your adventure', style: AppTheme.headline),
        const SizedBox(height: 7),
        const Text('Keep the setup short. The real game starts when your phone goes away.', style: TextStyle(color: WildColors.inkSoft, height: 1.45)),
        const SizedBox(height: 24),
        const SectionLabel('Time available'),
        const SizedBox(height: 10),
        Wrap(spacing: 8, children: [for (final m in [10, 15, 20, 30]) ChoiceChip(label: Text('${m}m'), selected: minutes == m, onSelected: (_) => setState(() => minutes = m))]),
        const SizedBox(height: 22),
        const SectionLabel('Difficulty'),
        const SizedBox(height: 10),
        Wrap(spacing: 8, children: [for (final d in Difficulty.values) ChoiceChip(label: Text(d.label), selected: difficulty == d, onSelected: (_) => setState(() => difficulty = d))]),
        const SizedBox(height: 22),
        const SectionLabel('Quest style'),
        const SizedBox(height: 10),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final c in QuestCategory.values) ChoiceChip(label: Text(c.label), selected: category == c, onSelected: (_) => setState(() => category = category == c ? null : c)),
        ]),
        const SizedBox(height: 28),
        SoftCard(color: WildColors.mintPale, child: Row(children: [
          const Icon(Icons.phone_locked_rounded, color: WildColors.mintDeep),
          const SizedBox(width: 12),
          Expanded(child: Text('Pocket Mode is the point: start the quest, put the phone away, and return for the reveal.', style: TextStyle(color: WildColors.ink, height: 1.35, fontWeight: FontWeight.w700))),
        ])),
        const SizedBox(height: 18),
        FilledButton.icon(onPressed: generate, icon: const Icon(Icons.explore_rounded), label: const Text('GENERATE QUEST')),
      ]),
    );
  }
}

class QuestDetailsScreen extends StatelessWidget {
  const QuestDetailsScreen({super.key, required this.quest});
  final Quest quest;

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      appBar: AppBar(title: const Text('Quest details', style: TextStyle(fontWeight: FontWeight.w900))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SoftCard(color: WildColors.lavenderPale, child: Row(children: [
          Container(width: 52, height: 52, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.auto_awesome_rounded, color: WildColors.lavender)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('DISCOVERY QUEST', style: AppTheme.section), const SizedBox(height: 4), Text('+${quest.xpReward} XP', style: const TextStyle(fontWeight: FontWeight.w900))])),
        ])),
        const SizedBox(height: 20),
        Text(quest.title, style: AppTheme.display),
        const SizedBox(height: 10),
        Text(quest.description, style: const TextStyle(color: WildColors.inkSoft, fontSize: 16, height: 1.5)),
        const SizedBox(height: 20),
        SoftCard(child: Column(children: [
          Row(children: [
            Expanded(child: _Detail(icon: Icons.schedule_rounded, label: 'Time', value: '${quest.durationMinutes} min')),
            Expanded(child: _Detail(icon: Icons.route_rounded, label: 'Distance', value: '${quest.distanceMeters} m')),
          ]),
          const Divider(height: 30),
          _Detail(icon: Icons.auto_stories_rounded, label: 'Story', value: quest.story),
        ])),
        const SizedBox(height: 20),
        SoftCard(color: WildColors.peachPale, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('POCKET MODE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.3, color: WildColors.danger)),
          const SizedBox(height: 7),
          const Text('You will only need the phone to start and finish. The experience happens outside.', style: TextStyle(height: 1.45, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          FilledButton(onPressed: () => context.push(AppRoutes.walk, extra: quest), child: const Text('START QUEST')),
        ])),
      ]),
    );
  }
}

class _Detail extends StatelessWidget {
  const _Detail({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, size: 19, color: WildColors.mintDeep),
        const SizedBox(width: 9),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(color: WildColors.inkSoft, fontSize: 11, fontWeight: FontWeight.w800)),
          const SizedBox(height: 3),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800, height: 1.35)),
        ])),
      ]);
}
