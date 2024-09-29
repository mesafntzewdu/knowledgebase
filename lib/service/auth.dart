import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kb/screen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screen/main_page.dart';

class Auth {
  Future<void> loginWithGoogle(context) async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      final googleAuth = await googleUser!.authentication;

      final cred = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(cred);

      if (userCredential.user != null) {
        Map<String, String> userInfo = {
          'name': userCredential.user!.displayName!,
          'email': userCredential.user!.email!,
          'profileUrl': userCredential.user!.photoURL!
        };

        final sharedPf = await SharedPreferences.getInstance();

        sharedPf.setString('userInfo', jsonEncode(userInfo));

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          ),
        );
      }
    } catch (e) {}
  }

  Future<void> signOut(context) async {
    await GoogleSignIn().signOut();
    Navigator.of(context).popUntil(
      (route) => route == Login(),
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Login(),
      ),
    );
  }

  Future<void> deleteUser(context) async {
    await GoogleSignIn().disconnect();
    Navigator.of(context).pop();
  }
}
