import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth with ChangeNotifier{
  String? userEmail;
  String? userName;
  String? userId;

  Auth({
    this.userEmail,
    this.userName,
    this.userId,
  });

  bool isAuth(){
    if(userId != null){
      return true;
    }
    return false;
  }

  void logout(){
    FirebaseAuth.instance.signOut();
    userEmail=null;
    userName=null;
    userId=null;
    // notifyListeners();
    print("logged out");
  }

  Future<void> authenticate({
    required BuildContext context,
    required String email,
    required String password,
    bool isSignup=false,
    Map<String,dynamic>? userData,
  }) async {
    // print("Authentication Started");
    final auth=FirebaseAuth.instance;
    try{
      if(isSignup){
        final authResponse = await auth.createUserWithEmailAndPassword(email: email, password: password);
        userId=authResponse.user!.uid;
        // print("User ID: $userId");
        await FirebaseFirestore.instance.collection("users").doc(userId).set({
          "username":userData!["username"],
          "email": email,
          });
        userName=userData["username"];
        userEmail=email;
      }
      else{
        final authResponse=await auth.signInWithEmailAndPassword(email: email, password: password);
        userId=authResponse.user!.uid;
        
        final fetchedUserData=await FirebaseFirestore.instance.collection("users").doc(userId).get();
        final userLoginData=fetchedUserData.data();

        userEmail=userLoginData!["useremail"];
        userName=userLoginData["username"];
        // print(fetchedUserData);
      }
      // print("Authentication Successfull");
    }on FirebaseAuthException catch(err){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).colorScheme.error,
            content: Padding(
              padding: EdgeInsets.all(5),
              child: Text(err.message.toString()),
          ))
        );
        rethrow;
    }
    // print("Authentication completed");
    // notifyListeners();
  }

}
