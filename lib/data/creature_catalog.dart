import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../models/creature.dart';

class CreatureCatalog {
  const CreatureCatalog._();

  static const all = <Creature>[
    Creature(id: 'mossling', name: 'Mossling', element: 'Verdant', rarity: Rarity.rare, description: 'A gentle grove guardian that grows brighter after every quiet walk.', icon: Icons.eco_rounded),
    Creature(id: 'pebblit', name: 'Pebblit', element: 'Stone', rarity: Rarity.common, description: 'A tiny trail companion that collects stones wherever you wander.', icon: Icons.terrain_rounded),
    Creature(id: 'emberoot', name: 'Emberoot', element: 'Ember', rarity: Rarity.uncommon, description: 'A warm little sprout that thrives on steady, determined journeys.', icon: Icons.local_fire_department_rounded),
    Creature(id: 'driftfin', name: 'Driftfin', element: 'Tide', rarity: Rarity.uncommon, description: 'A wind-riding wanderer that follows curious explorers.', icon: Icons.waves_rounded),
    Creature(id: 'lumina', name: 'Lumina', element: 'Lumen', rarity: Rarity.epic, description: 'A floating spark said to appear when a path feels completely new.', icon: Icons.auto_awesome_rounded),
    Creature(id: 'zephyrix', name: 'Zephyrix', element: 'Storm', rarity: Rarity.legendary, description: 'A rare sky spirit for explorers who keep going when the world gets quiet.', icon: Icons.air_rounded),
  ];

  static Creature byId(String id) => all.firstWhere((c) => c.id == id, orElse: () => all.first);
}
