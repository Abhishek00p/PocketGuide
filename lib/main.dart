import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketguide/api/model.dart';
import 'package:pocketguide/helper/colors.dart';
import 'package:pocketguide/helper/helper.dart';
import 'package:pocketguide/tabs/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
    );
  }
}

class WelcomePage extends StatefulWidget {
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _controll = Get.put(GetXControllers());
  bool isReady = false;
  var data;
  ready() async {
    data = await Database().loadData();
    isReady = true;
  }

  @override
  void initState() {
    super.initState();
    ready();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => isReady
                    ? HomePage(data: data)
                    : Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    ready();
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                  ),
                                  child: Center(
                                    child: Text("Refresh"),
                                  ),
                                )),
                            Center(child: CircularProgressIndicator()),
                          ],
                        ),
                      ))));
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Container(
          color: mybackground,
          height: h,
          width: w,
          child: Column(
            children: [
              SizedBox(
                height: h / 2.5,
              ),
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/image/logo.png",
                  height: 100,
                  width: 100,
                ),
              ),
              SizedBox(
                height: h / 3,
              ),
              Text(
                "Pocket Guide",
                style: TextStyle(
                    decoration: TextDecoration.none,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w800,
                    color: Color.fromRGBO(214, 162, 102, 1),
                    fontSize: 32,
                    fontFamily: "Poppins"),
              ),
              Text(
                "Explore the World",
                style: TextStyle(
                    decoration: TextDecoration.none,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w500,
                    color: myyellow,
                    fontSize: 16,
                    fontFamily: "Poppins"),
              ),
            ],
          )),
    );
  }
}
