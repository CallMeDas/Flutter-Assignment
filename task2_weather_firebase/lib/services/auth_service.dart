import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static Future<User?> signInWithGoogle() async {
    GoogleSignIn googleSignIn;
    if (kIsWeb) {
      googleSignIn = GoogleSignIn(
        clientId: "1033929961237-5gdplqch2esaq6llnee0bhs77qhvb9ut.apps.googleusercontent.com",
      );
    } else {
      googleSignIn = GoogleSignIn();
    }
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) return null;
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,);
    final userCredential = await _auth.signInWithCredential(credential);
    return userCredential.user;
  }
  static Future<void> signOut() async {
    try {
      final googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.disconnect(); // Clears the cached account
        await googleSignIn.signOut();    // Signs out from Google
      }
    } catch (e) {
      print("⚠️ Google Sign-Out failed: $e");
    }
    await _auth.signOut();
  }
  static User? get currentUser => _auth.currentUser;}





