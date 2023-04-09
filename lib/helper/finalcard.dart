import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketguide/tabs/home.dart';

import 'colors.dart';

class FinalCustomCard extends StatefulWidget {
  bool isCameraImage;
  final image;
  String title;
  String location;
  String description;
  String rating;
  FinalCustomCard(
      {required this.description,
      required this.image,
      required this.isCameraImage,
      required this.location,
      required this.rating,
      required this.title});

  @override
  State<FinalCustomCard> createState() => _FinalCustomCardState();
}

class _FinalCustomCardState extends State<FinalCustomCard> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.9,
      child: Stack(
        children: [
          Container(
            height: size.height * 0.7,
            width: size.width,
            child: widget.isCameraImage
                ? Image.file(
                    File(widget.image.path),
                    fit: BoxFit.fill,
                  )
                : Image.network(
                    widget.image,
                    fit: BoxFit.fill,
                  ),
          ),
          Container(
            height: size.height * 0.9,
            width: size.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.35, 0.65],
                    colors: [Colors.transparent, mybackground])),
            child: Align(
              alignment: Alignment(-0.95, 0.05),
              child: Container(
                height: size.height * 0.18,
                padding: EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      widget.rating,
                      style: TextStyle(
                          fontSize: 16, fontFamily: "Poppins", color: mywhite),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Recommanded",
                      style: TextStyle(
                          fontSize: 16, fontFamily: "Poppins", color: mywhite),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      widget.title,
                      style: TextStyle(
                          fontSize: widget.title.length > 20 ? 24 : 34,
                          fontFamily: "Poppins",
                          color: mywhite),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      widget.location,
                      style: TextStyle(
                          fontSize: 16, fontFamily: "Poppins", color: mywhite),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              top: 15,
              left: 20,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 40,
                  width: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white.withAlpha(20)),
                  child: Center(
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
              )),
          Positioned(
              bottom: 170,
              left: 20,
              child: Container(
                height: 70,
                width: size.width * 0.7,
                child: Text(
                  widget.description,
                  style: TextStyle(
                      overflow: TextOverflow.fade,
                      fontSize: 12,
                      fontFamily: "Poppins",
                      color: mywhite),
                ),
              )),
          Positioned(
            bottom: 5,
            left: 25,
            right: 25,
            child: Container(
                height: 160,
                width: size.width * 0.8,
                // color: Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Things to do",
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          color: mywhite),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 40,
                                child: Image.asset("assets/image/trekking.png"),
                              ),
                              Text(
                                "trekking",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "Inter",
                                    color: mywhite),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 40,
                                child: Image.asset("assets/image/climbing.png"),
                              ),
                              Text(
                                "climbing",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "Inter",
                                    color: mywhite),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 40,
                                child: Image.asset("assets/image/camping.png"),
                              ),
                              Text(
                                "camping",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "Inter",
                                    color: mywhite),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
