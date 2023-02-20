import 'package:vibbra_test/models/partner.dart';

class Invoice {
  String? id;
  Partner? company;
  double value;
  int number;
  String description;
  String month;
  String receiveDate;

  Invoice(
      {this.id = "",
      required this.company,
      required this.value,
      required this.number,
      required this.description,
      required this.month,
      required this.receiveDate});

  Invoice.fromJson(Map<String, Object?> json, String id)
      : this(
          id: id,
          company: null,
          value: json['value']! as double,
          number: json['number']! as int,
          description: json['description']! as String,
          month: json['month']! as String,
          receiveDate: json['receive_date']! as String,
        );
  Map<String, Object?> toJson() {
    return {
      'company': company != null ? company!.toJson() : null,
      'value': value,
      'number': number,
      'description': description,
      'month': month,
      'receive_date': receiveDate
    };
  }
}
