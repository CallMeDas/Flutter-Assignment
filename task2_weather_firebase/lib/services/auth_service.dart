import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'dart:io' show Platform;

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    return userCredential.user;
  }

  static Future<void> signOut() async {
    // Sign out from Firebase
    await _auth.signOut();

    // Try Google Sign-Out ONLY on platforms that support it
    try {
      final googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.disconnect(); // Optional: Clears the account
        await googleSignIn.signOut();    // Required: Logs out from Google
      }
    } catch (e) {
      print("⚠️ Google Sign-Out failed: $e");
    }
  }

  static User? get currentUser => _auth.currentUser;
}
