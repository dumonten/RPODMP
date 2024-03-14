import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthHandler {
  static Future<void> _showMyDialog(
      BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<User?> login(
      BuildContext context, String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showMyDialog(
            context, 'The email address is not registered. Please sign up.');
      } else if (e.code == 'wrong-password') {
        _showMyDialog(context,
            'The password you entered is incorrect. Please try again.');
      } else if (e.code == 'invalid-email') {
        _showMyDialog(context,
            'The email address you entered is not valid. Please check and try again.');
      }
    }
    return null;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<User?> register(
      BuildContext context, String email, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _showMyDialog(context,
            'Your password is too weak. Please choose a stronger one.');
      } else if (e.code == 'email-already-in-use') {
        _showMyDialog(context,
            'An account with this email already exists. Please log in or use a different email.');
      } else if (e.code == 'invalid-email') {
        _showMyDialog(context,
            'The email address you entered is not valid. Please check and try again.');
      }
    } catch (e) {
      _showMyDialog(
          context, 'An unexpected error occurred. Please try again later.');
    }
    return null;
  }
}
