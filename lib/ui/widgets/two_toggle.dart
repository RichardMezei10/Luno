import 'package:flutter/material.dart';

class TwoToggle extends StatelessWidget {
  final bool leftSelected;
  final String left;
  final String right;
  final VoidCallback onLeft;
  final VoidCallback onRight;

  const TwoToggle({
    super.key,
    required this.leftSelected,
    required this.left,
    required this.right,
    required this.onLeft,
    required this.onRight,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
      child: Row(
        children: [
          Expanded(
            child: _Btn(
              label: left,
              selected: leftSelected,
              onTap: onLeft,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _Btn(
              label: right,
              selected: !leftSelected,
              onTap: onRight,
            ),
          ),
        ],
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Btn({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? Colors.white : const Color(0xFF2B3447);
    final fg = selected ? Colors.black : Colors.white;

    return Material(
      color: bg,
      elevation: selected ? 4 : 0,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: fg,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
