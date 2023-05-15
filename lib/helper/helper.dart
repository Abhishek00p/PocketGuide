import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  addMyBookMark(String title) async {
    final _firestore = await FirebaseFirestore.instance
        .collection("allUser")
        .doc(user.uid)
        .collection("Bookmarks")
        .doc(title);

    await _firestore.set({"title": title});
  }

  removeFromBookMark(String title) async {
    final user = FirebaseAuth.instance.currentUser!;
    final firestore = await FirebaseFirestore.instance
        .collection("allUser")
        .doc(user.uid)
        .collection("Bookmarks");

    final docD = await firestore.get();
    for (var element in docD.docs) {
      if (title.trim() == element.id.toString().trim()) {
        await firestore.doc(element.id).delete().then(
            (value) => Fluttertoast.showToast(msg: "Succesfully deleted"));
      }
    }
  }
}
