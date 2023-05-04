import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pocketguide/api/model.dart';
import 'package:pocketguide/helper/colors.dart';
import 'package:pocketguide/helper/helper.dart';
import 'package:pocketguide/helper/login.dart';
import 'package:pocketguide/tabs/home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'helper/authenticateuser.dart';
import 'news.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await dotenv.load();

  runApp(MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(" notifi from BG ${message.data}");
  print(" notifi from BG ${message.notification!.title}");
}

Future<void> _firebaseMessagingOnMessage(RemoteMessage message) async {
  // Handle foreground message
  print(" notifi from onmesg $message");
}

Future<void> _firebaseMessagingOnMessageOpenedApp(RemoteMessage message) async {
  // Handle notification tapped event
  print(" notifi from onpenmesg $message");
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
  @override
  void initState() {
    super.initState();

    Timer(
        Duration(seconds: 3),
        () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => Authenticate())));
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
                  child: Image.asset("assets/image/logo.png")),
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
