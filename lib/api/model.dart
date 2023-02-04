import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Database {
  loadData() async {
    var resp;
    String urlStrig = "http://pocketguide.pythonanywhere.com/";
    try {
      final data = await http.get(Uri.parse(urlStrig));

      resp = await json.decode(data.body);
    } catch (e) {
      Fluttertoast.showToast(msg: "$e");
    }
    print(resp.keys.toList().length);
    return {"res": resp, "len": await resp.keys.toList().length};
  }
}
