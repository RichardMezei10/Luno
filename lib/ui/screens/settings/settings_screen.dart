import 'package:flutter/material.dart';
import '../../widgets/header_card.dart';
import '../../../main.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.only(bottom: 110),
      children: [
        const HeaderCard(
          icon: Icons.settings,
          title: 'Settings',
          subtitle: 'App preferences',
        ),
        const SizedBox(height: 14),

        _card(
          context,
          child: ValueListenableBuilder<ThemeMode>(
            valueListenable: themeModeNotifier,
            builder: (_, mode, __) {
              final isDark = mode == ThemeMode.dark;
              final primary = cs.brightness == Brightness.dark ? const Color(0xFFE5E7EB) : const Color(0xFF0F172A);

              return Row(
                children: [
                  Icon(Icons.dark_mode, color: primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Dark mode', style: TextStyle(fontWeight: FontWeight.w900, color: primary)),
                  ),
                  Switch(
                    value: isDark,
                    onChanged: (v) => themeModeNotifier.value = v ? ThemeMode.dark : ThemeMode.light,
                  ),
                ],
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        _card(
          context,
          child: Row(
            children: [
              Icon(Icons.info_outline,
                  color: cs.brightness == Brightness.dark ? const Color(0xFFE5E7EB) : const Color(0xFF0F172A)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Version',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: cs.brightness == Brightness.dark ? const Color(0xFFE5E7EB) : const Color(0xFF0F172A),
                  ),
                ),
              ),
              Text(
                '1.0.0',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: cs.brightness == Brightness.dark ? const Color(0xFFAAB3C2) : const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _card(BuildContext context, {required Widget child}) {
    final cs = Theme.of(context).colorScheme;
    final card = cs.brightness == Brightness.dark ? const Color(0xFF111A2E) : Colors.white;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(14),
        border: cs.brightness == Brightness.dark
            ? Border.all(color: Colors.white.withOpacity(0.06))
            : null,
        boxShadow: cs.brightness == Brightness.dark
            ? const []
            : const [BoxShadow(blurRadius: 10, offset: Offset(0, 6), color: Color(0x1A000000))],
      ),
      child: child,
    );
  }
}
