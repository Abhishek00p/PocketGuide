import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Creategude extends StatefulWidget {
  const Creategude({super.key});

  @override
  State<Creategude> createState() => _CreategudeState();
}

class _CreategudeState extends State<Creategude> {
  TextEditingController placeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: placeController,
            ),
            FloatingActionButton(onPressed: () async {
              final _auth = FirebaseAuth.instance;
              final fires = FirebaseFirestore.instance
                  .collection("guides")
                  .doc(_auth.currentUser!.uid);

              await fires.set({
                "name": _auth.currentUser!.displayName,
                "photourl": "",
                "uid": "${_auth.currentUser!.uid}",
                "place": placeController.text
              });
            })
          ],
        ),
      )),
    );
  }
}
