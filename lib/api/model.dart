import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Database {
  loadData() async {
    var resp;
    String urlStrig = "http://vivekjha.pythonanywhere.com/";
    try {
      final data = await http.get(Uri.parse(urlStrig));

      resp = await json.decode(data.body);
    } catch (e) {
      Fluttertoast.showToast(msg: "$e");
    }
    // print(resp.keys.toList().length);
    return {"res": resp, "len": await resp.keys.toList().length};
  }

  Future<http.Response> postRequestNotification(
      String recID, String sendid, String mesg) async {
    String url = 'https://fcm.googleapis.com/fcm/send';
    String token = dotenv.env["SERVERkEY"]!;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final fireresp =
        await FirebaseFirestore.instance.collection("allUser").doc(recID).get();

    final senderdata = await FirebaseFirestore.instance
        .collection("allUser")
        .doc(sendid)
        .get()
        .then((value) => value.data());

    final userdata = fireresp.data();
    final usertoken = userdata!["pushtoken"];
    print("usertoken : $usertoken");
    final body = json.encode({
      "to": usertoken,
      "notification": {
        "title": "new message from ${senderdata!["name"]} ",
        "body": "$mesg"
      }
    });

    http.Response response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    return response;
  }
}
