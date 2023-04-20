import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Helper {
  final _jsonData;
  Helper(this._jsonData);

  Future<List<String>> getTitle() async {
    List<String> mylist = [];
    for (int i = 0; i < _jsonData["len"]; i++) {
      // print("hellper--");
      // print(_jsonData["res"][_jsonData["res"].keys.toList()[i]]);
      // print("--hellper");

      mylist.add(_jsonData["res"][_jsonData["res"].keys.toList()[i]]["Title"]);
    }

    return mylist;
  }
}

class GetXControllers extends GetxController {
  var BookMarkList = [].obs;
}

class BookMarkFunctions {
  final user = FirebaseAuth.instance.currentUser!;

  addMyBookMark(image, String title, String rating, String description,
      bool isCameraImage, String location) async {
    final _firestore =
        FirebaseFirestore.instance.collection("allUser").doc(user.uid);

    await _firestore.get().then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        var field1Value = documentSnapshot['bookmarks'];
        field1Value.add({
          "image": image,
          "isCameraImage": isCameraImage,
          "location": location,
          "description": description,
          "title": title,
          "rating": rating,
        });

        await _firestore.update({
          "bookmarks": field1Value,
          "name": user.displayName,
          "photourl": "",
          "uid": "${user.uid}"
        });
      } else {
        print('Document does not exist');
      }
    });
  }

  removeFromBookMark(String title) async {
    final user = FirebaseAuth.instance.currentUser!;
    final firestore =
        FirebaseFirestore.instance.collection("allUser").doc(user.uid);

    final bData = await firestore.get().then((value) async {
      value["bookmarks"].removeWhere((val) => val["title"] == title);
    });
  }
}
