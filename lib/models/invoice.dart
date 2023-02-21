import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vibbra_test/models/partner.dart';

class Invoice {
  String? id;
  DocumentReference<Partner>? company;
  Partner? companyValue;
  double value;
  int number;
  String description;
  int month;
  String receiveDate;

  Invoice(
      {this.id = "",
      this.company,
      this.companyValue,
      required this.value,
      required this.number,
      required this.description,
      required this.month,
      required this.receiveDate});

  Invoice.fromJson(Map<String, dynamic> json, String id)
      : this(
          id: id,
          company: json['company'] == null
              ? null
              : FirebaseFirestore.instance
                  .doc(json['company'].path)
                  .withConverter<Partner>(
                      fromFirestore: ((snapshot, options) =>
                          Partner.fromJson(snapshot.data()!, snapshot.id)),
                      toFirestore: (partner, _) => partner.toJson()),
          value: json['value'] is int
              ? json['value'].toDouble()
              : json['value']! as double,
          number: json['number']! as int,
          description: json['description']! as String,
          month: json['month']! as int,
          receiveDate: json['receive_date']! as String,
        );
  Map<String, Object?> toJson() {
    return {
      'company': company,
      'value': value,
      'number': number,
      'description': description,
      'month': month,
      'year': DateTime.parse(receiveDate).year,
      'receive_date': receiveDate
    };
  }
}
