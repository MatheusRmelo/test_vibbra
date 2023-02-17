import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vibbra_test/models/company.dart';
import 'package:vibbra_test/models/error.dart';
import 'package:vibbra_test/utils/validates.dart';

class PreferencesController extends ChangeNotifier {
  bool _isLoading = false;
  List<Error> _errors = [];

  bool get isLoading => _isLoading;
  List<Error> get errors => _errors;

  Future<bool> isFirstUse() async {
    var companyRef = _getReference();
    var response = await companyRef.get();

    return response.data() == null;
  }

  Future<bool> getPartnersCompanies() async {
    var companyRef = _getReference();
    var response = await companyRef.get();

    return response.data() == null;
    return false;
  }

  Future<bool> store(Company company) async {
    _errors = [];
    if (company.name.isEmpty) {
      _errors.add(Error(
          code: 'name|required', message: "Nome é uma informação obrigatória"));
    }
    if (company.document.isEmpty) {
      _errors.add(Error(
          code: 'document|required',
          message: "CNPJ é uma informação obrigatória"));
    }
    if (company.phone.isEmpty) {
      _errors.add(Error(
          code: 'phone|required',
          message: "Telefone é uma informação obrigatória"));
    }
    if (!Validates.validCNPJ(company.document)) {
      _errors.add(Error(
          code: 'document|invalid', message: "CNPJ informado não é válido"));
    }
    if (_errors.isNotEmpty) {
      notifyListeners();
      return false;
    }

    var companyRef = _getReference();
    _isLoading = true;
    notifyListeners();

    try {
      await companyRef.set(company);
    } catch (e) {
      errors.add(Error(code: 'general|failed', message: e.toString()));
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return _errors.isEmpty;
  }

  DocumentReference<Company> _getReference() {
    return FirebaseFirestore.instance
        .collection('preferences')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .withConverter<Company>(
            fromFirestore: (snapshot, _) => Company.fromJson(snapshot.data()!),
            toFirestore: (company, _) => company.toJson());
  }
}
