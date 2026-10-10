import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../data/creature_catalog.dart';
import '../../providers/providers.dart';
import '../../widgets/wild_widgets.dart';
import '../../routing/app_router.dart';

class CollectionScreen extends ConsumerWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final owned = ref.watch(progressProvider).discoveredCreatures.toSet();
    return PageScaffold(
      appBar: AppBar(title: const Text('Creature collection', style: TextStyle(fontWeight: FontWeight.w900))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SoftCard(color: WildColors.lavenderPale, child: Row(children: [
          const Icon(Icons.auto_awesome_rounded, color: WildColors.lavender),
          const SizedBox(width: 10),
          Text('${owned.length}/${CreatureCatalog.all.length} discovered', style: const TextStyle(fontWeight: FontWeight.w900)),
        ])),
        const SizedBox(height: 18),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: CreatureCatalog.all.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: .88),
          itemBuilder: (_, index) {
            final creature = CreatureCatalog.all[index];
            final unlocked = owned.contains(creature.id);
            return InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: unlocked ? () => context.push(AppRoutes.creature, extra: creature.id) : null,
              child: SoftCard(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                CreatureAvatar(creature: creature, size: 92),
                const SizedBox(height: 12),
                Text(unlocked ? creature.name : 'Undiscovered', style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(unlocked ? creature.rarity.label : '???', style: TextStyle(color: unlocked ? rarityColor(creature.rarity) : WildColors.inkSoft, fontSize: 12, fontWeight: FontWeight.w800)),
              ])),
            );
          },
        ),
      ]),
    );
  }
}

class CreatureDetailScreen extends StatelessWidget {
  const CreatureDetailScreen({super.key, required this.creatureId});
  final String creatureId;
  @override
  Widget build(BuildContext context) {
    final c = CreatureCatalog.byId(creatureId);
    return PageScaffold(
      appBar: AppBar(title: const Text('Creature', style: TextStyle(fontWeight: FontWeight.w900))),
      child: Column(children: [
        const SizedBox(height: 22),
        CreatureAvatar(creature: c, size: 190),
        const SizedBox(height: 22),
        Text(c.name, style: AppTheme.display, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text('${c.rarity.label} • ${c.element}', style: TextStyle(color: rarityColor(c.rarity), fontWeight: FontWeight.w900)),
        const SizedBox(height: 15),
        Text(c.description, textAlign: TextAlign.center, style: const TextStyle(color: WildColors.inkSoft, fontSize: 16, height: 1.5)),
        const SizedBox(height: 22),
        SoftCard(color: WildColors.mintPale, child: const Row(children: [Icon(Icons.eco_rounded, color: WildColors.mintDeep), SizedBox(width: 10), Expanded(child: Text('Every creature starts with one real-world discovery: you chose to go outside.', style: TextStyle(fontWeight: FontWeight.w700, height: 1.4)))])),
      ]),
    );
  }
}
