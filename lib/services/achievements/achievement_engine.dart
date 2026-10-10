import '../../models/progress.dart';

class Achievement {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String id;
  final String title;
  final String description;
  final String icon;
}

class AchievementEngine {
  const AchievementEngine();

  static const List<Achievement> catalog = [
    Achievement(
      id: 'first_steps',
      title: 'First Steps',
      description: 'Complete your first quest.',
      icon: '🌱',
    ),
    Achievement(
      id: 'pocket_five',
      title: 'Pocket Veteran',
      description: 'Accumulate 5 hours of screen-free time.',
      icon: '⏳',
    ),
    Achievement(
      id: 'ten_k',
      title: 'Ten Kilometres',
      description: 'Walk 10 km in total.',
      icon: '🥾',
    ),
    Achievement(
      id: 'collector',
      title: 'Collector',
      description: 'Discover 5 creatures.',
      icon: '📖',
    ),
    Achievement(
      id: 'rare_find',
      title: 'Rare Find',
      description: 'Discover a Rare or better creature.',
      icon: '💎',
    ),
    Achievement(
      id: 'streak_three',
      title: 'Three Days Out',
      description: 'Keep an outdoor streak of 3 days.',
      icon: '🔥',
    ),
    Achievement(
      id: 'marathon',
      title: 'Long Walk',
      description: 'Complete a single session over 45 minutes.',
      icon: '🏔️',
    ),
  ];

  /// Returns the IDs of achievements unlocked by the latest session.
  List<String> evaluate({
    required GameProgress before,
    required GameProgress after,
    required int sessionSeconds,
    required List<String> discoveredCreatureIds,
  }) {
    final unlocked = <String>[];

    void check(String id, bool condition) {
      if (condition && !after.unlockedAchievements.contains(id)) {
        unlocked.add(id);
      }
    }

    check('first_steps', after.questsCompleted >= 1);
    check('pocket_five', after.totalScreenFreeSeconds >= 5 * 3600);
    check('ten_k', after.totalDistanceMeters >= 10000);
    check('collector', after.ownedCreatures.length >= 5);
    check('streak_three', after.streakDays >= 3);
    check('marathon', sessionSeconds >= 45 * 60);

    if (discoveredCreatureIds.isNotEmpty) {
      final hasRare = discoveredCreatureIds.any((id) => _isRareOrBetter(id));
      check('rare_find', hasRare);
    }

    return unlocked;
  }

  bool _isRareOrBetter(String creatureId) {
    // Imported lazily to keep this engine free of UI concerns.
    return _rareIds.contains(creatureId);
  }

  static const Set<String> _rareIds = {
    'mossling',
    'emberoot',
    'rainox',
    'tidemaw',
    'lumina',
    'zephyrix',
  };
}

