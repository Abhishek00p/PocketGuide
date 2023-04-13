import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

final reviews_instance =
    FirebaseFirestore.instance.collection("users").doc("reviews");
final FirebaseAuth _auth = FirebaseAuth.instance;

addReview(String content, double star, String placeName) async {
  try {
    await reviews_instance
        .collection(placeName.toLowerCase().trim())
        .doc(_auth.currentUser!.uid)
        .set({
      "name": _auth.currentUser!.displayName,
      "content": content,
      "stars": star.toString()
    });
    Toast.show("Added review");
  } catch (e) {
    Toast.show("msg:$e");
  }
}

class AuthService {
  // Register with email and password
  Future registerWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = userCredential.user!;
      await user.updateDisplayName(name);

      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // final usernameColl =
      //     firestore.collection("users").doc(user.uid).collection("name").doc();
      // await usernameColl.set({"name": user.displayName.toString()});

      Toast.show("user Register succesfully",
          duration: 2,
          backgroundColor: Colors.white,
          textStyle: TextStyle(color: Colors.black));
      return user;
      // Do something with the user object
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Toast.show('The password provided is too weak.', duration: 3);
        return null;
      } else if (e.code == 'email-already-in-use') {
        Toast.show('The account already exists for that email.', duration: 3);
        return null;
      }
    } catch (e) {
      Toast.show(e.toString(), duration: 3);
      return null;
    }
  }

  // Sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = userCredential.user!;
      Toast.show("Welcome",
          duration: 2,
          backgroundColor: Colors.white,
          textStyle: TextStyle(color: Colors.black));
      return true;
      // Do something with the user object
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Toast.show('No user found for that email.', duration: 3);
      } else if (e.code == 'wrong-password') {
        Toast.show('Wrong password provided for that user.', duration: 3);
      } else {
        Toast.show(e.toString(), duration: 3);
      }
      return false;
    } catch (e) {
      Toast.show(e.toString(), duration: 3);
      return false;
    }
  }

  // Sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
