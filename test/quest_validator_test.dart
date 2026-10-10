import 'package:flutter_test/flutter_test.dart';
import 'package:wildquest/models/quest.dart';
import 'package:wildquest/services/ai/quest_validator.dart';

void main() {
  const validator = QuestValidator();
  const constraints = QuestConstraints(availableMinutes: 20, preferredDifficulty: Difficulty.moderate);

  test('parses and bounds a valid quest', () {
    final quest = validator.parse(
      '{"title":"Hidden Grove","description":"Walk the quiet trail.","duration_minutes":18,"distance_meters":1000,"difficulty":"easy","reward_type":"creature","story":"A small guardian is waiting.","xp_reward":180}',
      constraints: constraints,
    );

    expect(quest.durationMinutes, 18);
    expect(quest.distanceMeters, 1000);
    expect(quest.difficulty, Difficulty.moderate);
    expect(quest.aiGenerated, isTrue);
  });

  test('rejects malformed output', () {
    expect(
      () => validator.parse('not json', constraints: constraints),
      throwsA(isA<QuestValidationException>()),
    );
  });
}
