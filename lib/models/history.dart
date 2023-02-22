import 'package:vibbra_test/models/expense.dart';
import 'package:vibbra_test/models/invoice.dart';

class History {
  LaunchType type;
  Expense? expense;
  Invoice? invoice;

  String get title {
    if (type == LaunchType.invoice && invoice != null) {
      return "${invoice!.number.toString()} - R\$ ${invoice!.value.toStringAsFixed(2)}";
    }
    if (type == LaunchType.expense && expense != null) {
      return expense!.name;
    }

    return "";
  }

  String get subTitle {
    if (type == LaunchType.invoice && invoice != null) {
      return invoice!.companyValue != null
          ? "${invoice!.companyValue!.name} - ${invoice!.companyValue!.document}"
          : "";
    }
    if (type == LaunchType.expense && expense != null) {
      return "R\$ ${expense!.value.toStringAsFixed(2)}";
    }

    return "";
  }

  History({required this.type, this.expense, this.invoice});
}

enum LaunchType { expense, invoice }
