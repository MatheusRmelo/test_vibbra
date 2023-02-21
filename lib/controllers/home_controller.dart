import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vibbra_test/models/expense.dart';
import 'package:vibbra_test/models/expense_category.dart';
import 'package:vibbra_test/models/invoice.dart';
import 'package:vibbra_test/models/settings.dart';

class HomeController extends ChangeNotifier {
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
  final _settingsCollection = FirebaseFirestore.instance
      .collection('preferences')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('settings')
      .withConverter<SettingsVibbra>(
          fromFirestore: ((snapshot, options) =>
              SettingsVibbra.fromJson(snapshot.data()!, snapshot.id)),
          toFirestore: (settings, _) => settings.toJson());
  List<Invoice> _invoices = [];
  List<Expense> _expenses = [];
  SettingsVibbra? _settings;
  List<Expense> get expenses => _expenses;
  List<Invoice> get invoices => _invoices;
  SettingsVibbra? get settings => _settings;

  Future<void> getInvoices({int? year}) async {
    var snapshot = await _invoicesCollection
        .where('year', isEqualTo: year ?? DateTime.now().year)
        .get();
    _invoices = snapshot.docs.map((e) => e.data()).toList();
    _invoices.sort((a, b) => a.month - b.month);
    notifyListeners();
  }

  Future<void> getExpenses({int? year}) async {
    var snapshot = await _expensesCollection
        .where('year', isEqualTo: year ?? DateTime.now().year)
        .get();

    _expenses = snapshot.docs.map((e) => e.data()).toList();
    for (var element in _expenses) {
      if (element.categoryRef != null) {
        var snapshot = await FirebaseFirestore.instance
            .doc(element.categoryRef!.path)
            .withConverter<ExpenseCategory>(
                fromFirestore: ((snapshot, options) =>
                    ExpenseCategory.fromJson(snapshot.data()!, snapshot.id)),
                toFirestore: (category, _) => category.toJson())
            .get();
        element.category = snapshot.data();
      }
    }
    _expenses.sort((a, b) => a.month - b.month);
    notifyListeners();
  }

  Future<void> getSettings() async {
    var snapshot = await _settingsCollection.doc('settings').get();
    _settings = snapshot.data();
    notifyListeners();
  }
}
