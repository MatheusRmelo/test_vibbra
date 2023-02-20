import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vibbra_test/models/error.dart';
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
  final _invoicesCollection = FirebaseFirestore.instance
      .collection('entries')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('invoices')
      .withConverter<Invoice>(
          fromFirestore: ((snapshot, options) =>
              Invoice.fromJson(snapshot.data()!, snapshot.id)),
          toFirestore: (invoice, _) => invoice.toJson());
  bool _isLoading = true;
  bool _isLoadingBtn = false;
  List<Error> _errors = [];
  List<Partner> _partners = [];
  Partner? _partner = null;

  bool get isLoading => _isLoading;
  bool get isLoadingBtn => _isLoadingBtn;
  List<Error> get errors => _errors;
  List<Partner> get partners => _partners;
  Partner? get partner => _partner;

  set partner(Partner? value) {
    partner = value;
    notifyListeners();
  }

  Future<void> getPartners() async {
    var partnersListFirestore = await _partnersCollection.get();
    _partners =
        partnersListFirestore.docs.map((element) => element.data()).toList();
    _isLoading = false;
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

  Future<bool> submit(Invoice invoice) async {
    _errors = [];
    if (invoice.month.isEmpty) {
      _errors.add(Error(
          code: 'month|required', message: "Mês é uma informação obrigatória"));
    }
    if (invoice.receiveDate.isEmpty) {
      _errors.add(Error(
          code: 'receive_data|required',
          message: "Data de recebimento é uma informação obrigatória"));
    }

    if (_errors.isNotEmpty) {
      notifyListeners();
      return false;
    }

    _isLoadingBtn = true;
    notifyListeners();
    try {
      await _invoicesCollection.add(invoice);
    } catch (e) {
      errors.add(Error(code: 'general|failed', message: e.toString()));
    } finally {
      _isLoadingBtn = false;
      notifyListeners();
    }

    return _errors.isEmpty;
  }
}
