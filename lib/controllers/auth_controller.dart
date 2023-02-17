import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vibbra_test/models/error.dart';

class AuthController extends ChangeNotifier {
  bool _isLoadingEmail = false;
  bool _isLoadingGmail = false;
  bool _isLoadingFacebook = false;
  List<Error> _errors = [];

  bool get isLoadingEmail => _isLoadingEmail;
  bool get isLoadingGmail => _isLoadingGmail;
  bool get isLoadingFacebook => _isLoadingFacebook;

  List<Error> get errors => _errors;
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    _errors = [];
    _isLoadingEmail = true;
    notifyListeners();

    if (email.isEmpty) {
      _errors.add(Error(
          code: 'email|required',
          message: "E-mail é uma informação obrigatória"));
    }
    if (password.isEmpty) {
      _errors.add(Error(
          code: 'password|required',
          message: "Senha é uma informação obrigatória"));
    }
    if (_errors.isNotEmpty) {
      _isLoadingEmail = false;
      notifyListeners();
      return;
    }
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        errors.add(Error(
            code: 'password|weak-password',
            message: "Senha informada é muita fraca, mínimo 6 caracteres"));
      }
    } catch (e) {
      errors.add(Error(code: 'general|failed', message: e.toString()));
    } finally {
      _isLoadingEmail = false;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    _errors = [];
    _isLoadingGmail = true;
    notifyListeners();
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-disabled') {
        errors.add(Error(
            code: 'general|user-disabled', message: "Usuário desabilitado"));
      }
    } catch (e) {
      errors.add(Error(code: 'general|failed', message: e.toString()));
    } finally {
      _isLoadingGmail = false;
      notifyListeners();
    }
  }

  Future<void> signInWithFacebook() async {
    _errors = [];
    _isLoadingFacebook = true;
    notifyListeners();
    final LoginResult loginResult = await FacebookAuth.instance.login();
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    try {
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-disabled') {
        errors.add(Error(
            code: 'general|user-disabled', message: "Usuário desabilitado"));
      }
    } catch (e) {
      errors.add(Error(code: 'general|failed', message: e.toString()));
    } finally {
      _isLoadingFacebook = false;
      notifyListeners();
    }
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    _errors = [];
    _isLoadingEmail = true;
    notifyListeners();

    if (email.isEmpty) {
      _errors.add(Error(
          code: 'email|required',
          message: "E-mail é uma informação obrigatória"));
    }
    if (password.isEmpty) {
      _errors.add(Error(
          code: 'password|required',
          message: "Senha é uma informação obrigatória"));
    }
    if (_errors.isNotEmpty) {
      _isLoadingEmail = false;
      notifyListeners();
      return;
    }
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        errors.add(Error(
            code: 'password|weak-password',
            message: "Senha informada é muita fraca, mínimo 6 caracteres"));
      } else if (e.code == 'email-already-in-use') {
        errors.add(Error(
            code: 'email|email-in-use',
            message: "Esse e-mail já está sendo utilizado"));
      }
    } catch (e) {
      errors.add(Error(code: 'general|failed', message: e.toString()));
    } finally {
      _isLoadingEmail = false;
      notifyListeners();
    }
  }
}
