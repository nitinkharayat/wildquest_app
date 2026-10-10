class GameConstants {
  const GameConstants._();

  /// XP required to advance FROM [level] to [level] + 1.
  static int xpRequiredForLevel(int level) => 300 + (level - 1) * 250;

  static const int minQuestMinutes = 5;
  static const int maxQuestMinutes = 180;
  static const int minQuestMeters = 100;
  static const int maxQuestMeters = 20000;
  static const int minQuestXp = 20;
  static const int maxQuestXp = 800;

  static const int maxTitleLength = 60;
  static const int maxDescriptionLength = 240;
  static const int maxStoryLength = 400;

  /// Distance filter (metres) before a new GPS point is emitted.
  static const int locationDistanceFilter = 8;

  /// XP granted per completed 10 minutes of screen-free walking.
  static const int xpPerTenMinutes = 50;
  static const int xpPerFiveHundredMeters = 50;
  static const int screenFreeBonusXp = 100;
  static const int screenFreeBonusThresholdMinutes = 20;
}

