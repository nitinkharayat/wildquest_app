enum QuestCategory { quickReset, explorer, discovery, challenge, surprise }

enum Difficulty { easy, moderate, hard }

extension QuestCategoryX on QuestCategory {
  String get label => switch (this) {
        QuestCategory.quickReset => 'Quick Reset',
        QuestCategory.explorer => 'Explorer',
        QuestCategory.discovery => 'Discovery',
        QuestCategory.challenge => 'Challenge',
        QuestCategory.surprise => 'Surprise',
      };
}

extension DifficultyX on Difficulty {
  String get label => switch (this) {
        Difficulty.easy => 'Easy',
        Difficulty.moderate => 'Moderate',
        Difficulty.hard => 'Hard',
      };
}

class Quest {
  const Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.story,
    required this.durationMinutes,
    required this.distanceMeters,
    required this.difficulty,
    required this.category,
    required this.xpReward,
  });

  final String id;
  final String title;
  final String description;
  final String story;
  final int durationMinutes;
  final int distanceMeters;
  final Difficulty difficulty;
  final QuestCategory category;
  final int xpReward;
}
