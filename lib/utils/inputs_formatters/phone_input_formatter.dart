import 'package:flutter/services.dart';
import 'package:vibbra_test/utils/inputs_formatters/combine_input_formatter.dart';

class PhoneInputFormatter extends TextInputFormatter
    implements MaxLengthFormatter {
  @override
  int get maxLength => 11;
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newValueLength = newValue.text.length;
    var selectionIndex = newValue.selection.end;
    var substrIndex = 0;
    final newText = StringBuffer();

    if (newValueLength == maxLength) {
      if (newValue.text.toString()[2] != '9') {
        return oldValue;
      }
    }

    if (newValueLength > maxLength) {
      return oldValue;
    }
    if (newValueLength >= 1) {
      newText.write('(');
      if (newValue.selection.end >= 1) selectionIndex++;
    }

    if (newValueLength >= 3) {
      newText.write(newValue.text.substring(0, substrIndex = 2) + ') ');
      if (newValue.selection.end >= 2) selectionIndex += 2;
    }

    if (newValue.text.length == 11) {
      if (newValueLength >= 8) {
        newText.write(newValue.text.substring(2, substrIndex = 7) + '-');
        if (newValue.selection.end >= 7) selectionIndex++;
      }
    } else {
      if (newValueLength >= 7) {
        newText.write(newValue.text.substring(2, substrIndex = 6) + '-');
        if (newValue.selection.end >= 6) selectionIndex++;
      }
    }

    if (newValueLength >= substrIndex) {
      newText.write(newValue.text.substring(substrIndex));
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
