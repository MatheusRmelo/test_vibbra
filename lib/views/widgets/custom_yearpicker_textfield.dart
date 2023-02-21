import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomYearPickerTextField extends StatefulWidget {
  final String label;
  final String placeholder;
  final Color? labelColor;
  final double height;
  final String value;
  final Function(String? value) onChanged;

  const CustomYearPickerTextField(
      {super.key,
      required this.label,
      required this.value,
      required this.onChanged,
      this.labelColor,
      this.height = 48,
      this.placeholder = ""});

  @override
  State<CustomYearPickerTextField> createState() =>
      _CustomYearPickerTextFieldState();
}

class _CustomYearPickerTextFieldState extends State<CustomYearPickerTextField> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
              color: widget.labelColor ?? Colors.black,
              fontWeight: FontWeight.bold),
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
              hintText: widget.placeholder),
          onTap: () async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Escolha um ano"),
                  content: Container(
                    // Need to use container to add size constraint.
                    width: 300,
                    height: 300,
                    child: YearPicker(
                      firstDate: DateTime(DateTime.now().year - 100, 1),
                      lastDate: DateTime(DateTime.now().year + 100, 1),
                      initialDate: DateTime.now(),
                      // save the selected date to _selectedDate DateTime variable.
                      // It's used to set the previous selected date when
                      // re-showing the dialog.
                      selectedDate: DateTime.now(),
                      onChanged: (DateTime dateTime) {
                        // close the dialog when year is selected.
                        Navigator.pop(context);
                        controller.text = dateTime.year.toString();
                        widget.onChanged(dateTime.year.toString());
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
