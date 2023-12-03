import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spendwise/screens/dashboard.dart';
import 'package:spendwise/services/db.dart';

class AuthService {
  var db = Db();
  createUser(data, context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: data['email'], password: data['password']);
      await db.addUser(data, context);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: ((context) => const Dashboard()),
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text(e.toString()),
          );
        },
      );
    }
  }

  loginUser(data, context) async {
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
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text(e.toString()),
          );
        },
      );
    }
  }

  signOutUser() async {
    await FirebaseAuth.instance.signOut();
  }
}
