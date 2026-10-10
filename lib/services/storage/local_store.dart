import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/progress.dart';

class LocalStore {
  LocalStore._(this._prefs);

  final SharedPreferences _prefs;
  static const _key = 'wildquest.progress.v2';

  static Future<LocalStore> open() async {
    return LocalStore._(await SharedPreferences.getInstance());
  }

  GameProgress readProgress() {
    final raw = _prefs.getString(_key);
    if (raw == null) return const GameProgress();
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return GameProgress(
        level: (map['level'] as num?)?.toInt() ?? 1,
        xp: (map['xp'] as num?)?.toInt() ?? 120,
        totalDistanceMeters: (map['distance'] as num?)?.toDouble() ?? 0,
        totalScreenFreeMinutes: (map['screen_free'] as num?)?.toInt() ?? 0,
        questsCompleted: (map['quests'] as num?)?.toInt() ?? 0,
        streakDays: (map['streak'] as num?)?.toInt() ?? 0,
        discoveredCreatures: (map['creatures'] as List?)?.cast<String>() ?? const [],
        onboardingComplete: map['onboarding'] as bool? ?? false,
      );
    } catch (_) {
      return const GameProgress();
    }
  }

  Future<void> writeProgress(GameProgress p) async {
    await _prefs.setString(_key, jsonEncode({
      'level': p.level,
      'xp': p.xp,
      'distance': p.totalDistanceMeters,
      'screen_free': p.totalScreenFreeMinutes,
      'quests': p.questsCompleted,
      'streak': p.streakDays,
      'creatures': p.discoveredCreatures,
      'onboarding': p.onboardingComplete,
    }));
  }

  Future<void> clear() => _prefs.remove(_key);
}
