import 'package:google_sign_in/google_sign_in.dart';

class User {
  final String email;
  final String displayName;

  User({this.email: 'newuser', this.displayName: 'New user'});

  User.fromGoogleSignIn(GoogleSignInAccount googleUser)
      : email = googleUser.email,
        displayName = googleUser.displayName;

  String get username => email.replaceAll('@', '').replaceAll('.', '');
}