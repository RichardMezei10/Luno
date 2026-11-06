import 'dart:ui';
import 'package:flutter/material.dart';

class AddDeviceDialog extends StatefulWidget {
  final Map<String, dynamic>? initial;

  const AddDeviceDialog({
    super.key,
    this.initial,
  });

  @override
  State<AddDeviceDialog> createState() => _AddDeviceDialogState();
}

class _AddDeviceDialogState extends State<AddDeviceDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _descController;

  final List<String> locations = const [
    'Living room',
    'Bedroom',
    'Kitchen',
    'Office',
    'Bathroom',
  ];

  late String location;

  @override
  void initState() {
    super.initState();
    final init = widget.initial;
    _nameController = TextEditingController(text: init?['name'] ?? 'RPI-002');
    _descController = TextEditingController(text: init?['description'] ?? '');
    location = init?['location'] ?? 'Living room';
    if (!locations.contains(location)) location = 'Living room';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = cs.brightness == Brightness.dark;

    final dialogBg = isDark ? const Color(0xFF111A2E) : Colors.white;
    final fieldBg = isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFF1F5F9);
    final primaryText = isDark ? const Color(0xFFE5E7EB) : const Color(0xFF0F172A);
    final hintText = isDark ? const Color(0xFFAAB3C2) : const Color(0xFF6B7280);

    final isEdit = widget.initial != null;

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
              constraints: const BoxConstraints(maxWidth: 340),
              child: Dialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
                  decoration: BoxDecoration(
                    color: dialogBg,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 26,
                        offset: Offset(0, 14),
                        color: Color(0x33000000),
                      )
                    ],
                    border: isDark
                        ? Border.all(color: Colors.white.withOpacity(0.06))
                        : null,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEdit ? 'Edit device' : 'Add device',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: primaryText,
                          ),
                        ),
                        const SizedBox(height: 16),

                        _label('Device name', primaryText),
                        _input(_nameController, fieldBg, primaryText, hintText, 'RPI-002'),

                        const SizedBox(height: 12),

                        _label('Location', primaryText),
                        _dropdown(fieldBg, primaryText),

                        const SizedBox(height: 12),

                        _label('Description', primaryText),
                        _input(_descController, fieldBg, primaryText, hintText, 'Description'),

                        const SizedBox(height: 18),

                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context, {
                                    'name': _nameController.text.trim(),
                                    'location': location,
                                    'description': _descController.text.trim(),
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2F5BFF),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  isEdit ? 'Save' : 'Add',
                                  style: const TextStyle(fontWeight: FontWeight.w900),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(fontWeight: FontWeight.w900),
                                ),
                              ),
                            ),
                          ],
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

  Widget _label(String text, Color color) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: color)),
      );

  Widget _input(TextEditingController c, Color bg, Color txt, Color hint, String h) {
    return TextField(
      controller: c,
      style: TextStyle(color: txt, fontWeight: FontWeight.w700),
      decoration: InputDecoration(
        hintText: h,
        hintStyle: TextStyle(color: hint),
        filled: true,
        fillColor: bg,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _dropdown(Color bg, Color txt) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: location,
          isExpanded: true,
          items: locations
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => setState(() => location = v ?? location),
        ),
      ),
    );
  }
}
