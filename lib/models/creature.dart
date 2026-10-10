import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

class Creature {
  const Creature({
    required this.id,
    required this.name,
    required this.element,
    required this.rarity,
    required this.description,
    required this.icon,
  });

  final String id;
  final String name;
  final String element;
  final Rarity rarity;
  final String description;
  final IconData icon;
}

class OwnedCreature {
  const OwnedCreature({
    required this.creatureId,
    required this.discoveredAt,
    this.level = 1,
    this.xp = 0,
  });

  final String creatureId;
  final DateTime discoveredAt;
  final int level;
  final int xp;
}
