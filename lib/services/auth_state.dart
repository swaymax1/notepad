import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Auth extends ChangeNotifier {
  Auth() {
    init();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _loggedIn = false;

  bool get loggedIn => _loggedIn;

  User? get user => _auth.currentUser;

  Future<void> init() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }

  Future<String?> signUpUser(
      {required String email,
      required String password,
      required fullName}) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: email.trim(), password: password.trim());
      userCredential.user?.updateDisplayName(fullName);
      return 'success';
    } on FirebaseAuthException catch (e) {
      return e.message;
    } on Exception catch (e) {
      return e.toString();
    }
  }

  Future<String?> signInUser(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return 'success';
    } on FirebaseAuthException catch (e) {
      return 'firebaseAuthException: ${e.message}';
    } on Exception catch (e) {
      return e.toString();
    }
  }

  Future<void> signOutUser() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }
}
