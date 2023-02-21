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
  List<Invoice> _invoices = [];
  int _isDeletingInvoicesIndex = -1;
  Partner? _partner;
  Invoice? _invoiceEditing;

  bool get isLoading => _isLoading;
  bool get isLoadingBtn => _isLoadingBtn;
  List<Error> get errors => _errors;
  List<Partner> get partners => _partners;
  List<Invoice> get invoices => _invoices;
  Partner? get partner => _partner;
  int get isDeletingInvoicesIndex => _isDeletingInvoicesIndex;
  Invoice? get invoiceEditing => _invoiceEditing;

  set partner(Partner? value) {
    _partner = value;
    notifyListeners();
  }

  set invoiceEditing(Invoice? value) {
    _invoiceEditing = value;
    notifyListeners();
  }

  void cleanErrors() {
    _errors = [];
    notifyListeners();
  }

  void addError(Error error) {
    _errors.add(error);
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

  Future<void> getInvoices() async {
    var invoiceListFirestore = await _invoicesCollection.get();
    _invoices =
        invoiceListFirestore.docs.map((element) => element.data()).toList();
    for (var element in _invoices) {
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

  Future<bool> submit(Invoice invoice) async {
    _errors = [];

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
    if (_invoiceEditing != null) {
      invoice.company = _invoiceEditing!.company;
    } else {
      invoice.company = _partnersCollection.doc(_partner!.id);
    }
    try {
      if (_invoiceEditing != null) {
        await _invoicesCollection.doc(_invoiceEditing!.id).set(invoice);
      } else {
        await _invoicesCollection.add(invoice);
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
      await _invoicesCollection.doc(_invoices[index].id).delete();
      _invoices.removeAt(index);
    } catch (e) {
      errors.add(Error(code: 'general|failed', message: e.toString()));
    } finally {
      _isDeletingInvoicesIndex = -1;
      notifyListeners();
    }
    return true;
  }
}
