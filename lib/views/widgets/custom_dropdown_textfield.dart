import 'package:flutter/material.dart';

class CustomDropdownTextField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> list;
  final bool hasError;

  final Function(String? value) onChanged;

  const CustomDropdownTextField(
      {super.key,
      required this.label,
      required this.list,
      required this.onChanged,
      required this.value,
      this.hasError = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: hasError ? Colors.red : Colors.grey),
          ),
          height: 60.0,
          child: DropdownButton<String>(
            isExpanded: true,
            isDense: true,
            value: value,
            style: const TextStyle(color: Colors.black),
            underline: Container(),
            onChanged: onChanged,
            items: list
                .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
