import 'package:flutter/material.dart';
import '../../widgets/header_card.dart';
import '../../widgets/add_device_dialog.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  final List<Map<String, dynamic>> devices = [
    {
      'name': 'Bedroom',
      'id': 'RPI-001',
      'location': 'Bedroom',
      'description': '',
      'online': true,
      'lastSeen': 'Jan 15, 12:00',
    }
  ];

  int _nextId = 2;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.only(bottom: 110),
      children: [
        const HeaderCard(
          icon: Icons.sensors,
          title: 'Devices',
          subtitle: 'Manage your sensors',
        ),
        const SizedBox(height: 14),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: SizedBox(
            height: 46,
            child: ElevatedButton.icon(
              onPressed: () async {
                final result = await showDialog<Map<String, dynamic>>(
                  context: context,
                  barrierDismissible: true,
                  useRootNavigator: true,
                  builder: (_) => const AddDeviceDialog(),
                );

                if (result != null && mounted) {
                  setState(() {
                    devices.add({
                      'name': result['name']?.toString().isNotEmpty == true
                          ? result['name']
                          : 'Device $_nextId',
                      'id': 'RPI-${_nextId.toString().padLeft(3, '0')}',
                      'location': result['location'] ?? 'Living room',
                      'description': result['description'] ?? '',
                      'online': true,
                      'lastSeen': 'Just now',
                    });
                    _nextId++;
                  });
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Add New Device', style: TextStyle(fontWeight: FontWeight.w900)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2F5BFF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        if (devices.isEmpty)
          _emptyState(context)
        else
          ...List.generate(devices.length, (i) => _deviceCard(context, cs, i)),
      ],
    );
  }

  Widget _emptyState(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final card = cs.brightness == Brightness.dark ? const Color(0xFF111A2E) : Colors.white;
    final primary = cs.brightness == Brightness.dark ? const Color(0xFFE5E7EB) : const Color(0xFF0F172A);
    final secondary = cs.brightness == Brightness.dark ? const Color(0xFFAAB3C2) : const Color(0xFF6B7280);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(14),
        border: cs.brightness == Brightness.dark ? Border.all(color: Colors.white.withOpacity(0.06)) : null,
        boxShadow: cs.brightness == Brightness.dark
            ? const []
            : const [BoxShadow(blurRadius: 10, offset: Offset(0, 6), color: Color(0x1A000000))],
      ),
      child: Column(
        children: [
          Icon(Icons.sensors_off, size: 42, color: secondary),
          const SizedBox(height: 10),
          Text('No devices yet', style: TextStyle(fontWeight: FontWeight.w900, color: primary)),
          const SizedBox(height: 6),
          Text('Tap “Add New Device” to add one.',
              style: TextStyle(fontWeight: FontWeight.w700, color: secondary)),
        ],
      ),
    );
  }

  Widget _deviceCard(BuildContext context, ColorScheme cs, int index) {
    final d = devices[index];

    final card = cs.brightness == Brightness.dark ? const Color(0xFF111A2E) : Colors.white;
    final primary = cs.brightness == Brightness.dark ? const Color(0xFFE5E7EB) : const Color(0xFF0F172A);
    final secondary = cs.brightness == Brightness.dark ? const Color(0xFFAAB3C2) : const Color(0xFF6B7280);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(14),
        border: cs.brightness == Brightness.dark ? Border.all(color: Colors.white.withOpacity(0.06)) : null,
        boxShadow: cs.brightness == Brightness.dark
            ? const []
            : const [BoxShadow(blurRadius: 10, offset: Offset(0, 6), color: Color(0x1A000000))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: cs.brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.06)
                  : const Color(0xFFF1F5F9),
            ),
            child: Icon(Icons.sensors, color: primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(d['name'] ?? 'Device',
                          style: TextStyle(fontWeight: FontWeight.w900, color: primary)),
                    ),

                    // EDIT
                    InkWell(
                      onTap: () async {
                        final result = await showDialog<Map<String, dynamic>>(
                          context: context,
                          barrierDismissible: true,
                          useRootNavigator: true,
                          builder: (_) => AddDeviceDialog(
                            initial: {
                              'name': d['name'] ?? '',
                              'location': d['location'] ?? 'Living room',
                              'description': d['description'] ?? '',
                            },
                          ),
                        );

                        if (result != null && mounted) {
                          setState(() {
                            devices[index]['name'] = result['name'];
                            devices[index]['location'] = result['location'];
                            devices[index]['description'] = result['description'];
                            devices[index]['lastSeen'] = 'Just now';
                          });
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        child: Text(
                          'Edit',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                            color: Color(0xFF2F5BFF),
                          ),
                        ),
                      ),
                    ),

                    // DELETE
                    InkWell(
                      onTap: () async {
                        final ok = await _confirmDelete(context, d['name']?.toString() ?? 'device');
                        if (ok && mounted) {
                          setState(() => devices.removeAt(index));
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: Icon(Icons.delete, color: Colors.red, size: 20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                Text('ID: ${d['id'] ?? '-'}',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: secondary)),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Icon(Icons.circle, size: 10, color: (d['online'] == true) ? const Color(0xFF16A34A) : Colors.red),
                    const SizedBox(width: 6),
                    Text((d['online'] == true) ? 'ONLINE' : 'OFFLINE',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: primary)),
                    const SizedBox(width: 12),
                    Icon(Icons.access_time, size: 14, color: secondary),
                    const SizedBox(width: 6),
                    Text('Last seen: ${d['lastSeen'] ?? '-'}',
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: secondary)),
                  ],
                ),

                if ((d['description'] ?? '').toString().trim().isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    d['description'],
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: secondary),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context, String name) async {
    return (await showDialog<bool>(
          context: context,
          builder: (_) {
            final cs = Theme.of(context).colorScheme;
            final isDark = cs.brightness == Brightness.dark;
            final bg = isDark ? const Color(0xFF111A2E) : Colors.white;
            final primary = isDark ? const Color(0xFFE5E7EB) : const Color(0xFF0F172A);

            return AlertDialog(
              backgroundColor: bg,
              title: Text('Delete device?', style: TextStyle(color: primary, fontWeight: FontWeight.w900)),
              content: Text('Delete "$name"?', style: TextStyle(color: primary.withOpacity(0.85))),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Delete', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w900)),
                ),
              ],
            );
          },
        )) ??
        false;
  }
}
