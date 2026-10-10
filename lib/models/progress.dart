class GameProgress {
  const GameProgress({
    this.level = 1,
    this.xp = 120,
    this.totalDistanceMeters = 1850,
    this.totalScreenFreeMinutes = 47,
    this.questsCompleted = 2,
    this.streakDays = 2,
    this.discoveredCreatures = const ['mossling', 'pebblit'],
    this.onboardingComplete = false,
  });

  final int level;
  final int xp;
  final double totalDistanceMeters;
  final int totalScreenFreeMinutes;
  final int questsCompleted;
  final int streakDays;
  final List<String> discoveredCreatures;
  final bool onboardingComplete;

  GameProgress copyWith({
    int? level,
    int? xp,
    double? totalDistanceMeters,
    int? totalScreenFreeMinutes,
    int? questsCompleted,
    int? streakDays,
    List<String>? discoveredCreatures,
    bool? onboardingComplete,
  }) {
    return GameProgress(
      level: level ?? this.level,
      xp: xp ?? this.xp,
      totalDistanceMeters: totalDistanceMeters ?? this.totalDistanceMeters,
      totalScreenFreeMinutes: totalScreenFreeMinutes ?? this.totalScreenFreeMinutes,
      questsCompleted: questsCompleted ?? this.questsCompleted,
      streakDays: streakDays ?? this.streakDays,
      discoveredCreatures: discoveredCreatures ?? this.discoveredCreatures,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    );
  }
}
