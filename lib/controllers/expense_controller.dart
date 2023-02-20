import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vibbra_test/models/error.dart';
import 'package:vibbra_test/models/expense.dart';
import 'package:vibbra_test/models/expense_category.dart';
import 'package:vibbra_test/models/invoice.dart';
import 'package:vibbra_test/models/partner.dart';
import 'package:vibbra_test/utils/validates.dart';

class InvoiceController extends ChangeNotifier {
  final _partnersCollection = FirebaseFirestore.instance
      .collection('preferences')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('partners')
      .withConverter<Partner>(
          fromFirestore: ((snapshot, options) =>
              Partner.fromJson(snapshot.data()!, snapshot.id)),
          toFirestore: (partner, _) => partner.toJson());
  final _expensesCategoriesollection = FirebaseFirestore.instance
      .collection('preferences')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('expenses_categories')
      .withConverter<ExpenseCategory>(
          fromFirestore: ((snapshot, options) =>
              ExpenseCategory.fromJson(snapshot.data()!, snapshot.id)),
          toFirestore: (category, _) => category.toJson());
  final _expensesCollection = FirebaseFirestore.instance
      .collection('entries')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('expenses')
      .withConverter<Expense>(
          fromFirestore: ((snapshot, options) =>
              Expense.fromJson(snapshot.data()!, snapshot.id)),
          toFirestore: (expense, _) => expense.toJson());
  bool _isLoading = true;
  bool _isLoadingBtn = false;
  List<Error> _errors = [];
  List<Partner> _partners = [];
  List<Expense> _expenses = [];
  int _isDeletingInvoicesIndex = -1;
  ExpenseCategory? _category;
  Expense? _expenseEditing;

  bool get isLoading => _isLoading;
  bool get isLoadingBtn => _isLoadingBtn;
  List<Error> get errors => _errors;
  List<Partner> get partners => _partners;
  List<Expense> get expenses => _expenses;
  ExpenseCategory? get category => _category;
  int get isDeletingInvoicesIndex => _isDeletingInvoicesIndex;
  Expense? get expenseEditing => _expenseEditing;

  set category(ExpenseCategory? value) {
    _category = value;
    notifyListeners();
  }

  set expenseEditing(Expense? value) {
    _expenseEditing = value;
    notifyListeners();
  }

  void handleSearchPartner(String search) {
    for (var element in _partners) {
      element.isHidden =
          !(element.name.toLowerCase().contains(search.toLowerCase()) ||
              element.document.toLowerCase().contains(search.toLowerCase()));
    }
    notifyListeners();
  }

  Future<void> getExpenses() async {
    var expensesFirestore = await _expensesCollection.get();
    _expenses =
        expensesFirestore.docs.map((element) => element.data()).toList();
    for (var element in _expenses) {
      if (element.companyRef != null) {
        var snapshot = await FirebaseFirestore.instance
            .doc(element.companyRef!.path)
            .withConverter<Partner>(
                fromFirestore: ((snapshot, options) =>
                    Partner.fromJson(snapshot.data()!, snapshot.id)),
                toFirestore: (partner, _) => partner.toJson())
            .get();
        element.company = snapshot.data();
      }
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
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getPartners() async {
    var partnersListFirestore = await _partnersCollection.get();
    _partners =
        partnersListFirestore.docs.map((element) => element.data()).toList();
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> submit(Expense expense, Partner? company) async {
    _errors = [];
    if (expense.datePayment.isEmpty) {
      _errors.add(Error(
          code: 'date_payment|required',
          message: "Data de pagamento é uma informação obrigatória"));
    }
    if (expense.dateCompetence.isEmpty) {
      _errors.add(Error(
          code: 'date_competence|required',
          message: "Data de competência é uma informação obrigatória"));
    }

    if (_errors.isNotEmpty) {
      notifyListeners();
      return false;
    }

    _isLoadingBtn = true;
    notifyListeners();
    if (_expenseEditing != null) {
      expense.companyRef = _expenseEditing!.companyRef;
    } else {
      expense.companyRef = _partnersCollection.doc(company!.id);
    }
    if (_expenseEditing != null) {
      expense.categoryRef = _expenseEditing!.categoryRef;
    } else {
      expense.categoryRef = _expensesCategoriesollection.doc(_category!.id);
    }
    try {
      if (_expenseEditing != null) {
        await _expensesCollection.doc(_expenseEditing!.id).set(expense);
      } else {
        await _expensesCollection.add(expense);
      }
    } catch (e) {
      errors.add(Error(code: 'general|failed', message: e.toString()));
    } finally {
      _isLoadingBtn = false;
      notifyListeners();
    }

    return _errors.isEmpty;
  }

  Future<bool> destroyInvoice(int index) async {
    _isDeletingInvoicesIndex = index;
    _errors = [];
    if (_isDeletingInvoicesIndex < 0) {
      return false;
    }
    notifyListeners();
    try {
      await _expensesCollection.doc(_expenses[index].id).delete();
      _expenses.removeAt(index);
    } catch (e) {
      errors.add(Error(code: 'general|failed', message: e.toString()));
    } finally {
      _isDeletingInvoicesIndex = -1;
      notifyListeners();
    }
    return true;
  }
}
