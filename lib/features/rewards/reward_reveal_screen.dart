import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../data/creature_catalog.dart';
import '../../providers/providers.dart';
import '../../routing/app_router.dart';
import '../../widgets/wild_widgets.dart';

class RewardRevealScreen extends ConsumerStatefulWidget {
  const RewardRevealScreen({super.key});
  @override
  ConsumerState<RewardRevealScreen> createState() => _RewardRevealScreenState();
}

class _RewardRevealScreenState extends ConsumerState<RewardRevealScreen> {
  bool show = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 250), () { if (mounted) setState(() => show = true); });
  }

  @override
  Widget build(BuildContext context) {
    final walk = ref.watch(walkProvider);
    final progress = ref.watch(progressProvider);
    final creatureId = progress.discoveredCreatures.isNotEmpty ? progress.discoveredCreatures.last : 'mossling';
    final creature = CreatureCatalog.byId(creatureId);
    return PageScaffold(child: Column(children: [
      const SizedBox(height: 20),
      SoftCard(color: WildColors.lemonPale, child: Row(mainAxisSize: MainAxisSize.min, children: const [Icon(Icons.auto_awesome_rounded, color: Color(0xFF9B7B18)), SizedBox(width: 8), Text('DISCOVERY UNLOCKED', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.1))])),
      const SizedBox(height: 30),
      AnimatedScale(scale: show ? 1 : .7, duration: const Duration(milliseconds: 650), curve: Curves.easeOutBack, child: CreatureAvatar(creature: creature, size: 180)),
      const SizedBox(height: 20),
      Text('YOU DISCOVERED', style: AppTheme.section),
      const SizedBox(height: 6),
      Text(creature.name, style: AppTheme.display, textAlign: TextAlign.center),
      const SizedBox(height: 7),
      Text('${creature.rarity.label} • ${creature.element}', style: TextStyle(color: rarityColor(creature.rarity), fontWeight: FontWeight.w900)),
      const SizedBox(height: 12),
      Text(creature.description, textAlign: TextAlign.center, style: const TextStyle(color: WildColors.inkSoft, height: 1.45)),
      const SizedBox(height: 24),
      SoftCard(child: Row(children: [
        const Icon(Icons.bolt_rounded, color: WildColors.mintDeep),
        const SizedBox(width: 10),
        const Text('Quest XP', style: TextStyle(color: WildColors.inkSoft, fontWeight: FontWeight.w700)),
        const Spacer(),
        Text('+${walk.quest?.xpReward ?? 0}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 22)),
      ])),
      const SizedBox(height: 20),
      FilledButton(onPressed: () { ref.read(walkProvider.notifier).reset(); context.go(AppRoutes.home); }, child: const Text('CONTINUE ADVENTURE')),
    ]));
  }
}
