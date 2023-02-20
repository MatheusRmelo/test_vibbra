import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vibbra_test/models/error.dart';
import 'package:vibbra_test/models/partner.dart';
import 'package:vibbra_test/models/settings.dart';

import 'package:vibbra_test/utils/validates.dart';

class SettingsController extends ChangeNotifier {
  final _collection = FirebaseFirestore.instance
      .collection('preferences')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('settings')
      .withConverter<SettingsVibbra>(
          fromFirestore: ((snapshot, options) =>
              SettingsVibbra.fromJson(snapshot.data()!, snapshot.id)),
          toFirestore: (settings, _) => settings.toJson());
  bool _isLoading = true;
  bool _isLoadingBtn = false;
  List<Error> _errors = [];
  SettingsVibbra? _settings;

  bool get isLoading => _isLoading;
  bool get isLoadingBtn => _isLoadingBtn;

  List<Error> get errors => _errors;
  SettingsVibbra? get settings => _settings;

  void addError(Error error) {
    _errors.add(error);
    notifyListeners();
  }

  Future<void> get() async {
    _isLoading = true;
    var snapshot = await _collection.doc('settings').get();
    _settings = snapshot.data();
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> submit(SettingsVibbra settings) async {
    _isLoadingBtn = true;
    _errors = [];
    notifyListeners();
    try {
      await _collection.doc('settings').set(settings);
    } catch (e) {
      errors.add(Error(code: 'general|failed', message: e.toString()));
    } finally {
      _isLoadingBtn = false;
      notifyListeners();
    }

    return _errors.isEmpty;
  }
}
