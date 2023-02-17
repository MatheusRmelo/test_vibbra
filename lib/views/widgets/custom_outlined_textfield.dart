import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibbra_test/models/error.dart';

class CustomOutlinedTextField extends StatefulWidget {
  final String label;
  final String placeholder;
  final TextEditingController? controller;
  final Function(String? value)? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final bool obscureText;
  final List<Error> errors;
  final String? initialValue;

  const CustomOutlinedTextField(
      {super.key,
      required this.label,
      required this.errors,
      this.controller,
      this.onChanged,
      this.prefixIcon,
      this.suffixIcon,
      this.keyboardType,
      this.placeholder = '',
      this.obscureText = false,
      this.inputFormatters = const [],
      this.initialValue});

  @override
  State<CustomOutlinedTextField> createState() =>
      _CustomOutlinedTextFieldState();
}

class _CustomOutlinedTextFieldState extends State<CustomOutlinedTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          onChanged: widget.onChanged,
          controller: widget.controller,
          obscureText: widget.obscureText,
          inputFormatters: widget.inputFormatters,
          initialValue: widget.initialValue,
          keyboardType: widget.keyboardType ?? TextInputType.text,
          style: const TextStyle(
            color: Colors.black,
          ),
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              errorText:
                  widget.errors.isNotEmpty ? widget.errors.first.message : null,
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
              hintText: widget.placeholder),
        ),
      ],
    );
  }
}
