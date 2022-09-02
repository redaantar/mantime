import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:mantime/models/auth_model.dart';
import 'package:mantime/pages/login_page.dart';

import '../pages/home_page.dart';

class AuthHelper {
  //stream the route based on sign in state
  authState() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return const HomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }

  Future<void> signInWithEmailAndpass(AuthModel user) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: user.email!, password: user.password!);
      Get.offAllNamed(HomePage.homePage);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar('User not found', 'No user found for that email.',
            colorText: Colors.red,
            icon: const Icon(Icons.warning, color: Colors.red));
      } else if (e.code == 'wrong-password') {
        Get.snackbar('Wrong password', 'Wrong password provided for that user.',
            colorText: Colors.red,
            icon: const Icon(Icons.warning, color: Colors.red));
      }
    }
  }

  Future<UserCredential?> signInWithGoogleOption() async {
    try {
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(scopes: <String>["email"]).signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'auth/account-exists-with-different-credential') {
        Get.snackbar('account already exists',
            'The account already exists with a different credential.',
            colorText: Colors.red,
            icon: const Icon(Icons.warning, color: Colors.red));
      } else if (e.code == 'auth/invalid-credential') {
        Get.snackbar('Error occurred',
            'Error occurred while accessing credentials. Try again.',
            colorText: Colors.red,
            icon: const Icon(Icons.warning, color: Colors.red));
      } else if (e.code == 'auth/user-disabled') {
        Get.snackbar('User disabled', 'this user is disabled.',
            colorText: Colors.red,
            icon: const Icon(Icons.warning, color: Colors.red));
      }
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar('Error occurred using Google Sign-In',
          'Error occurred using Google Sign-In. Try again.',
          colorText: Colors.red,
          icon: const Icon(Icons.warning, color: Colors.red));
    }
    return null;
  }

  Future<void> signUpWithEmailAndPass(AuthModel user) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: user.email!, password: user.password!);
      Get.offAllNamed(HomePage.homePage);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Get.snackbar('Email already in use', 'Try again, with an other email.',
            colorText: Colors.red,
            icon: const Icon(Icons.warning, color: Colors.red));
      }
    } catch (e) {
      Get.snackbar('Error occurred using Google Sign-In',
          'Error occurred using Google Sign-In. Try again.',
          colorText: Colors.red,
          icon: const Icon(Icons.warning, color: Colors.red));
    }
  }

  Future<void> authSignOut() async {
    GoogleSignIn();
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      Get.snackbar('Error signing out. Try again.', '',
          colorText: Colors.red,
          icon: const Icon(Icons.warning, color: Colors.red));
    }
  }
}
