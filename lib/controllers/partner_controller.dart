import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vibbra_test/models/error.dart';
import 'package:vibbra_test/models/partner.dart';
import 'package:vibbra_test/utils/validates.dart';

class PartnerController extends ChangeNotifier {
  final _partnersCollection = FirebaseFirestore.instance
      .collection('preferences')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('partners')
      .withConverter<Partner>(
          fromFirestore: ((snapshot, options) =>
              Partner.fromJson(snapshot.data()!, snapshot.id)),
          toFirestore: (partner, _) => partner.toJson());
  bool _isLoading = true;
  bool _isLoadingBtn = false;
  List<Error> _errors = [];
  List<Partner> _partners = [];
  int _isDeletingIndex = -1;
  Partner? _partnerEditing;

  bool get isLoading => _isLoading;
  bool get isLoadingBtn => _isLoadingBtn;
  List<Error> get errors => _errors;
  List<Partner> get partners => _partners;
  int get isDeletingIndex => _isDeletingIndex;
  Partner? get partnerEditing => _partnerEditing;

  set partnerEditing(Partner? value) {
    _partnerEditing = value;
    notifyListeners();
  }

  Future<void> getPartners() async {
    var partnersListFirestore = await _partnersCollection.get();
    _partners =
        partnersListFirestore.docs.map((element) => element.data()).toList();
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> submit(Partner partner) async {
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

    _isLoadingBtn = true;
    notifyListeners();
    try {
      if (_partnerEditing != null) {
        await _partnersCollection.doc(_partnerEditing!.id).set(partner);
        int index = _partners
            .indexWhere((element) => element.id == _partnerEditing!.id);
        _partners[index].document = partner.document;
        _partners[index].name = partner.name;
        _partners[index].socialReason = partner.socialReason;
      } else {
        DocumentReference<Partner> ref = await _partnersCollection.add(partner);
        var snapshot = await ref.get();
        _partners.add(snapshot.data()!);
      }
    } catch (e) {
      errors.add(Error(code: 'general|failed', message: e.toString()));
    } finally {
      _isLoadingBtn = false;
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
      await _partnersCollection.doc(_partners[index].id).delete();
      _partners.removeAt(index);
    } catch (e) {
      errors.add(Error(code: 'general|failed', message: e.toString()));
    } finally {
      _isDeletingIndex = -1;
      notifyListeners();
    }
    return true;
  }
}
