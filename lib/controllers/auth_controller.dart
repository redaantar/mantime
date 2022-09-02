import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mantime/models/auth_model.dart';
import 'package:mantime/services/authentication_services.dart';

class AuthController {
  static final AuthHelper _auth = AuthHelper();

  static loginState({bool? isRegisterPage}) => _auth.authState();

  static Future<UserCredential?> signInWithGoogle() =>
      _auth.signInWithGoogleOption();

  static Future<void> signOut() => _auth.authSignOut();

  static Future<Void?> signUpWithEmailAndPassword(AuthModel user) async {
    await _auth.signUpWithEmailAndPass(user);
    return null;
  }

  static Future<Void?> signInWithEmailAndPassword(AuthModel user) async {
    await _auth.signInWithEmailAndpass(user);
    return null;
  }
}
