import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vibbra_test/models/expense.dart';
import 'package:vibbra_test/models/history.dart';
import 'package:vibbra_test/models/invoice.dart';
import 'package:vibbra_test/models/partner.dart';

class HistoriesController extends ChangeNotifier {
  final _invoicesCollection = FirebaseFirestore.instance
      .collection('entries')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('invoices')
      .withConverter<Invoice>(
          fromFirestore: ((snapshot, options) =>
              Invoice.fromJson(snapshot.data()!, snapshot.id)),
          toFirestore: (invoice, _) => invoice.toJson());
  final _expensesCollection = FirebaseFirestore.instance
      .collection('entries')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('expenses')
      .withConverter<Expense>(
          fromFirestore: ((snapshot, options) =>
              Expense.fromJson(snapshot.data()!, snapshot.id)),
          toFirestore: (expense, _) => expense.toJson());
  bool _isLoading = true;
  List<History> _histories = [];

  bool get isLoading => _isLoading;
  List<History> get histories => _histories;

  Future<void> getHistories() async {
    var invoiceListFirestore = await _invoicesCollection.get();
    List<Invoice> invoices =
        invoiceListFirestore.docs.map((element) => element.data()).toList();
    _histories = [];
    for (var element in invoices) {
      if (element.company != null) {
        var snapshot = await FirebaseFirestore.instance
            .doc(element.company!.path)
            .withConverter<Partner>(
                fromFirestore: ((snapshot, options) =>
                    Partner.fromJson(snapshot.data()!, snapshot.id)),
                toFirestore: (partner, _) => partner.toJson())
            .get();
        element.companyValue = snapshot.data();
      }
      _histories.add(History(type: LaunchType.invoice, invoice: element));
    }
    var expensesFirestore = await _expensesCollection.get();
    List<Expense> expenses =
        expensesFirestore.docs.map((element) => element.data()).toList();
    for (var element in expenses) {
      _histories.add(History(type: LaunchType.expense, expense: element));
    }
    _isLoading = false;
    notifyListeners();
  }
}
