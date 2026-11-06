import 'package:flutter/material.dart';
import '../../widgets/header_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final card = cs.brightness == Brightness.dark ? const Color(0xFF111A2E) : Colors.white;
    final primary = cs.brightness == Brightness.dark ? const Color(0xFFE5E7EB) : const Color(0xFF0F172A);
    final secondary = cs.brightness == Brightness.dark ? const Color(0xFFAAB3C2) : const Color(0xFF6B7280);

    return ListView(
      padding: const EdgeInsets.only(bottom: 110),
      children: [
        const HeaderCard(
          icon: Icons.notifications_active,
          title: 'Notifications',
          subtitle: 'All caught up!',
        ),
        const SizedBox(height: 14),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 18),
          padding: const EdgeInsets.all(18),
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
          child: Column(
            children: [
              Icon(Icons.notifications_none, size: 42, color: secondary),
              const SizedBox(height: 10),
              Text('No notifications yet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w900, color: primary)),
              const SizedBox(height: 6),
              Text(
                "You'll be notified when alarms are triggered",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w700, color: secondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
