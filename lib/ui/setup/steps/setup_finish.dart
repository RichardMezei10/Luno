import 'package:flutter/material.dart';

class SetupFinish extends StatefulWidget {
  final String initialDeviceName;
  final String initialLocation;
  final void Function(String name, String location) onChanged;
  final VoidCallback onFinish;

  const SetupFinish({
    super.key,
    required this.initialDeviceName,
    required this.initialLocation,
    required this.onChanged,
    required this.onFinish,
  });

  @override
  State<SetupFinish> createState() => _SetupFinishState();
}

class _SetupFinishState extends State<SetupFinish> {
  late final TextEditingController _name;
  late String location;

  final locations = const [
    'Living room',
    'Bedroom',
    'Kitchen',
    'Office',
    'Bathroom',
  ];

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.initialDeviceName);
    location = widget.initialLocation;
    if (!locations.contains(location)) location = 'Living room';
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = cs.brightness == Brightness.dark;

    final card = isDark ? const Color(0xFF111A2E) : Colors.white;
    final field = isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFF1F5F9);

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
                  'Device found!',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Choose a name and location.\nThis is only for show — data will come later.',
                  style: TextStyle(color: Color(0xFFB6C0D1), fontSize: 13, fontWeight: FontWeight.w700, height: 1.4),
                ),
                const SizedBox(height: 18),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: card,
                    borderRadius: BorderRadius.circular(14),
                    border: isDark ? Border.all(color: Colors.white.withOpacity(0.06)) : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Device name', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _name,
                        onChanged: (v) => widget.onChanged(v, location),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: field,
                          hintText: 'RPI-001',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('Location', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(color: field, borderRadius: BorderRadius.circular(10)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: location,
                            isExpanded: true,
                            items: locations.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                            onChanged: (v) {
                              setState(() => location = v ?? location);
                              widget.onChanged(_name.text, location);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: widget.onFinish,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2F5BFF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Finish setup', style: TextStyle(fontWeight: FontWeight.w900)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
