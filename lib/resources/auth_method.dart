import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zoltrakk/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  Future<String> signUpUser({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      // Validate empty fields (improved error handling)
      if (username.isEmpty || email.isEmpty || password.isEmpty) {
        throw Exception('Please fill in all required fields.'); // More specific error message
      }

      // Create user with FirebaseAuth
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

          model.User user = model.User(
            username: username,
        uid: cred.user!.uid, // Consistent field name
        email: email,
        followers: [],
        following: [],
          );

          

      // Add user data to Firestore with proper field names
      await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());

      return 'success';
    } on FirebaseAuthException catch (err) {
      // Handle FirebaseAuth errors (more informative messages)
      if (err.code == 'weak-password') {
        return 'Password is too weak.';
      } else if (err.code == 'email-already-in-use') {
        return 'Email address already in use.';
      } else {
        return 'Registration failed: ${err.message}'; // Generic error with details
      }
    } catch (err) {
      // Handle other errors (catch-all for unexpected issues)
      print('Unexpected error during signup: $err');
      return 'Registration failed. Please try again later.'; // User-friendly message
    }
  }
  Future <String> loginUser({
    required String email,
    required String password,


  })async {
    String res = "some error occured";
    try{
      if(email.isNotEmpty || password.isNotEmpty){
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res="success";
      }else{
        res = "Please enter all the fields";
      }
    }catch(err){
      res = err.toString();
    }
    return res;


  }
}
