import 'dart:ui';
import 'package:flutter/material.dart';

class HeaderCard extends StatelessWidget {
  final IconData? icon; // ✅ optional now
  final String? iconAsset; // ✅ new for PNG
  final String title;
  final String subtitle;
  final Widget? trailing;

  const HeaderCard({
    super.key,
    this.icon,
    this.iconAsset,
    required this.title,
    required this.subtitle,
    this.trailing,
  }) : assert(icon != null || iconAsset != null,
            'Provide either icon or iconAsset');

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(18, 26, 18, 24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1B2740), Color(0xFF0F1626)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _IconBadge(icon: icon, iconAsset: iconAsset),
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
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              height: 1.05,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        if (trailing != null) trailing!,
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFFB6C0D1),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  final IconData? icon;
  final String? iconAsset;

  const _IconBadge({
    required this.icon,
    required this.iconAsset,
  });

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (iconAsset != null) {
      child = Image.asset(
        iconAsset!,
        width: 28,
        height: 28,
        fit: BoxFit.contain,
      );
    } else {
      child = Icon(icon, color: Colors.white, size: 26);
    }

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF2F5BFF).withOpacity(0.60),
            const Color(0xFF2F5BFF).withOpacity(0.18),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.10)),
      ),
      child: Center(child: child),
    );
  }
}

class HeaderPillButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const HeaderPillButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Material(
          color: Colors.white.withOpacity(0.92),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      color: Color(0xFF0B1220),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(icon, size: 16, color: const Color(0xFF0B1220)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
