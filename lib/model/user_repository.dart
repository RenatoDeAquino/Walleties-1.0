import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:walleties/core/view_models/home_view_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserRepository with ChangeNotifier {
  FirebaseAuth _auth;
  FirebaseUser _user;
  GoogleSignIn _googleSignIn;
  Status _status = Status.Uninitialized;
  String _error;

  final homeViewModel = HomeViewModel.instance();

  UserRepository.instance()
      : _auth = FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn() {
    _error = '';
    _auth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  String get error => _error;
  Status get status => _status;
  FirebaseUser get user => _user;

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _error = '';
      print("Loggin normally sucessfull");
      homeViewModel.updateUserInfo(["", user.email, ""], 3);
      return true;
    } catch (e) {
      _error = e.message;
      _status = Status.Unauthenticated;
      notifyListeners();
      print("Loggin normally unsucessfull");
      return false;
    }
  }

  Future<bool> signup(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _error = '';
      print("Signing up sucessfull: $email and $password");
      return true;
    } catch (e) {
      _error = e.message;
      _status = Status.Unauthenticated;
      notifyListeners();
      print("Signing up unsucessfull");
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      _error = '';
      homeViewModel.updateUserInfo([
        googleUser.displayName,
        googleUser.email,
        googleUser.photoUrl
            .replaceAll("s96-c/photo.jpg", "photo.jpg")
            .replaceAll("=s96-c", "")
      ], 3);

      print("Loggin with Google sucessfull");

      return true;
    } catch (e) {
      try {
        _error = e.message;
      } catch (e) {
        _error = '';
      }
      _status = Status.Unauthenticated;
      notifyListeners();
      print("Loggin with Google unsucessfull");
      return false;
    }
  }

  Future signOut() async {
    _auth.signOut();
    _googleSignIn.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    print("Signing Out!");
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }
}
