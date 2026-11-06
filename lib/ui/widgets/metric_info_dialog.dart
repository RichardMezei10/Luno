import 'dart:ui';
import 'package:flutter/material.dart';

class MetricInfoDialog extends StatelessWidget {
  final String title;
  final String meaning;
  final String ranges;
  final String why;
  final String tips;

  const MetricInfoDialog({
    super.key,
    required this.title,
    required this.meaning,
    required this.ranges,
    required this.why,
    required this.tips,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String meaning,
    required String ranges,
    required String why,
    required String tips,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      useRootNavigator: true,
      builder: (_) => MetricInfoDialog(
        title: title,
        meaning: meaning,
        ranges: ranges,
        why: why,
        tips: tips,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = cs.brightness == Brightness.dark;

    final bg = isDark ? const Color(0xFF111A2E) : Colors.white;
    final primary = isDark ? const Color(0xFFE5E7EB) : const Color(0xFF0F172A);
    final secondary = isDark ? const Color(0xFFAAB3C2) : const Color(0xFF6B7280);

    Widget section(String label, String text) => Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: primary)),
              const SizedBox(height: 6),
              Text(text, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: secondary, height: 1.3)),
            ],
          ),
        );

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(color: Colors.black.withOpacity(0.35)),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Dialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(blurRadius: 26, offset: Offset(0, 14), color: Color(0x33000000))
                    ],
                    border: isDark ? Border.all(color: Colors.white.withOpacity(0.06)) : null,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: TextStyle(color: primary, fontSize: 18, fontWeight: FontWeight.w900),
                              ),
                            ),
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Icon(Icons.close, color: secondary),
                            )
                          ],
                        ),

                        section('What it is', meaning),
                        section('Good ranges', ranges),
                        section('Why it matters', why),
                        section('Tips', tips),

                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2F5BFF),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('Got it', style: TextStyle(fontWeight: FontWeight.w900)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
