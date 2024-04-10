import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Auth with ChangeNotifier {
  String? userEmail;
  String? userName;
  String? userId;
  String? userImageUrl;
  Auth({
    this.userEmail,
    this.userName,
    this.userId,
    this.userImageUrl,
  });

  bool isAuth() {
    if (userId != null) {
      return true;
    }
    return false;
  }

  void logout(BuildContext context) {
    FirebaseAuth.instance.signOut();
    userEmail = null;
    userName = null;
    userId = null;
    userImageUrl = null;
    Navigator.of(context).popUntil(ModalRoute.withName('/'));
    Navigator.of(context).pushNamed('/');
    // notifyListeners();
    // print("logged out");
  }

  Future<void> authenticate({
    required BuildContext context,
    required String email,
    required String password,
    bool isSignup = false,
    Map<String, dynamic>? userData,
  }) async {
    // print("Authentication Started");
    final auth = FirebaseAuth.instance;
    try {
      if (isSignup) {
        final authResponse = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        userId = authResponse.user!.uid;
        // print("User ID: $userId");

        final ref = FirebaseStorage.instance
            .ref()
            .child("user_image")
            .child('${userId!}.png');
        await ref.putFile(userData!["userImageFile"] as File);
        userImageUrl = await ref.getDownloadURL();
        // print("user Image: $userImageUrl");

        await FirebaseFirestore.instance.collection("users").doc(userId).set({
          "username": userData["username"],
          "email": email,
          "userImageUrl": userImageUrl,
        });
        userName = userData["username"];
        userEmail = email;
      } else {
        final authResponse = await auth.signInWithEmailAndPassword(
            email: email, password: password);
        userId = authResponse.user!.uid;

        final fetchedUserData = await FirebaseFirestore.instance
            .collection("users")
            .doc(userId)
            .get();
        final userLoginData = fetchedUserData.data();

        userEmail = userLoginData!["useremail"];
        userName = userLoginData["username"];
        userImageUrl = userLoginData["userImageUrl"];
        // print(fetchedUserData);
      }
      // print("Authentication Successfull");
    } on FirebaseAuthException catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Padding(
            padding: const EdgeInsets.all(5),
            child: Text(err.message.toString()),
          )));
      rethrow;
    }
    // print("Authentication completed");
    // notifyListeners();
  }

  void resetPassword(String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Padding(
            padding: const EdgeInsets.all(5),
            child: Text(err.toString()),
          )));
      rethrow;
    }
  }
}
