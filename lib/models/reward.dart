class RewardBundle {
  const RewardBundle({
    required this.xp,
    this.creatureIds = const [],
    this.badgeIds = const [],
    this.breakdown = const {},
    this.narrative,
  });

  final int xp;
  final List<String> creatureIds;
  final List<String> badgeIds;

  /// Human-readable XP sources, e.g. {"Time walked": 50, "Distance": 50}.
  final Map<String, int> breakdown;
  final String? narrative;

  bool get hasCreature => creatureIds.isNotEmpty;

  Map<String, dynamic> toJson() => {
        'xp': xp,
        'creatureIds': creatureIds,
        'badgeIds': badgeIds,
        'breakdown': breakdown,
        'narrative': narrative,
      };

  factory RewardBundle.fromJson(Map<String, dynamic> json) => RewardBundle(
        xp: (json['xp'] as num?)?.toInt() ?? 0,
        creatureIds:
            (json['creatureIds'] as List?)?.cast<String>() ?? const [],
        badgeIds: (json['badgeIds'] as List?)?.cast<String>() ?? const [],
        breakdown: (json['breakdown'] as Map?)?.map(
              (k, v) => MapEntry(k.toString(), (v as num).toInt()),
            ) ??
            const {},
        narrative: json['narrative'] as String?,
      );
}

