import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:pocketguide/api/model.dart';
import 'package:pocketguide/api/myfile.dart';
import 'package:pocketguide/helper/colors.dart';
import 'package:pocketguide/helper/helper.dart';

class BookMark extends StatefulWidget {
  @override
  State<BookMark> createState() => _BookMarkState();
}

class _BookMarkState extends State<BookMark> {
  var getTitles;

  @override
  void initState() {
    getallBookMarksForThisUser().then((value) => getTitles = value);

    super.initState();
  }

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
                  child: FutureBuilder(
                      future: getallBookMarksForThisUser(),
                      builder: (BuildContext context, AsyncSnapshot getTitles) {
                        if (getTitles.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (getTitles.hasError) {
                          return Center(
                            child: Text("Something wrong"),
                          );
                        }
                        if (!getTitles.hasData) {
                          return Center(
                            child: Text("No data found"),
                          );
                        }
                        return FutureBuilder(
                          future: Database().loadData(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.hasError) {
                              return Center(
                                child: Text("Something wrong"),
                              );
                            }
                            if (!snapshot.hasData) {
                              return Center(
                                child: Text("No data found"),
                              );
                            }
                            print(
                                " the values are  gettiels : ${getTitles.data}  and      snapsh : ${snapshot.data}");
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: ListView.builder(
                                itemCount: getTitles.data.length,
                                itemBuilder: (context, index) {
                                  final modelData = Model.fromJson(
                                      snapshot.data!["res"][getTitles
                                          .data[index].id
                                          .toString()
                                          .trim()]);

                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: size.height * 0.08,
                                      width: size.width * 0.8,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: mywhite),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            height: size.height * 0.07,
                                            width: size.width * 0.20,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: Image.network(
                                                modelData.image,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            modelData.title,
                                            style: TextStyle(
                                                color: myyellow,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 16),
                                          ),
                                          IconButton(
                                              onPressed: () async {
                                                await BookMarkFunctions()
                                                    .removeFromBookMark(
                                                        modelData.title);
                                                setState(() {});
                                              },
                                              icon: Icon(
                                                Icons.bookmark,
                                                color: myyellow,
                                              ))
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      })),
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

getallBookMarksForThisUser() async {
  final _firestore = await FirebaseFirestore.instance
      .collection("allUser")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("Bookmarks")
      .get();

  return await _firestore.docs;
}
