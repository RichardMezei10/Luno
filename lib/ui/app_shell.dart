import 'package:flutter/material.dart';

import 'screens/air_quality/air_quality_screen.dart' as aq;
import 'screens/history/history_screen.dart' as hist;
import 'screens/devices/devices_screen.dart' as dev;
import 'screens/notifications/notifications_screen.dart' as noti;
import 'screens/settings/settings_screen.dart';

import 'widgets/pill_nav.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int index = 0;

  final pages = const [
    aq.AirQualityScreen(),
    hist.HistoryScreen(),
    dev.DevicesScreen(),
    noti.NotificationsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(child: pages[index]),
            Positioned(
              left: 16,
              right: 16,
              bottom: 18,
              child: PillNav(
                index: index,
                onChanged: (i) => setState(() => index = i),
                items: const [
                  PillNavItem('Air quality', Icons.air),
                  PillNavItem('History', Icons.history),
                  PillNavItem('Devices', Icons.sensors),
                  PillNavItem('Notification', Icons.notifications_active),
                  PillNavItem('Settings', Icons.settings),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
