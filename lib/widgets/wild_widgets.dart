import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../models/creature.dart';

class PageScaffold extends StatelessWidget {
  const PageScaffold({super.key, required this.child, this.appBar});
  final Widget child;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: child,
        ),
      ),
    );
  }
}

class SoftCard extends StatelessWidget {
  const SoftCard({super.key, required this.child, this.color = WildColors.card, this.padding = const EdgeInsets.all(18)});
  final Widget child;
  final Color color;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: WildColors.border),
      ),
      child: child,
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Text(text.toUpperCase(), style: AppTheme.section);
}

class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key, required this.value, this.background = WildColors.border, this.foreground = WildColors.mintDeep});
  final double value;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: LinearProgressIndicator(
        minHeight: 10,
        value: value.clamp(0.0, 1.0),
        backgroundColor: background,
        valueColor: AlwaysStoppedAnimation(foreground),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard({super.key, required this.label, required this.value, required this.icon, required this.color});
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: color.withValues(alpha: .14), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color, size: 19),
        ),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: WildColors.inkSoft, fontSize: 12, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}

class CreatureAvatar extends StatelessWidget {
  const CreatureAvatar({super.key, required this.creature, this.size = 88});
  final Creature creature;
  final double size;

  @override
  Widget build(BuildContext context) {
    final accent = rarityColor(creature.rarity);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [accent.withValues(alpha: .25), Colors.white],
        ),
        border: Border.all(color: accent.withValues(alpha: .35), width: 2),
      ),
      child: Icon(creature.icon, size: size * .45, color: accent),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.title, required this.message});
  final IconData icon;
  final String title;
  final String message;
  @override
  Widget build(BuildContext context) => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 48, color: WildColors.mintDeep),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(message, textAlign: TextAlign.center, style: const TextStyle(color: WildColors.inkSoft, height: 1.4)),
        ]),
      );
}
