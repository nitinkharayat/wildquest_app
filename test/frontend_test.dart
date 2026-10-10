import 'package:flutter_test/flutter_test.dart';

import 'package:wildquest/models/quest.dart';
import 'package:wildquest/models/progress.dart';
import 'package:wildquest/providers/providers.dart';

void main() {
  test('quest generator returns an eligible quest', () {
    final generator = QuestGenerator();
    final quest = generator.generate(minutes: 15, difficulty: Difficulty.easy);
    expect(quest.durationMinutes, lessThanOrEqualTo(15));
    expect(quest.difficulty, Difficulty.easy);
  });

  test('progress copyWith preserves untouched values', () {
    const progress = GameProgress(level: 3, xp: 120);
    final next = progress.copyWith(xp: 200);
    expect(next.level, 3);
    expect(next.xp, 200);
  });
}
