import 'package:flutter/material.dart';

class CustomCheckboxTextField extends StatelessWidget {
  final String label;
  final bool isActive;
  final Function(bool) onChanged;

  const CustomCheckboxTextField(
      {super.key,
      required this.label,
      required this.isActive,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            value: isActive,
            onChanged: (value) {
              onChanged(value ?? false);
            }),
        const SizedBox(
          width: 8,
        ),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
