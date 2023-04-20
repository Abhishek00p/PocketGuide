import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pocketguide/tabs/home.dart';
import 'package:toast/toast.dart';

import 'login.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    ToastContext().init(context);
    if (auth.currentUser != null) {
      print("user ${auth.currentUser!.uid}");
      return HomePage();
    } else {
      return LoginPage();
    }
  }
}
