import '../models/quest.dart';

const questTemplates = <Quest>[
  Quest(id: 'hidden-grove', title: 'The Hidden Grove', description: 'A quiet path is waiting for you. Take the long way and see what changes.', story: 'Follow a familiar route, then choose one gentle turn you have not taken before.', durationMinutes: 15, distanceMeters: 800, difficulty: Difficulty.easy, category: QuestCategory.explorer, xpReward: 120),
  Quest(id: 'quiet-reset', title: 'Quiet Reset', description: 'Step outside, breathe, and give your mind ten screen-free minutes.', story: 'No rush. Let the world become the thing you notice most.', durationMinutes: 10, distanceMeters: 600, difficulty: Difficulty.easy, category: QuestCategory.quickReset, xpReward: 90),
  Quest(id: 'rootline-trace', title: 'Rootline Trace', description: 'Follow the oldest route you know and look for a detail you normally miss.', story: 'The path remembers every footstep. Add one of yours.', durationMinutes: 20, distanceMeters: 1200, difficulty: Difficulty.moderate, category: QuestCategory.discovery, xpReward: 150),
  Quest(id: 'long-drift', title: 'The Long Drift', description: 'Choose distance over speed. Keep moving until the quest feels easy.', story: 'Something fast is circling ahead. Persistence is the only way to catch it.', durationMinutes: 30, distanceMeters: 2200, difficulty: Difficulty.hard, category: QuestCategory.challenge, xpReward: 220),
  Quest(id: 'unmarked-turn', title: 'Unmarked Turn', description: 'Take one turn you have never taken before and explore for a little while.', story: 'The map ends where curiosity begins.', durationMinutes: 20, distanceMeters: 1000, difficulty: Difficulty.moderate, category: QuestCategory.surprise, xpReward: 170),
];
