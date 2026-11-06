import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_shell.dart';
import 'steps/setup_welcome.dart';
import 'steps/setup_scan.dart';
import 'steps/setup_finish.dart';

class SetupFlow extends StatefulWidget {
  const SetupFlow({super.key});

  @override
  State<SetupFlow> createState() => _SetupFlowState();
}

class _SetupFlowState extends State<SetupFlow> {
  String deviceName = 'RPI-001';
  String location = 'Living room';

  Future<void> _completeSetup() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('setup_done', true);
    await prefs.setString('setup_device_name', deviceName);
    await prefs.setString('setup_device_location', location);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AppShell()),
    );
  }

  void _goToScan() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SetupScan(
          onFound: (foundName) {
            setState(() => deviceName = foundName);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => SetupFinish(
                  initialDeviceName: deviceName,
                  initialLocation: location,
                  onChanged: (name, loc) {
                    setState(() {
                      deviceName = name;
                      location = loc;
                    });
                  },
                  onFinish: _completeSetup,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SetupWelcome(
      onStart: _goToScan,
      onSkip: _completeSetup,
    );
  }
}
