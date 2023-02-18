import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vibbra_test/models/error.dart';
import 'package:vibbra_test/models/partner.dart';
import 'package:vibbra_test/utils/validates.dart';

class PartnerController extends ChangeNotifier {
  final _partnersCollection = FirebaseFirestore.instance
      .collection('settings')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('partners')
      .withConverter<Partner>(
          fromFirestore: ((snapshot, options) =>
              Partner.fromJson(snapshot.data()!)),
          toFirestore: (partner, _) => partner.toJson());
  bool _isLoading = false;
  List<Error> _errors = [];
  List<Partner> _partners = [];
  bool get isLoading => _isLoading;
  List<Error> get errors => _errors;
  List<Partner> get partners => _partners;

  Future<void> getPartners() async {
    _isLoading = true;
    notifyListeners();
    var partnersListFirestore = await _partnersCollection.get();
    _partners =
        partnersListFirestore.docs.map((element) => element.data()).toList();
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> store(Partner partner) async {
    _errors = [];
    if (partner.name.isEmpty) {
      _errors.add(Error(
          code: 'name|required', message: "Nome é uma informação obrigatória"));
    }
    if (partner.document.isEmpty) {
      _errors.add(Error(
          code: 'document|required',
          message: "CNPJ é uma informação obrigatória"));
    }
    if (partner.socialReason.isEmpty) {
      _errors.add(Error(
          code: 'social_reason|required',
          message: "Razão social é uma informação obrigatória"));
    }
    if (!Validates.validCNPJ(partner.document)) {
      _errors.add(Error(
          code: 'document|invalid', message: "CNPJ informado não é válido"));
    }
    if (_errors.isNotEmpty) {
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();
    try {
      DocumentReference<Partner> ref = await _partnersCollection.add(partner);
      var snapshot = await ref.get();
      _partners.add(snapshot.data()!);
    } catch (e) {
      errors.add(Error(code: 'general|failed', message: e.toString()));
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return _errors.isEmpty;
  }
}
