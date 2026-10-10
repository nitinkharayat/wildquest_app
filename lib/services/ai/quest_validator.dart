import 'dart:convert';

import '../../core/constants/game_constants.dart';
import '../../models/quest.dart';

class QuestValidationException implements Exception {
  const QuestValidationException(this.reasons);
  final List<String> reasons;
  @override
  String toString() => 'QuestValidationException: ${reasons.join('; ')}';
}

class QuestConstraints {
  const QuestConstraints({required this.availableMinutes, this.preferredDifficulty, this.allowedRewardTypes = RewardType.values});
  final int availableMinutes;
  final Difficulty? preferredDifficulty;
  final List<RewardType> allowedRewardTypes;
  int get maxMinutes => availableMinutes.clamp(GameConstants.minQuestMinutes, GameConstants.maxQuestMinutes).toInt();
  int get minMinutes => (availableMinutes * .6).round().clamp(GameConstants.minQuestMinutes, maxMinutes).toInt();
}

class QuestValidator {
  const QuestValidator();

  Quest parse(String raw, {required QuestConstraints constraints}) => validate(_decode(raw), constraints: constraints);

  Map<String, dynamic> _decode(String raw) {
    var text = raw.trim();
    if (text.startsWith('```')) {
      text = text.replaceFirst(RegExp(r'^```[a-zA-Z]*'), '').trim();
      if (text.endsWith('```')) text = text.substring(0, text.length - 3).trim();
    }
    if (!text.startsWith('{')) {
      final start = text.indexOf('{');
      final end = text.lastIndexOf('}');
      if (start >= 0 && end > start) text = text.substring(start, end + 1);
    }
    try {
      final decoded = jsonDecode(text);
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {}
    throw const QuestValidationException(['Response was not valid quest JSON.']);
  }

  Quest validate(Map<String, dynamic> json, {required QuestConstraints constraints}) {
    final reasons = <String>[];
    final title = _string(json['title']);
    final description = _string(json['description']) ?? '';
    final story = _string(json['story']) ?? '';
    final duration = _int(json['duration_minutes']);
    final distance = _int(json['distance_meters']);
    final xp = _int(json['xp_reward']);
    final difficulty = _string(json['difficulty']);
    final reward = _string(json['reward_type']);

    if (title == null || title.isEmpty) reasons.add('title is required');
    if (title != null && title.length > GameConstants.maxTitleLength) reasons.add('title too long');
    if (description.length > GameConstants.maxDescriptionLength) reasons.add('description too long');
    if (story.length > GameConstants.maxStoryLength) reasons.add('story too long');
    if (duration == null) reasons.add('duration_minutes is required');
    if (distance == null) reasons.add('distance_meters is required');
    if (xp == null) reasons.add('xp_reward is required');
    if (duration != null && (duration < GameConstants.minQuestMinutes || duration > GameConstants.maxQuestMinutes)) reasons.add('duration out of bounds');
    if (distance != null && (distance < GameConstants.minQuestMeters || distance > GameConstants.maxQuestMeters)) reasons.add('distance out of bounds');
    if (xp != null && (xp < GameConstants.minQuestXp || xp > GameConstants.maxQuestXp)) reasons.add('xp out of bounds');
    if (difficulty == null || !Difficulty.values.any((d) => d.name == difficulty.toLowerCase())) reasons.add('invalid difficulty');
    if (reward == null || !RewardType.values.any((r) => r.name == reward.toLowerCase())) reasons.add('invalid reward');
    if (reward != null && !constraints.allowedRewardTypes.map((r) => r.name).contains(reward.toLowerCase())) reasons.add('reward not allowed');
    if (reasons.isNotEmpty) throw QuestValidationException(reasons);

    final safeMinutes = duration!.clamp(constraints.minMinutes, constraints.maxMinutes).toInt();
    final safeDistance = distance!.clamp(GameConstants.minQuestMeters, GameConstants.maxQuestMeters).toInt();
    final selectedDifficulty = constraints.preferredDifficulty ?? DifficultyX.fromName(difficulty!);
    return Quest(
      id: 'ai-${DateTime.now().microsecondsSinceEpoch}',
      title: title!.trim(),
      description: description.trim(),
      durationMinutes: safeMinutes,
      distanceMeters: safeDistance,
      difficulty: selectedDifficulty,
      rewardType: RewardTypeX.fromName(reward!),
      xpReward: xp!.clamp(GameConstants.minQuestXp, GameConstants.maxQuestXp).toInt(),
      story: story.trim(),
      category: _inferCategory(safeMinutes, safeDistance),
      aiGenerated: true,
    );
  }

  QuestCategory _inferCategory(int minutes, int meters) {
    if (minutes <= 12 && meters <= 800) return QuestCategory.quickReset;
    if (meters >= 2500) return QuestCategory.challenge;
    if (meters >= 1400) return QuestCategory.explorer;
    return QuestCategory.discovery;
  }

  String? _string(dynamic v) => v is String ? v.trim() : null;
  int? _int(dynamic v) => v is int ? v : v is double ? v.round() : v is String ? int.tryParse(v.trim()) : null;
}
