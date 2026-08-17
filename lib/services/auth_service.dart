import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/foundation.dart';
import 'package:post_app/services/db_service.dart';

sealed class AuthService {
  static final auth = FirebaseAuth.instance;

  static Future<bool> signUp(
      String email, String password, String username) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = credential.user;
      if (user == null) return false;

      // Profile/DB writes must not block leaving the sign-up loading overlay.
      unawaited(_completeSignUpProfile(user, email, password, username));
      return true;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  static Future<void> _completeSignUpProfile(
      User user, String email, String password, String username) async {
    try {
      await user.updateDisplayName(username).timeout(
            const Duration(seconds: 10),
          );
    } catch (e) {
      debugPrint("ERROR updateDisplayName: $e");
    }

    try {
      await DBService.storeUser(email, password, username, user.uid).timeout(
            const Duration(seconds: 10),
          );
    } catch (e) {
      debugPrint("ERROR storeUser: $e");
    }
  }

  static Future<bool> signIn(String email, String password) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user != null;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  static Future<bool> signOut() async {
    try {
      await auth.signOut();
      return true;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  static Future<bool> deleteAccount() async {
    /// Har qanday appda delete account qilinganda avvalo qayta sign in qilishi talab qilinadi.
    try {
      if (auth.currentUser != null) {
        await auth.currentUser!.delete();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  static User get user => auth.currentUser!;
}
