import 'dart:math';

import 'package:uuid/uuid.dart';

import '../../data/quest_templates.dart';
import '../../models/progress.dart';
import '../../models/quest.dart';
import 'llm_client.dart';
import 'quest_validator.dart';

class QuestRequest {
  const QuestRequest({required this.progress, required this.availableMinutes, this.preferredDifficulty, this.category});
  final GameProgress progress;
  final int availableMinutes;
  final Difficulty? preferredDifficulty;
  final QuestCategory? category;
}

abstract class AIGameMaster { Future<Quest> generateQuest(QuestRequest request); String get engineName; }

class GameMasterPrompt {
  const GameMasterPrompt._();
  static const system = '''You are the AI Game Master of WildQuest, a screenless outdoor walking game.
Generate exactly one safe, achievable micro-adventure. Return ONLY JSON.
Never ask the player to cross roads unsafely, enter private property, approach strangers, or take risks.
Keep the tone adventurous, calm, concise, and encouraging.
Never reference real people, brands, or existing game franchises.
Schema: {"title":string,"description":string,"duration_minutes":integer,"distance_meters":integer,"difficulty":"easy|moderate|hard|epic","reward_type":"xp|creature|badge|item|story","story":string,"xp_reward":integer}''';

  static String user(QuestRequest r) {
    final p = r.progress;
    final recent = p.history.take(6).map((h) => h.title).join(' | ');
    final avgMin = p.history.isEmpty ? 0 : (p.history.map((h) => h.durationSeconds).reduce((a,b)=>a+b) / p.history.length / 60).round();
    final avgMeters = p.history.isEmpty ? 0 : (p.history.map((h) => h.distanceMeters).reduce((a,b)=>a+b) / p.history.length).round();
    return '''Player context:
level=${p.level}
quests_completed=${p.questsCompleted}
average_minutes=$avgMin
average_meters=$avgMeters
streak_days=${p.streakDays}
creatures=${p.ownedCreatures.length}
available_minutes=${r.availableMinutes}
preferred_difficulty=${r.preferredDifficulty?.name ?? 'any'}
category=${r.category?.name ?? 'any'}
recent_quest_titles=${recent.isEmpty ? 'none' : recent}
Create something fresh that gently stretches the player's recent baseline.''';
  }
}

class GemmaGameMaster implements AIGameMaster {
  GemmaGameMaster({required this.client, required this.fallback, this.validator = const QuestValidator()});
  final LlmClient client; final AIGameMaster fallback; final QuestValidator validator;
  @override String get engineName => client.isAvailable ? 'Gemma 3 1B' : '${fallback.engineName} (offline)';
  @override Future<Quest> generateQuest(QuestRequest request) async {
    if (!client.isAvailable) return fallback.generateQuest(request);
    try {
      final raw = await client.completeJson(system: GameMasterPrompt.system, prompt: GameMasterPrompt.user(request));
      return validator.parse(raw, constraints: QuestConstraints(availableMinutes: request.availableMinutes, preferredDifficulty: request.preferredDifficulty));
    } catch (_) { return fallback.generateQuest(request); }
  }
}

class LocalFallbackGameMaster implements AIGameMaster {
  LocalFallbackGameMaster({Random? random}) : _random = random ?? Random();
  final Random _random; final _uuid = const Uuid(); final _validator = const QuestValidator();
  @override String get engineName => 'Local Game Master';
  @override Future<Quest> generateQuest(QuestRequest request) async {
    final maxMinutes = request.availableMinutes.clamp(5, 180).toInt();
    var candidates = kQuestTemplates.where((t) => t.minutes <= maxMinutes).toList();
    if (request.category != null) {
      final filtered = candidates.where((t) => t.category == request.category).toList();
      if (filtered.isNotEmpty) candidates = filtered;
    }
    if (candidates.isEmpty) candidates = List.of(kQuestTemplates);
    final recent = request.progress.history.take(6).map((h)=>h.title).toSet();
    final fresh = candidates.where((t)=>!recent.contains(t.title)).toList();
    if (fresh.isNotEmpty) candidates = fresh;
    final t = candidates[_random.nextInt(candidates.length)];
    final distance = (t.meters * (1 + (request.progress.level - 1) * .05)).round().clamp(100, 20000).toInt();
    return _validator.validate({'title':t.title,'description':t.description,'story':t.story,'duration_minutes':t.minutes,'distance_meters':distance,'difficulty':t.difficulty.name,'reward_type':t.rewardType.name,'xp_reward':(80+t.minutes*6).clamp(20,800)}, constraints: QuestConstraints(availableMinutes: request.availableMinutes, preferredDifficulty: request.preferredDifficulty)).copyWithId('local-${_uuid.v4()}');
  }
}

extension QuestIdCopy on Quest {
  Quest copyWithId(String id) => Quest(id:id,title:title,description:description,durationMinutes:durationMinutes,distanceMeters:distanceMeters,difficulty:difficulty,rewardType:rewardType,xpReward:xpReward,story:story,category:category,aiGenerated:false);
}
