import 'dart:ui';
import 'package:flutter/material.dart';

class PillNavItem {
  final String label;
  final IconData icon;
  const PillNavItem(this.label, this.icon);
}

class PillNav extends StatelessWidget {
  final int index;
  final List<PillNavItem> items;
  final ValueChanged<int> onChanged;

  const PillNav({
    super.key,
    required this.index,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: const Color(0xFF4B5563).withOpacity(0.60),
            border: Border.all(color: Colors.white.withOpacity(0.14)),
            boxShadow: const [
              BoxShadow(
                blurRadius: 18,
                offset: Offset(0, 10),
                color: Color(0x22000000),
              )
            ],
          ),
          child: Row(
            children: List.generate(items.length, (i) {
              final selected = i == index;
              final fg = selected
                  ? const Color(0xFF2F5BFF)
                  : Colors.white.withOpacity(0.92);

              return Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => onChanged(i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(items[i].icon, size: 18, color: fg),
                        const SizedBox(height: 4),
                        Text(
                          items[i].label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            height: 1.1,
                            fontWeight: FontWeight.w800,
                            color: fg,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
