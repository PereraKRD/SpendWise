import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spendwise/LogIn.dart';
import 'package:spendwise/screens/Dashboard.dart';
import 'package:spendwise/services/db.dart';

class AuthService {
  var db = Db();
  Future<void> createUser(data, context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: data['email'], password: data['password']);
      await db.addUser(data, context);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: ((context) => const LogInView()),
        ),
      );
    } catch (e) {
      String errorMessage = "An error occurred";
      if (e is FirebaseAuthException) {
        errorMessage = _getFirebaseAuthErrorMessage(e);
      }

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text(errorMessage),
          );
        },
      );
    }
  }

  String _getFirebaseAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case '':
        return "Invalid email";
      default:
        return "Invalid credentials";
    }
  }

  Future<void> loginUser(data, context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: data['email'], password: data['password']);
      print("Login Successful");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: ((context) => const Dashboard()),
        ),
      );
    } catch (e) {
      String errorMessage = "An error occurred";
      if (e is FirebaseAuthException) {
        errorMessage = _getFirebaseAuthErrorMessage(e);
      }

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text(errorMessage),
          );
        },
      );
    }
  }

  signOutUser() async {
    await FirebaseAuth.instance.signOut();
  }
}
