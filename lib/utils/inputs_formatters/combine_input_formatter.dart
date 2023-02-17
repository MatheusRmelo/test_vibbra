import 'package:flutter/services.dart';

class CombineInputFormatter extends TextInputFormatter {
  final List<MaxLengthFormatter> _formatters;

  CombineInputFormatter(this._formatters);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final delegatedFormatter = _formatters.firstWhere(
        (element) => newValue.text.length <= element.maxLength, orElse: () {
      return _formatters.first;
    });
    return delegatedFormatter.formatEditUpdate(oldValue, newValue);
  }
}

mixin MaxLengthFormatter on TextInputFormatter {
  int get maxLength;
}
