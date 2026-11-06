import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../widgets/air_quality_header.dart';
import '../../widgets/metric_card.dart';
import '../../widgets/metric_info_dialog.dart';

class AirQualityScreen extends StatefulWidget {
  const AirQualityScreen({super.key});

  @override
  State<AirQualityScreen> createState() => _AirQualityScreenState();
}

enum MetricType { humidity, pm25, temperature, co2, voc }

class _AirQualityScreenState extends State<AirQualityScreen> {
  bool simple = true;
  MetricType selected = MetricType.humidity;

  // ✅ no late crash
  final Map<MetricType, List<double>> series = {};

  @override
  void initState() {
    super.initState();
    series.addAll({
      MetricType.humidity: _genSeries(base: 50, noise: 6, min: 20, max: 80),
      MetricType.pm25: _genSeries(base: 8, noise: 4, min: 0, max: 40),
      MetricType.temperature: _genSeries(base: 21.5, noise: 1.2, min: 16, max: 30),
      MetricType.co2: _genSeries(base: 550, noise: 80, min: 350, max: 2000),
      MetricType.voc: _genSeries(base: 120, noise: 40, min: 0, max: 600),
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 110),
      children: [
        AirQualityHeader(
          simpleSelected: simple,
          onSimple: () => setState(() => simple = true),
          onAdvanced: () => setState(() => simple = false),
        ),
        if (simple) ..._simpleCards() else ..._advancedLayout(),
      ],
    );
  }

  // ───────────────────────── SIMPLE VIEW
  List<Widget> _simpleCards() {
    return [
      MetricCard(
        icon: Icons.water_drop,
        title: 'Humidity',
        value: '50.1',
        unit: '%',
        subtitle: 'Optimal: 30-60%',
        badge: 'Optimal',
        progress: 0.55,
        progressColor: const Color(0xFF2F7EF7),
        onInfo: () => MetricInfoDialog.show(
          context,
          title: 'Humidity (%)',
          meaning: 'Humidity is how much water vapor is in the air.',
          ranges: 'Comfortable indoors is usually about 30–60%.',
          why: 'Low humidity can dry skin/airways. High humidity can increase mold risk.',
          tips: 'Use a humidifier if low, or ventilate/dehumidify if high.',
        ),
      ),
      MetricCard(
        icon: Icons.grass,
        title: 'PM2.5',
        value: '7.9',
        unit: 'µg/m³',
        subtitle: 'Optimal: ≤12 µg/m³',
        badge: 'Optimal',
        progress: 0.35,
        progressColor: const Color(0xFF2F7EF7),
        onInfo: () => MetricInfoDialog.show(
          context,
          title: 'PM2.5 (µg/m³)',
          meaning: 'Fine particles smaller than 2.5µm that can get deep into lungs.',
          ranges: 'Lower is better. Many guides treat ≤12 µg/m³ as “good”.',
          why: 'High PM2.5 can irritate lungs and worsen asthma/allergies.',
          tips: 'Use an air purifier, avoid smoke/candles, ventilate when outdoor air is good.',
        ),
      ),
      MetricCard(
        icon: Icons.device_thermostat,
        title: 'Temperature',
        value: '20.2',
        unit: '°C',
        subtitle: 'Optimal: 18-24 °C',
        badge: 'Optimal',
        progress: 0.62,
        progressColor: const Color(0xFFD93025),
        onInfo: () => MetricInfoDialog.show(
          context,
          title: 'Temperature (°C)',
          meaning: 'How warm/cold the room air is.',
          ranges: 'A common comfort range is about 18–24°C (varies by person).',
          why: 'Extreme temps affect sleep, comfort, and can change humidity.',
          tips: 'Avoid big swings. Tune heating/cooling for steady comfort.',
        ),
      ),
      MetricCard(
        icon: Icons.cloud,
        title: 'CO2',
        value: '428',
        unit: 'ppm',
        subtitle: 'Optimal: ≤1000 ppm',
        badge: 'Optimal',
        progress: 0.25,
        progressColor: const Color(0xFF2F7EF7),
        onInfo: () => MetricInfoDialog.show(
          context,
          title: 'CO₂ (ppm)',
          meaning: 'CO₂ rises indoors when people breathe in a closed room.',
          ranges: 'Many consider ≤1000 ppm good; higher often means poor ventilation.',
          why: 'High CO₂ can correlate with sleepiness and “stuffy” air.',
          tips: 'Open a window or use ventilation when CO₂ stays high.',
        ),
      ),
    ];
  }

  // ───────────────────────── ADVANCED VIEW
  List<Widget> _advancedLayout() {
    if (series.isEmpty) return [const SizedBox(height: 12)];

    final data = series[selected] ?? const <double>[];
    final stats = _stats(data);

    return [
      const SizedBox(height: 12),
      _metricSelector(),
      const SizedBox(height: 12),
      _trendCard(data),
      const SizedBox(height: 12),
      _minAvgMax(stats.min, stats.avg, stats.max),
      const SizedBox(height: 12),
    ];
  }

  Widget _metricSelector() {
    final cs = Theme.of(context).colorScheme;
    final isDark = cs.brightness == Brightness.dark;
    final card = isDark ? const Color(0xFF111A2E) : Colors.white;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(14),
        border: isDark ? Border.all(color: Colors.white.withOpacity(0.06)) : null,
        boxShadow: isDark
            ? const []
            : const [BoxShadow(blurRadius: 10, offset: Offset(0, 6), color: Color(0x1A000000))],
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          _MetricChip(label: 'Humidity', selected: selected == MetricType.humidity, onTap: () => setState(() => selected = MetricType.humidity)),
          _MetricChip(label: 'PM2.5', selected: selected == MetricType.pm25, onTap: () => setState(() => selected = MetricType.pm25)),
          _MetricChip(label: 'Temperature', selected: selected == MetricType.temperature, onTap: () => setState(() => selected = MetricType.temperature)),
          _MetricChip(label: 'CO2', selected: selected == MetricType.co2, onTap: () => setState(() => selected = MetricType.co2)),
          _MetricChip(label: 'VOC', selected: selected == MetricType.voc, onTap: () => setState(() => selected = MetricType.voc)),
        ],
      ),
    );
  }

  Widget _trendCard(List<double> data) {
    final cs = Theme.of(context).colorScheme;
    final isDark = cs.brightness == Brightness.dark;

    final card = isDark ? const Color(0xFF111A2E) : Colors.white;
    final primary = isDark ? const Color(0xFFE5E7EB) : const Color(0xFF0F172A);
    final secondary = isDark ? const Color(0xFFAAB3C2) : const Color(0xFF6B7280);

    final meta = _meta(selected);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(14),
        border: isDark ? Border.all(color: Colors.white.withOpacity(0.06)) : null,
        boxShadow: isDark
            ? const []
            : const [BoxShadow(blurRadius: 10, offset: Offset(0, 6), color: Color(0x1A000000))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('${meta.title} Trend',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: primary)),
              ),
              Text('Last 24h',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: secondary)),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 190,
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  enabled: true,
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipRoundedRadius: 10,
                    getTooltipItems: (spots) {
                      return spots.map((s) {
                        final v = s.y;
                        return LineTooltipItem(
                          '${v.toStringAsFixed(meta.decimals)} ${meta.unit}',
                          TextStyle(fontWeight: FontWeight.w900, color: primary),
                        );
                      }).toList();
                    },
                  ),
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 6,
                      getTitlesWidget: (value, metaAxis) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            '${value.toInt()}h',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: secondary),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                minX: 0,
                maxX: (data.length - 1).toDouble(),
                minY: _minY(data),
                maxY: _maxY(data),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(data.length, (i) => FlSpot(i.toDouble(), data[i])),
                    isCurved: true,
                    barWidth: 3,
                    color: meta.color,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: meta.color.withOpacity(isDark ? 0.12 : 0.18),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _minAvgMax(double min, double avg, double max) {
    final cs = Theme.of(context).colorScheme;
    final isDark = cs.brightness == Brightness.dark;

    final card = isDark ? const Color(0xFF111A2E) : Colors.white;
    final primary = isDark ? const Color(0xFFE5E7EB) : const Color(0xFF111827);
    final secondary = isDark ? const Color(0xFFAAB3C2) : const Color(0xFF6B7280);

    final meta = _meta(selected);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(14),
        border: isDark ? Border.all(color: Colors.white.withOpacity(0.06)) : null,
        boxShadow: isDark
            ? const []
            : const [BoxShadow(blurRadius: 10, offset: Offset(0, 6), color: Color(0x1A000000))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatCell(label: 'Min', value: '${min.toStringAsFixed(meta.decimals)} ${meta.unit}', primary: primary, secondary: secondary),
          _StatCell(label: 'AVG', value: '${avg.toStringAsFixed(meta.decimals)} ${meta.unit}', primary: primary, secondary: secondary),
          _StatCell(label: 'Max', value: '${max.toStringAsFixed(meta.decimals)} ${meta.unit}', primary: primary, secondary: secondary),
        ],
      ),
    );
  }

  // ───────────────────────── Helpers
  List<double> _genSeries({
    required double base,
    required double noise,
    required double min,
    required double max,
    int points = 24,
  }) {
    final r = Random();
    return List.generate(points, (i) {
      final wave = sin(i / 3.5) * (noise * 0.6);
      final n = (r.nextDouble() - 0.5) * noise;
      final v = base + wave + n;
      return v.clamp(min, max);
    });
  }

  _Stats _stats(List<double> data) {
    if (data.isEmpty) return const _Stats(min: 0, avg: 0, max: 0);
    final min = data.reduce((a, b) => a < b ? a : b);
    final max = data.reduce((a, b) => a > b ? a : b);
    final avg = data.reduce((a, b) => a + b) / data.length;
    return _Stats(min: min, avg: avg, max: max);
  }

  double _minY(List<double> data) {
    if (data.isEmpty) return 0;
    final s = _stats(data);
    final pad = max(1, (s.max - s.min) * 0.15);
    return s.min - pad;
  }

  double _maxY(List<double> data) {
    if (data.isEmpty) return 1;
    final s = _stats(data);
    final pad = max(1, (s.max - s.min) * 0.15);
    return s.max + pad;
  }

  _MetricMeta _meta(MetricType t) {
    switch (t) {
      case MetricType.humidity:
        return const _MetricMeta(title: 'Humidity', unit: '%', decimals: 1, color: Color(0xFF2F7EF7));
      case MetricType.pm25:
        return const _MetricMeta(title: 'PM2.5', unit: 'µg/m³', decimals: 1, color: Color(0xFF2F7EF7));
      case MetricType.temperature:
        return const _MetricMeta(title: 'Temperature', unit: '°C', decimals: 1, color: Color(0xFFD93025));
      case MetricType.co2:
        return const _MetricMeta(title: 'CO2', unit: 'ppm', decimals: 0, color: Color(0xFF16A34A));
      case MetricType.voc:
        return const _MetricMeta(title: 'VOC', unit: 'ppb', decimals: 0, color: Color(0xFFF59E0B));
    }
  }
}

// ───────────────────────── UI pieces

class _MetricChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _MetricChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = cs.brightness == Brightness.dark;

    final bg = selected
        ? (isDark ? Colors.white.withOpacity(0.10) : const Color(0xFFEFF6FF))
        : (isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFF1F5F9));

    final fg = selected
        ? (isDark ? const Color(0xFFE5E7EB) : const Color(0xFF0F172A))
        : (isDark ? const Color(0xFFAAB3C2) : const Color(0xFF6B7280));

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          border: selected ? Border.all(color: const Color(0xFF2F5BFF).withOpacity(0.45)) : null,
        ),
        child: Text(label, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: fg)),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  final Color primary;
  final Color secondary;

  const _StatCell({
    required this.label,
    required this.value,
    required this.primary,
    required this.secondary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: secondary)),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: primary)),
      ],
    );
  }
}

class _Stats {
  final double min;
  final double avg;
  final double max;
  const _Stats({required this.min, required this.avg, required this.max});
}

class _MetricMeta {
  final String title;
  final String unit;
  final int decimals;
  final Color color;
  const _MetricMeta({
    required this.title,
    required this.unit,
    required this.decimals,
    required this.color,
  });
}
