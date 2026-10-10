enum WalkingState { unknown, still, walking, running, vehicle }

extension WalkingStateX on WalkingState {
  String get label => switch (this) {
        WalkingState.unknown => 'Detecting…',
        WalkingState.still => 'Standing still',
        WalkingState.walking => 'Walking',
        WalkingState.running => 'Running',
        WalkingState.vehicle => 'In a vehicle',
      };
}

class WalkingSession {
  const WalkingSession({
    required this.id,
    required this.questId,
    required this.questTitle,
    required this.startedAt,
    required this.activeSeconds,
    required this.distanceMeters,
    this.endedAt,
    this.completed = false,
    this.interrupted = false,
    this.demo = false,
  });

  final String id;
  final String questId;
  final String questTitle;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int activeSeconds;
  final double distanceMeters;
  final bool completed;
  final bool interrupted;
  final bool demo;

  Duration get duration => Duration(seconds: activeSeconds);

  Map<String, dynamic> toJson() => {
        'id': id,
        'questId': questId,
        'questTitle': questTitle,
        'startedAt': startedAt.toIso8601String(),
        'endedAt': endedAt?.toIso8601String(),
        'activeSeconds': activeSeconds,
        'distanceMeters': distanceMeters,
        'completed': completed,
        'interrupted': interrupted,
        'demo': demo,
      };

  factory WalkingSession.fromJson(Map<String, dynamic> json) => WalkingSession(
        id: json['id'] as String,
        questId: json['questId'] as String? ?? '',
        questTitle: json['questTitle'] as String? ?? '',
        startedAt: DateTime.tryParse(json['startedAt'] as String? ?? '') ??
            DateTime.now(),
        endedAt: DateTime.tryParse(json['endedAt'] as String? ?? ''),
        activeSeconds: (json['activeSeconds'] as num?)?.toInt() ?? 0,
        distanceMeters: (json['distanceMeters'] as num?)?.toDouble() ?? 0,
        completed: json['completed'] as bool? ?? false,
        interrupted: json['interrupted'] as bool? ?? false,
        demo: json['demo'] as bool? ?? false,
      );
}

class WalkingTick {
  const WalkingTick({
    required this.elapsed,
    required this.distanceMeters,
    required this.state,
    required this.targetReached,
  });

  final Duration elapsed;
  final double distanceMeters;
  final WalkingState state;
  final bool targetReached;
}

