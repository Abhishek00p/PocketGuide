import 'dart:io';

import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pocketguide/helper/helper.dart';
import 'package:pocketguide/helper/colors.dart';
import 'package:pocketguide/screens/final.dart';

//5ae2e3f221c38a28845f05b62310c9dde5040fbddadf0ad4bd35a14f  https://opentripmap.io/docs
class SearchMe extends StatefulWidget {
  var dataList;
  final data;
  SearchMe({this.data, this.dataList});

  @override
  State<SearchMe> createState() => _SearchMeState();
}

class _SearchMeState extends State<SearchMe> {
  final _controller = Get.put(GetXControllers());
  TextEditingController textController = TextEditingController();
  var placeTitles;

  @override
  void initState() {
    super.initState();
    placeTitles = widget.data["res"].keys.toList();
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizes = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: mybackground,
        body: Container(
          height: sizes.height,
          width: sizes.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: myyellow,
                          size: 24,
                        )),
                    Container(
                      height: 50,
                      width: 229,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: myyellow),
                      child: Center(
                          child: Container(
                        width: 200,
                        child: TextFormField(
                            onEditingComplete: () async {
                              var returnedList = await matchString(
                                  textController.text, widget.data);

                              setState(() {
                                widget.dataList = returnedList["list"];
                                placeTitles = returnedList["list"];
                              });
                            },
                            cursorColor: mybackground,
                            style: TextStyle(decoration: TextDecoration.none),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Search Here"),
                            controller: textController),
                      )),
                    ),
                    IconButton(
                        onPressed: () async {
                          var returnedList = await matchString(
                              textController.text, widget.data);

                          setState(() {
                            widget.dataList = returnedList["list"];
                            placeTitles = returnedList["list"];
                          });
                        },
                        icon: Icon(
                          Icons.search,
                          size: 36,
                          color: myyellow,
                        ))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  thickness: 2.5,
                  color: myyellow,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 600,
                  padding: EdgeInsets.only(left: 15, right: 15, bottom: 20),
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: widget.dataList.length,
                      itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: InkWell(
                              onTap: () async {
                                print(widget.data["res"]);
                                // String placeTitle =
                                //     widget.data["res"].keys.toList()[index];
                                var myplace =
                                    widget.data["res"][placeTitles[index]];
                                var StringUrl = myplace["image"];
                                // File file = await toFile(StringUrl);
                                await Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FinalPage(
                                              isCameraImage: false,
                                              image: myplace["image"],
                                              description:
                                                  myplace["Description"],
                                              title: myplace["Title"],
                                              rating: "4.3",
                                              location: myplace["City"],
                                            )));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: myyellow,
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(15)),
                                height: 50,
                                width: sizes.width - 120,
                                child: Center(
                                  child: Text(
                                    widget.dataList[index],
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                          )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

matchString(String s, data) async {
  List<String> list = [];
  int i;
  // print(data["res"].keys.toList());
  for (i = 0; i < data["len"]; i++) {
    var myplace = await data["res"][data["res"].keys.toList()[i]];
    // print(myplace);
    if (myplace["Title"].toLowerCase().contains(s.toLowerCase())) {
      list.add(myplace["Title"]);
      print(myplace["Title"]);
    }
  }
  return {"list": list, "ind": i};
}
