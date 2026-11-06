import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ui/app_shell.dart';
import 'ui/setup/setup_flow.dart';

import 'ui/splash/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AirApp());
}

final themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);

class AirApp extends StatelessWidget {
  const AirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (_, mode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'RoomAir',
          themeMode: mode,
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFFF4F5F7),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF2F5BFF),
              brightness: Brightness.light,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFF0B1220),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF2F5BFF),
              brightness: Brightness.dark,
            ),
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}

class BootGate extends StatelessWidget {
  const BootGate({super.key});

  Future<bool> _isSetupDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('setup_done') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isSetupDone(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final done = snap.data!;
        return done ? const AppShell() : const SetupFlow();
      },
    );
  }
}
