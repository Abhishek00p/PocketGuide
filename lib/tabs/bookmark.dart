import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:pocketguide/api/myfile.dart';
import 'package:pocketguide/helper/colors.dart';
import 'package:pocketguide/helper/helper.dart';

class BookMark extends StatefulWidget {
  @override
  State<BookMark> createState() => _BookMarkState();
}

class _BookMarkState extends State<BookMark> {
  final _controll = Get.put(GetXControllers());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          title: Align(
            alignment: Alignment(-0.25, 0),
            child: Text(
              "BookMark",
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
        body: Container(
          height: size.height,
          width: size.width,
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Divider(
                indent: 40,
                thickness: 2.5,
                color: myyellow,
              ),
              Expanded(
                child: ListView.builder(
                    padding: EdgeInsets.all(15),
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _controll.BookMarkList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          height: size.height * 0.15,
                          width: size.width * 0.8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: myyellow,
                          ),
                          child: Stack(children: [
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                height: size.height * 0.15,
                                width: 100,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: _controll.BookMarkList[index]
                                          ["isCameraImage"]
                                      ? Image.asset(_controll
                                          .BookMarkList[index]["image"].path)
                                      : Image.network(
                                          _controll.BookMarkList[index][
                                              "image"], // changes to be needed. { Make only list of bookmarked}
                                          fit: BoxFit.fill,
                                        ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 120,
                              child: Container(
                                height: size.height * 0.15,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        _controll.BookMarkList[index]["title"]),
                                    Text(_controll.BookMarkList[index]
                                        ["location"]),
                                    Text("10:00 - 17:00"),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                                right: 15,
                                top: 30,
                                child: IconButton(
                                    onPressed: () async {
                                      await BookMarkFunctions()
                                          .removeFromBookMark(_controll
                                              .BookMarkList[index]["title"]);
                                      setState(() {});
                                    },
                                    icon: Icon(
                                      Icons.bookmark,
                                      color: mybackground,
                                      size: 30,
                                    ))),
                          ]),
                        ),
                      );
                    }),
              ),
              Divider(
                endIndent: 40,
                thickness: 2.5,
                color: myyellow,
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
