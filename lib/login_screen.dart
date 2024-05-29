
import 'package:achieve_it/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    // Store user information in Firestore
    await storeUserData(userCredential.user);

    Get.offAll(() => const HomeScreen());

    return userCredential;
  }

  Future<void> storeUserData(User? user) async {
    if (user != null) {
      final usersCollection = FirebaseFirestore.instance.collection('Users');
      await usersCollection.doc(user.uid).set({
        'name': user.displayName!.replaceAll(' ', '').trim(),
        'email': user.email,
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.white70],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Login form
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.12),
                  const Text(
                    'Achieve It',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                  const SizedBox(height: 60),
                  Image.asset('assets/tasker.jpg'),
                  const SizedBox(height: 20),
                  const Text(
                    "Login to Explore More",
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 100),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(

                        elevation: 2,
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Border radius
                        ),
                      ),
                      onPressed: () async {
                        try {
                          UserCredential userCredential = await signInWithGoogle();
                          // Navigate to the NavigationMenuScreen on successful login
                          Get.offAll(() => const HomeScreen());
                        } catch (e) {
                          // Show error snackbar if login fails
                          print(e);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error during Google sign-in: $e'),
                            ),
                          );
                        }
                      },
                      child: const Text('Login/Sign up with Google',style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
