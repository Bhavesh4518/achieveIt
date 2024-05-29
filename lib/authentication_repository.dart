import 'package:achieve_it/home_screen.dart';
import 'package:achieve_it/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;

  // Get authenticated User data
  User? get authUser => _auth.currentUser;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
    super.onReady();
  }

  Future<void> screenRedirect() async {
    final user = _auth.currentUser;
    if (user != null && user.providerData.any((userInfo) => userInfo.providerId == 'google.com')) {
      Get.offAll(() => const HomeScreen());
    }
    else{
      Get.offAll(() => const LoginScreen());
    }
  }
}
