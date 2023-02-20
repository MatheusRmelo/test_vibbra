import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vibbra_test/models/expense_category.dart';
import 'package:vibbra_test/models/partner.dart';

class Expense {
  String? id;
  DocumentReference<ExpenseCategory>? categoryRef;
  ExpenseCategory? category;
  String name;
  String datePayment;
  String dateCompetence;
  double value;
  DocumentReference<Partner>? companyRef;
  Partner? company;

  Expense(
      {this.id = "",
      this.categoryRef,
      this.category,
      this.companyRef,
      this.company,
      required this.value,
      required this.name,
      required this.datePayment,
      required this.dateCompetence});

  Expense.fromJson(Map<String, dynamic> json, String id)
      : this(
          id: id,
          categoryRef: json['category'] == null
              ? null
              : FirebaseFirestore.instance
                  .doc(json['category'].path)
                  .withConverter<ExpenseCategory>(
                      fromFirestore: ((snapshot, options) =>
                          ExpenseCategory.fromJson(
                              snapshot.data()!, snapshot.id)),
                      toFirestore: (category, _) => category.toJson()),
          companyRef: json['company'] == null
              ? null
              : FirebaseFirestore.instance
                  .doc(json['company'].path)
                  .withConverter<Partner>(
                      fromFirestore: ((snapshot, options) =>
                          Partner.fromJson(snapshot.data()!, snapshot.id)),
                      toFirestore: (partner, _) => partner.toJson()),
          value: json['value']! as double,
          name: json['name']! as String,
          datePayment: json['date_payment']! as String,
          dateCompetence: json['date_competence']! as String,
        );
  Map<String, Object?> toJson() {
    return {
      'category': categoryRef,
      'value': value,
      'name': name,
      'company': companyRef,
      'date_payment': datePayment,
      'date_competence': dateCompetence
    };
  }
}
