import 'dart:async';

import 'package:arabicchurch/model/user.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInService {
  static SignInService _cached;

  final _googleSignIn = new GoogleSignIn();
  final _analytics = new FirebaseAnalytics();

  User user = new User();

  factory SignInService() {
    _cached ??= new SignInService._internal();
    return _cached;
  }

  SignInService._internal();

  ensureLoggedIn() async {
    try {
      GoogleSignInAccount signInAccount = await _googleSignIn.signIn();

      if (signInAccount != null) {
        user = new User.fromGoogleSignIn(_googleSignIn.currentUser);
      }
    } catch (error) {
      user = new User();
    }
    _analytics.logLogin();
  }

  bool get loggedIn => _googleSignIn.currentUser != null;

  Future<Null> signOut() async {
    _googleSignIn.signOut();
  }
}
