import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String unit;
  final String subtitle;
  final String badge;
  final double progress;
  final Color progressColor;

  final VoidCallback? onInfo; // ✅ info popup callback

  const MetricCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.unit,
    required this.subtitle,
    required this.badge,
    required this.progress,
    required this.progressColor,
    this.onInfo,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final isDark = cs.brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF111A2E) : Colors.white;
    final textPrimary = isDark ? const Color(0xFFE5E7EB) : const Color(0xFF0F172A);
    final textSecondary = isDark ? const Color(0xFFAAB3C2) : const Color(0xFF6B7280);

    return Container(
      margin: const EdgeInsets.fromLTRB(18, 10, 18, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: isDark ? Border.all(color: Colors.white.withOpacity(0.06)) : null,
        boxShadow: isDark
            ? const []
            : const [
                BoxShadow(
                  blurRadius: 10,
                  offset: Offset(0, 6),
                  color: Color(0x1A000000),
                )
              ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFF1F5F9),
            ),
            child: Icon(icon, size: 22, color: textPrimary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                          color: textPrimary,
                        ),
                      ),
                    ),

                    // ✅ Info icon
                    if (onInfo != null)
                      InkWell(
                        borderRadius: BorderRadius.circular(999),
                        onTap: onInfo,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(Icons.info_outline, size: 18, color: textSecondary),
                        ),
                      ),

                    const SizedBox(width: 6),

                    Row(
                      children: [
                        const Icon(Icons.verified, size: 16, color: Color(0xFF23A55A)),
                        const SizedBox(width: 4),
                        Text(
                          badge,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF23A55A),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        unit,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0, 1),
                    minHeight: 7,
                    backgroundColor: isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFE5E7EB),
                    valueColor: AlwaysStoppedAnimation(progressColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
