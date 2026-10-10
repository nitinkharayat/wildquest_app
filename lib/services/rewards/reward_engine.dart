import 'dart:math';

import '../../core/constants/game_constants.dart';
import '../../data/creature_catalog.dart';
import '../../models/creature.dart';
import '../../models/progress.dart';
import '../../models/quest.dart';
import '../../models/reward.dart';
import '../../models/walking_session.dart';

/// Deterministic reward calculation.
///
/// Deliberately not random-driven in its economy: every XP point is
/// explainable to the player. Only *creature rarity* uses a seeded roll,
/// and it is weighted by how much the player actually explored.
class RewardEngine {
  const RewardEngine();

  RewardBundle compute({
    required Quest quest,
    required WalkingSession session,
    required GameProgress progress,
  }) {
    final breakdown = <String, int>{};
    final minutes = session.activeSeconds / 60.0;
    final metres = session.distanceMeters;

    // Time on feet.
    final timeXp =
        ((minutes / 10) * GameConstants.xpPerTenMinutes).floor().clamp(0, 600).toInt();
    if (timeXp > 0) breakdown['Time walked'] = timeXp;

    // Distance covered.
    final distanceXp = ((metres / 500) * GameConstants.xpPerFiveHundredMeters)
        .floor()
        .clamp(0, 600)
        .toInt();
    if (distanceXp > 0) breakdown['Distance covered'] = distanceXp;

    // Screen-free bonus.
    if (minutes >= GameConstants.screenFreeBonusThresholdMinutes) {
      breakdown['Screen-free bonus'] = GameConstants.screenFreeBonusXp;
    }

    // Quest completion.
    if (session.completed) {
      breakdown['Quest completed'] = quest.xpReward;
    }

    // Overachievement.
    if (metres >= quest.distanceMeters * 1.2) {
      breakdown['Went further than asked'] = 50;
    }

    final totalXp = breakdown.values.fold<int>(0, (a, b) => a + b);

    final score = explorationScore(
      session: session,
      quest: quest,
      progress: progress,
    );

    final creatureIds = <String>[];
    final narrative = <String>[];

    if (session.completed) {
      final roll = _rollCreature(
        quest: quest,
        session: session,
        score: score,
        owned: progress.ownedCreatures.map((c) => c.creatureId).toSet(),
      );
      if (roll != null) {
        creatureIds.add(roll.id);
        narrative.add(
          'You followed the trail long enough for ${roll.name} to emerge.',
        );
      }
    }

    return RewardBundle(
      xp: totalXp,
      creatureIds: creatureIds,
      breakdown: breakdown,
      narrative: narrative.isEmpty ? null : narrative.join(' '),
    );
  }

  /// 0.0 → 1.0. How much genuine, uninterrupted exploration happened.
  double explorationScore({
    required WalkingSession session,
    required Quest quest,
    required GameProgress progress,
  }) {
    final minutes = session.activeSeconds / 60.0;
    final distanceRatio =
        (session.distanceMeters / max(1, quest.distanceMeters))
                .clamp(0.0, 2.0)
                .toDouble() /
            2.0;
    final timeRatio = (minutes / 45.0).clamp(0.0, 1.0).toDouble();
    final completionRatio = session.completed ? 1.0 : 0.4;
    final novelty = progress.questsCompleted == 0 ? 1.0 : 0.7;

    final raw = distanceRatio * 0.4 +
        timeRatio * 0.3 +
        completionRatio * 0.2 +
        novelty * 0.1;

    return raw.clamp(0.0, 1.0).toDouble();
  }

  Creature? _rollCreature({
    required Quest quest,
    required WalkingSession session,
    required double score,
    required Set<String> owned,
  }) {
    // A quest that promises a creature always delivers one.
    final guaranteed = quest.rewardType == RewardType.creature;
    final random = Random(session.id.hashCode);

    if (!guaranteed && random.nextDouble() > score * 0.45) {
      return null;
    }

    final rarity = _rollRarity(score: score, random: random);

    final pool = CreatureCatalog.all
        .where((c) => c.rarity == rarity && !owned.contains(c.id))
        .toList();

    // Fall back to lower rarities if the player already has them all.
    if (pool.isEmpty) {
      final fallbackPool = CreatureCatalog.all
          .where((c) => c.rarity.index <= rarity.index)
          .toList();
      if (fallbackPool.isEmpty) return null;
      return fallbackPool[random.nextInt(fallbackPool.length)];
    }

    return pool[random.nextInt(pool.length)];
  }

  Rarity _rollRarity({required double score, required Random random}) {
    // Exploration shifts the distribution upward: legendary stays genuinely
    // rare, but a great walk meaningfully improves your odds.
    final weights = <Rarity, double>{};
    for (final rarity in Rarity.values) {
      final base = rarity.baseWeight.toDouble();
      final boost = switch (rarity) {
        Rarity.common => 1.0 - score * 0.6,
        Rarity.uncommon => 1.0,
        Rarity.rare => 1.0 + score * 1.4,
        Rarity.epic => 0.4 + score * 2.6,
        Rarity.legendary => 0.05 + score * 3.5,
      };
      weights[rarity] = base * boost;
    }

    final total = weights.values.reduce((a, b) => a + b);
    var roll = random.nextDouble() * total;
    for (final entry in weights.entries) {
      roll -= entry.value;
      if (roll <= 0) return entry.key;
    }
    return Rarity.common;
  }
}

