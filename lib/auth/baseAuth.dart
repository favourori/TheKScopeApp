import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password);
  Future<FirebaseUser> getCurrentUser();
  Future<void> signOut(context);
  Future<void> resetPassword(email, context);
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut(context) async {
     showDialog(
              context: context,
              builder: (_) => new AlertDialog(
                    title: new Text("Password Reset"),
                    content: new Text("Password Reset Email Sent"),
                  ));
    return _firebaseAuth.signOut();
  }

  Future<void> resetPassword(email, context) async {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Password Reset"),
              content: new Text("Password Reset Email Sent"),
            ));

    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
