import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePickerTextField extends StatelessWidget {
  final String label;
  final String placeholder;
  final Color? labelColor;
  final TextEditingController controller;
  final double height;

  const CustomDatePickerTextField(
      {super.key,
      required this.label,
      required this.controller,
      this.labelColor,
      this.height = 48,
      this.placeholder = ""});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              color: labelColor ?? Colors.black, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.text,
          readOnly: true,
          style: const TextStyle(
            color: Colors.black,
          ),
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.only(top: 14.0, left: 8),
              suffixIcon: const Icon(
                Icons.today,
                color: Colors.black,
              ),
              hintText: placeholder),
          onTap: () async {
            DateTime? datePicker = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2010),
                lastDate: DateTime(2101));

            if (datePicker != null) {
              final DateFormat data = DateFormat("yyyy-MM-dd");
              String formattedDate = data.format(datePicker);
              controller.text = formattedDate;
            }
          },
        ),
      ],
    );
  }
}
