import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vibbra_test/models/expense_category.dart';
import 'package:vibbra_test/models/error.dart';

class ExpenseCategoryController extends ChangeNotifier {
  final _expensesCategoriesCollection = FirebaseFirestore.instance
      .collection('preferences')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('expenses_categories')
      .withConverter<ExpenseCategory>(
          fromFirestore: ((snapshot, options) =>
              ExpenseCategory.fromJson(snapshot.data()!, snapshot.id)),
          toFirestore: (expenseCategory, _) => expenseCategory.toJson());
  bool _isLoading = false;
  List<Error> _errors = [];
  List<ExpenseCategory> _expensesCategories = [];
  int _isDeletingIndex = -1;
  ExpenseCategory? _expenseCategoryEditing;

  bool get isLoading => _isLoading;
  List<Error> get errors => _errors;
  List<ExpenseCategory> get expensesCategories => _expensesCategories;
  int get isDeletingIndex => _isDeletingIndex;
  ExpenseCategory? get expenseCategoryEditing => _expenseCategoryEditing;

  set expenseCategoryEditing(ExpenseCategory? value) {
    _expenseCategoryEditing = value;
    notifyListeners();
  }

  Future<void> getExpensesCategories() async {
    _isLoading = true;
    notifyListeners();
    var partnersListFirestore = await _expensesCategoriesCollection.get();
    _expensesCategories =
        partnersListFirestore.docs.map((element) => element.data()).toList();
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> submit(ExpenseCategory expenseCategory) async {
    _errors = [];
    if (expenseCategory.name.isEmpty) {
      _errors.add(Error(
          code: 'name|required', message: "Nome é uma informação obrigatória"));
    }
    if (expenseCategory.description.isEmpty) {
      _errors.add(Error(
          code: 'description|required',
          message: "Descrição é uma informação obrigatória"));
    }

    if (_errors.isNotEmpty) {
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();
    try {
      if (_expenseCategoryEditing != null) {
        await _expensesCategoriesCollection
            .doc(_expenseCategoryEditing!.id)
            .set(expenseCategory);
        int index = _expensesCategories
            .indexWhere((element) => element.id == _expenseCategoryEditing!.id);
        _expensesCategories[index].description = expenseCategory.description;
        _expensesCategories[index].name = expenseCategory.name;
        _expensesCategories[index].isDisabled = expenseCategory.isDisabled;
      } else {
        DocumentReference<ExpenseCategory> ref =
            await _expensesCategoriesCollection.add(expenseCategory);
        var snapshot = await ref.get();
        _expensesCategories.add(snapshot.data()!);
      }
    } catch (e) {
      errors.add(Error(code: 'general|failed', message: e.toString()));
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return _errors.isEmpty;
  }

  Future<bool> destroyPartner(int index) async {
    _isDeletingIndex = index;
    _errors = [];
    if (_isDeletingIndex < 0) {
      return false;
    }
    notifyListeners();
    try {
      await _expensesCategoriesCollection
          .doc(_expensesCategories[index].id)
          .delete();
      _expensesCategories.removeAt(index);
    } catch (e) {
      errors.add(Error(code: 'general|failed', message: e.toString()));
    } finally {
      _isDeletingIndex = -1;
      notifyListeners();
    }
    return true;
  }
}
