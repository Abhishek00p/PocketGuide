import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toast/toast.dart';

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
  addMyBookMark(image, String title, String rating, String description,
      bool isCameraImage, String location) async {
    final _control = Get.put(GetXControllers());
    _control.BookMarkList.add({
      "image": image,
      "isCameraImage": isCameraImage,
      "location": location,
      "description": description,
      "title": title,
      "rating": rating,
      "isbookMarked": true
    });
  }

  removeFromBookMark(String title) async {
    final _control = Get.put(GetXControllers());
    _control.BookMarkList.removeWhere((element) {
      if (element["title"] == title) {
        return true;
      } else {
        return false;
      }
    });
  }
}
