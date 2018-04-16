part of services.data_service;

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

  Future<User> _ensureLoggedIn() async {
    try {
      final GoogleSignInAccount signInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await signInAccount.authentication;
      final FirebaseUser firebaseUser =
          await FirebaseAuth.instance.signInWithGoogle(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      if (signInAccount != null) {
        this.user = new User.fromGoogleSignIn(firebaseUser);
      }
    } catch (error) {
      user = new User();
    }
    _analytics.logLogin();
    return user;
  }

  bool get loggedIn => _googleSignIn.currentUser != null;

  Future<Null> _signOut() async {
    await _googleSignIn.signOut();
    user = new User();
  }
}
