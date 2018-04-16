import 'package:arabicchurch/services/data_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  static const newUserEmail = 'newuser';

  final String email;
  final String displayName;
  final String photoUrl;

  User({this.email: newUserEmail, this.displayName: 'New user', this.photoUrl});

  User.fromGoogleSignIn(FirebaseUser firebaseUser)
      : email = firebaseUser.email,
        displayName = firebaseUser.displayName,
        photoUrl = firebaseUser.photoUrl;

  bool get isNewUser => email == newUserEmail;

  String get tableName => DataService.usersTable;

  String get key => username;

  String get username => email.replaceAll('.', '_');
}
