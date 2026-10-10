import 'package:flutter_test/flutter_test.dart';
import 'package:wildquest/models/quest.dart';
import 'package:wildquest/models/walking_session.dart';
import 'package:wildquest/models/progress.dart';
import 'package:wildquest/services/rewards/reward_engine.dart';

void main() {
  test('completed walk returns completion XP', () {
    const engine = RewardEngine();
    const quest = Quest(
      id: 'test',
      title: 'Test Quest',
      description: 'Walk.',
      durationMinutes: 10,
      distanceMeters: 600,
      difficulty: Difficulty.easy,
      rewardType: RewardType.xp,
      xpReward: 100,
      story: 'Test story',
    );
    const session = WalkingSession(
      id: 'session',
      questId: 'test',
      questTitle: 'Test Quest',
      startedAt: DateTime(2026, 1, 1),
      activeSeconds: 600,
      distanceMeters: 650,
      completed: true,
      demo: true,
    );

    final reward = engine.compute(quest: quest, session: session, progress: const GameProgress());
    expect(reward.xp, greaterThanOrEqualTo(100));
  });
}
