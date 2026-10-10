import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/creature_catalog.dart';
import '../data/quest_templates.dart';
import '../models/progress.dart';
import '../models/quest.dart';
import '../services/storage/local_store.dart';

final localStoreProvider = Provider<LocalStore>((_) => throw UnimplementedError());

final progressProvider = StateNotifierProvider<ProgressController, GameProgress>((ref) {
  return ProgressController(ref.watch(localStoreProvider));
});

class ProgressController extends StateNotifier<GameProgress> {
  ProgressController(this._store) : super(const GameProgress());
  final LocalStore _store;

  Future<void> load() async => state = _store.readProgress();

  Future<void> finishOnboarding() async {
    state = state.copyWith(onboardingComplete: true);
    await _store.writeProgress(state);
  }

  Future<void> addQuestCompletion({required int xp, required double distanceMeters, required int minutes, required String creatureId}) async {
    final creatures = {...state.discoveredCreatures};
    creatures.add(creatureId);
    var level = state.level;
    var nextXp = state.xp + xp;
    final threshold = 300 + (level - 1) * 250;
    if (nextXp >= threshold) {
      nextXp -= threshold;
      level += 1;
    }
    state = state.copyWith(
      level: level,
      xp: nextXp,
      totalDistanceMeters: state.totalDistanceMeters + distanceMeters,
      totalScreenFreeMinutes: state.totalScreenFreeMinutes + minutes,
      questsCompleted: state.questsCompleted + 1,
      streakDays: max(1, state.streakDays + 1),
      discoveredCreatures: creatures.toList(),
    );
    await _store.writeProgress(state);
  }

  Future<void> reset() async {
    state = const GameProgress(onboardingComplete: true);
    await _store.writeProgress(state);
  }
}

final questProvider = Provider<List<Quest>>((_) => questTemplates);

final selectedQuestProvider = StateProvider<Quest?>((_) => null);

class QuestGenerator {
  Quest generate({QuestCategory? category, Difficulty? difficulty, int minutes = 15}) {
    final candidates = questTemplates.where((q) {
      final categoryOk = category == null || q.category == category;
      final difficultyOk = difficulty == null || q.difficulty == difficulty;
      final timeOk = q.durationMinutes <= minutes;
      return categoryOk && difficultyOk && timeOk;
    }).toList();
    if (candidates.isEmpty) return questTemplates.first;
    candidates.shuffle();
    return candidates.first;
  }
}

final questGeneratorProvider = Provider<QuestGenerator>((_) => QuestGenerator());

enum WalkPhase { idle, running, complete }

class WalkState {
  const WalkState({this.phase = WalkPhase.idle, this.seconds = 0, this.meters = 0, this.quest});
  final WalkPhase phase;
  final int seconds;
  final double meters;
  final Quest? quest;

  double get progress => quest == null ? 0 : (meters / quest!.distanceMeters).clamp(0.0, 1.0).toDouble();
  WalkState copyWith({WalkPhase? phase, int? seconds, double? meters, Quest? quest}) => WalkState(
        phase: phase ?? this.phase,
        seconds: seconds ?? this.seconds,
        meters: meters ?? this.meters,
        quest: quest ?? this.quest,
      );
}

final walkProvider = StateNotifierProvider<WalkController, WalkState>((ref) => WalkController(ref));

class WalkController extends StateNotifier<WalkState> {
  WalkController(this._ref) : super(const WalkState());
  final Ref _ref;
  DateTime? _started;

  void start(Quest quest) {
    _started = DateTime.now();
    state = WalkState(phase: WalkPhase.running, quest: quest);
  }

  void tick() {
    if (state.phase != WalkPhase.running || state.quest == null || _started == null) return;
    final seconds = DateTime.now().difference(_started!).inSeconds;
    final meters = min(state.quest!.distanceMeters.toDouble(), seconds * 1.55);
    state = state.copyWith(seconds: seconds, meters: meters);
  }

  Future<void> complete() async {
    if (state.quest == null) return;
    final q = state.quest!;
    final minutes = max(1, state.seconds ~/ 60);
    await _ref.read(progressProvider.notifier).addQuestCompletion(
          xp: q.xpReward,
          distanceMeters: state.meters,
          minutes: minutes,
          creatureId: _creatureForQuest(q),
        );
    state = state.copyWith(phase: WalkPhase.complete);
  }

  void reset() => state = const WalkState();

  String _creatureForQuest(Quest q) {
    if (q.category == QuestCategory.challenge) return 'emberoot';
    if (q.category == QuestCategory.surprise) return 'driftfin';
    final owned = _ref.read(progressProvider).discoveredCreatures.toSet();
    return CreatureCatalog.all.firstWhere((c) => !owned.contains(c.id), orElse: () => CreatureCatalog.all.first).id;
  }
}
