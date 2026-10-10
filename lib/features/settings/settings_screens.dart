import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../providers/providers.dart';
import '../../widgets/wild_widgets.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(progressProvider);
    return PageScaffold(appBar: AppBar(title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.w900))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionLabel('Experience'),
      const SizedBox(height: 10),
      SoftCard(child: Column(children: [
        _SettingRow(icon: Icons.phone_locked_rounded, title: 'Pocket Mode', subtitle: 'Designed for screen-free play', trailing: const Icon(Icons.check_circle_rounded, color: WildColors.mintDeep)),
        const Divider(height: 22),
        _SettingRow(icon: Icons.palette_outlined, title: 'Light theme', subtitle: 'Soft, outdoor-inspired colors', trailing: const Icon(Icons.wb_sunny_outlined, color: WildColors.peach)),
        const Divider(height: 22),
        _SettingRow(icon: Icons.science_outlined, title: 'Prototype mode', subtitle: 'Uses simulated walking for demos', trailing: const Icon(Icons.check_circle_outline_rounded, color: WildColors.mintDeep)),
      ])),
      const SizedBox(height: 20),
      const SectionLabel('Data'),
      const SizedBox(height: 10),
      SoftCard(child: Column(children: [
        _SettingRow(icon: Icons.lock_outline_rounded, title: 'Privacy-first', subtitle: 'This frontend stores demo progress locally', trailing: const Icon(Icons.chevron_right_rounded)),
        const Divider(height: 22),
        ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.restart_alt_rounded, color: WildColors.danger), title: const Text('Reset demo progress', style: TextStyle(fontWeight: FontWeight.w900)), subtitle: const Text('Restore the prototype to its starting state.'), onTap: () async { await ref.read(progressProvider.notifier).reset(); if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Demo progress reset.'))); }),
      ])),
      const SizedBox(height: 20),
      SoftCard(color: WildColors.lavenderPale, child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.info_outline_rounded, color: WildColors.lavender), const SizedBox(width: 12), Expanded(child: Text('This build is intentionally frontend-only. AI, voice, GPS, and backend integrations are removed so the UI prototype can run cleanly on Windows.', style: TextStyle(color: WildColors.ink, height: 1.45, fontWeight: FontWeight.w700)))])),
      const SizedBox(height: 16),
      Text('WildQuest prototype • Level ${p.level}', style: const TextStyle(color: WildColors.inkSoft, fontSize: 12, fontWeight: FontWeight.w700)),
    ]));
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({required this.icon, required this.title, required this.subtitle, required this.trailing});
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  @override
  Widget build(BuildContext context) => Row(children: [Container(width: 40, height: 40, decoration: BoxDecoration(color: WildColors.background, borderRadius: BorderRadius.circular(12)), child: Icon(icon, size: 20, color: WildColors.ink)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 3), Text(subtitle, style: const TextStyle(color: WildColors.inkSoft, fontSize: 12))])), trailing]);
}
