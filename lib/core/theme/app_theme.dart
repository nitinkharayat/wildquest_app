import 'package:flutter/material.dart';

class WildColors {
  const WildColors._();

  static const ink = Color(0xFF1E2A23);
  static const inkSoft = Color(0xFF66736B);
  static const background = Color(0xFFF7F8F3);
  static const card = Colors.white;
  static const border = Color(0xFFE4E9E2);
  static const mint = Color(0xFF68C79A);
  static const mintDeep = Color(0xFF2E8C64);
  static const mintPale = Color(0xFFE7F7EE);
  static const sky = Color(0xFF79BDE8);
  static const skyPale = Color(0xFFEAF5FC);
  static const peach = Color(0xFFFFB58E);
  static const peachPale = Color(0xFFFFF0E8);
  static const lavender = Color(0xFFB7A6E8);
  static const lavenderPale = Color(0xFFF1EEFD);
  static const lemon = Color(0xFFE8CF72);
  static const lemonPale = Color(0xFFFFF8D9);
  static const danger = Color(0xFFD96767);
}

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: WildColors.mintDeep,
      brightness: Brightness.light,
      surface: WildColors.background,
    );
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: WildColors.background,
      fontFamily: 'Arial',
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: WildColors.ink,
        displayColor: WildColors.ink,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: WildColors.ink,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: WildColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: WildColors.border),
        ),
        margin: EdgeInsets.zero,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: WildColors.ink,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: .3,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: WildColors.ink,
          minimumSize: const Size.fromHeight(52),
          side: const BorderSide(color: WildColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: Colors.white,
        selectedColor: WildColors.mintPale,
        side: const BorderSide(color: WildColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        labelStyle: const TextStyle(fontWeight: FontWeight.w700, color: WildColors.ink),
      ),
      dividerTheme: const DividerThemeData(color: WildColors.border),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static const display = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w900,
    height: 1.04,
    letterSpacing: -.8,
  );

  static const headline = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w900,
    letterSpacing: -.4,
  );

  static const section = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w900,
    letterSpacing: 1.2,
    color: WildColors.inkSoft,
  );
}

Color rarityColor(Rarity rarity) => switch (rarity) {
      Rarity.common => WildColors.inkSoft,
      Rarity.uncommon => WildColors.mintDeep,
      Rarity.rare => WildColors.sky,
      Rarity.epic => WildColors.lavender,
      Rarity.legendary => const Color(0xFFB48A1D),
    };

enum Rarity { common, uncommon, rare, epic, legendary }

extension RarityX on Rarity {
  String get label => switch (this) {
        Rarity.common => 'Common',
        Rarity.uncommon => 'Uncommon',
        Rarity.rare => 'Rare',
        Rarity.epic => 'Epic',
        Rarity.legendary => 'Legendary',
      };
}
