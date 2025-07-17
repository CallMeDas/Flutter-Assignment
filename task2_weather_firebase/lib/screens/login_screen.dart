import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isSigningIn = false;

  Future<UserCredential?> signInWithGoogle() async {
    setState(() {
      isSigningIn = true;
    });

    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
  clientId: '1033929961237-5gdplqch2esaq6llnee0bhs77qhvb9ut.apps.googleusercontent.com',
).signIn();


      if (googleUser == null) {
        setState(() {
          isSigningIn = false;
        });
        return null; // The user canceled the sign-in
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google [UserCredential]
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      return userCredential;
    } catch (e) {
      print('Google Sign-In error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign-in failed. Try again.')),
      );
    } finally {
      setState(() {
        isSigningIn = false;
      });
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App - Login'),
      ),
      body: Center(
        child: user == null
            ? isSigningIn
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    icon: const Icon(Icons.login),
                    label: const Text('Sign in with Google'),
                    onPressed: () async {
                      final userCred = await signInWithGoogle();
                      if (userCred != null) {
                        // Navigate to home page or show success message
                        Navigator.pushReplacementNamed(context, '/weather');
                      }
                    },
                  )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Signed in as: ${user.displayName}'),
                  const SizedBox(height: 10),
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.photoURL ?? ''),
                    radius: 30,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text('Sign out'),
                    onPressed: () async {
                      await GoogleSignIn().signOut();
                      await FirebaseAuth.instance.signOut();
                      setState(() {});
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
