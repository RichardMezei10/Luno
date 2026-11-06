import 'dart:async';
import 'package:flutter/material.dart';

class SetupScan extends StatefulWidget {
  final void Function(String foundName) onFound;

  const SetupScan({super.key, required this.onFound});

  @override
  State<SetupScan> createState() => _SetupScanState();
}

class _SetupScanState extends State<SetupScan> {
  Timer? _t;
  double progress = 0;

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(milliseconds: 120), (t) {
      setState(() => progress = (progress + 0.03).clamp(0, 1));
      if (progress >= 1) {
        t.cancel();
        widget.onFound('RPI-001'); // demo “found device”
      }
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1B2740), Color(0xFF0F1626)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Scanning for devices…',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Make sure your sensor is powered on.\n(This is a demo scan.)',
                  style: TextStyle(color: Color(0xFFB6C0D1), fontSize: 13, fontWeight: FontWeight.w700, height: 1.4),
                ),
                const Spacer(),

                Center(
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.06),
                      border: Border.all(color: Colors.white.withOpacity(0.14)),
                    ),
                    child: const Icon(Icons.wifi_tethering, color: Colors.white, size: 46),
                  ),
                ),

                const SizedBox(height: 24),

                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor: Colors.white.withOpacity(0.10),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF2F5BFF)),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(color: Color(0xFFB6C0D1), fontWeight: FontWeight.w800),
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
