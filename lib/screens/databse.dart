import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

final store_ints = FirebaseFirestore.instance.collection("reviews");
final FirebaseAuth _auth = FirebaseAuth.instance;

addReview(String content, double star, String placeName) async {
  try {
    await store_ints
        .doc(placeName)
        .collection(_auth.currentUser!.uid)
        .doc(_auth.currentUser!.displayName)
        .set({
      "name": _auth.currentUser!.displayName,
      "content": content,
      "stars": star
    });
    Fluttertoast.showToast(msg: "Added review");
  } catch (e) {
    Fluttertoast.showToast(msg: "msg:$e");
  }
}

class AuthService {
  // Register with email and password
  Future registerWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      user.updateDisplayName(name);
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // Sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
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
