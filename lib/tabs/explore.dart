import 'package:flutter/material.dart';
import 'package:pocketguide/helper/finalcard.dart';

import '../api/myfile.dart';
import '../helper/colors.dart';
import '../screens/final.dart';

class Explore extends StatefulWidget {
  final data;
  Explore({required this.data});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          title: Align(
            alignment: Alignment(-0.25, 0),
            child: Text(
              "Explore",
              style: TextStyle(
                  decoration: TextDecoration.none,
                  fontStyle: FontStyle.normal,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(214, 162, 102, 1),
                  fontSize: 24,
                  fontFamily: "Poppins"),
            ),
          ),
          leading: Row(
            children: [
              SizedBox(
                width: 8,
              ),
              Container(
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: myyellow,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ],
          ),
          actions: [],
        ),
        backgroundColor: mybackground,
        body: SafeArea(
            child: Container(
                height: size.height,
                width: size.width,
                child: Column(
                  children: [
                    Expanded(
                        child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.data["len"],
                      itemBuilder: (context, index) {
                        final usableData = widget.data["res"].keys.toList();
                        // print("--$usableData");
                        final modelData = Model.fromJson(
                            widget.data["res"][usableData[index]]);

                        // print("--------${modelData.image}");
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FinalPage(
                                          isCameraImage: false,
                                          image: modelData.image,
                                          location: modelData.city,
                                          description: modelData.description,
                                          rating: "3.5",
                                          title: modelData.title,
                                        )));
                          },
                          child: FinalCustomCard(
                              description: modelData.description,
                              image: modelData.image,
                              isCameraImage: false,
                              location: modelData.city,
                              rating: "2.5",
                              title: modelData.title),
                        );
                      },
                    )),
                  ],
                ))));
  }
}
