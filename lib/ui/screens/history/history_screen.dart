import 'package:flutter/material.dart';
import '../../widgets/header_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 110),
      children: [
        HeaderCard(
          icon: Icons.history,
          title: 'History',
          subtitle: 'Historical data & trends',
          trailing: HeaderPillButton(
            label: 'Export',
            icon: Icons.ios_share,
            onTap: () {},
          ),
        ),
        const SizedBox(height: 14),
        _rangeTabs(context),
        const SizedBox(height: 12),
        _card(
          context,
          title: 'All Metrics Overview',
          child: Container(
            height: 170,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.04)
                  : const Color(0xFFF6F7F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'Multi-line Chart Placeholder',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.brightness == Brightness.dark
                      ? const Color(0xFFAAB3C2)
                      : const Color(0xFF8A94A6),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _card(
          context,
          title: 'Statistics Summary',
          child: Column(
            children: const [
              _SummaryRow('Humidity', '0.0', '0.0', '0.0'),
              _SummaryRow('PM2.5', '0.0', '0.0', '0.0'),
              _SummaryRow('Temperature', '0.0', '0.0', '0.0'),
              _SummaryRow('CO2', '0.0', '0.0', '0.0'),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _rangeTabs(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final card = cs.brightness == Brightness.dark ? const Color(0xFF111A2E) : Colors.white;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(8),
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
      child: Row(
        children: const [
          Expanded(child: _TabChip('24 hours', selected: true)),
          Expanded(child: _TabChip('7 days')),
          Expanded(child: _TabChip('30 days')),
        ],
      ),
    );
  }

  static Widget _card(BuildContext context, {required String title, required Widget child}) {
    final cs = Theme.of(context).colorScheme;
    final card = cs.brightness == Brightness.dark ? const Color(0xFF111A2E) : Colors.white;
    final primary = cs.brightness == Brightness.dark ? const Color(0xFFE5E7EB) : const Color(0xFF0F172A);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(14),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: primary)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String text;
  final bool selected;
  const _TabChip(this.text, {this.selected = false});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final primary = cs.brightness == Brightness.dark ? const Color(0xFFE5E7EB) : const Color(0xFF111827);
    final secondary = cs.brightness == Brightness.dark ? const Color(0xFFAAB3C2) : const Color(0xFF6B7280);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: selected ? (cs.brightness == Brightness.dark ? Colors.white.withOpacity(0.06) : Colors.white) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 12,
          color: selected ? primary : secondary,
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String name;
  final String min;
  final String max;
  final String avg;

  const _SummaryRow(this.name, this.min, this.max, this.avg);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final primary = cs.brightness == Brightness.dark ? const Color(0xFFE5E7EB) : const Color(0xFF0F172A);
    final secondary = cs.brightness == Brightness.dark ? const Color(0xFFAAB3C2) : const Color(0xFF6B7280);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(name, style: TextStyle(fontWeight: FontWeight.w900, color: primary)),
          ),
          Expanded(child: _col(secondary, 'Min', min, primary)),
          Expanded(child: _col(secondary, 'Max', max, primary)),
          Expanded(child: _col(secondary, 'Avg', avg, primary)),
        ],
      ),
    );
  }

  Widget _col(Color secondary, String label, String value, Color primary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: secondary)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: primary)),
      ],
    );
  }
}
