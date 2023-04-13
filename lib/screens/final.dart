import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:pocketguide/helper/colors.dart';
import 'package:pocketguide/helper/finalcard.dart';
import 'package:pocketguide/helper/helper.dart';
import 'package:pocketguide/screens/databse.dart';

class FinalPage extends StatefulWidget {
  final image;
  String title;
  String rating;
  String description;
  bool isCameraImage;
  String location;
  FinalPage(
      {required this.image,
      required this.isCameraImage,
      required this.description,
      required this.location,
      required this.rating,
      required this.title});

  @override
  State<FinalPage> createState() => _FinalPageState();
}

class _FinalPageState extends State<FinalPage> {
  var _ratingValue = 0.0;
  final _control = Get.put(GetXControllers());
  TextEditingController textController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  @override
  void initState() {
    getReviews();
    super.initState();
  }

  getReviews() async {
    var data;
    await FirebaseFirestore.instance
        .collection("users")
        .doc("reviews")
        .collection(widget.title.toLowerCase().trim())
        .get()
        .then((value) => data = value);
    return data.docs;
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: mybackground,
        body: Container(
          height: h,
          width: w,
          child: SingleChildScrollView(
            child: Column(
              children: [
                FinalCustomCard(
                  description: widget.description,
                  image: widget.image,
                  isCameraImage: widget.isCameraImage,
                  location: widget.location,
                  rating: widget.rating,
                  title: widget.title,
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: h * 0.3,
                  padding: EdgeInsets.all(8),
                  child: FutureBuilder(
                    future: getReviews(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                            child: Text("Something is not Good here"));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.data.isEmpty || !snapshot.hasData) {
                        print(snapshot.data!);
                        return Container(
                          child: Center(
                            child: Text(
                              "No reviews yet !! ",
                              style: TextStyle(color: myyellow),
                            ),
                          ),
                        );
                      }

                      if (snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.done) {
                        print("Reviews are  : ${snapshot.data!}");
                        return GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 180,
                                    childAspectRatio: 2 / 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10),
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) => Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  elevation: 2,
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color.fromRGBO(214, 162, 102, 1),
                                    ),
                                    height: 85,
                                    width: 150,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          snapshot.data[index]["name"]
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: "Poppins",
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width: 120,
                                              height: 20,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  return Icon(
                                                    Icons.star,
                                                    color: Colors.white,
                                                    size: 20,
                                                  );
                                                },
                                                itemCount: double.tryParse(
                                                        snapshot.data[index]
                                                            ["stars"])!
                                                    .round(),
                                              ),
                                            )
                                          ],
                                        ),
                                        Text(
                                          snapshot.data[index]["content"]
                                              .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              color: Colors.white,
                                              fontFamily: "Poppins"),
                                        )
                                      ],
                                    ),
                                  ),
                                ));
                      } else {
                        print(
                            "Connectionstate : ${snapshot.connectionState}  and datahas: ${snapshot.hasData}");
                        return Center(child: Text("Something went wrong"));
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    var value = showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    height: 40,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all()),
                                    child: Center(
                                      child: Text(
                                        "Enter your Review",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: myyellow,
                                            fontFamily: "Poppins"),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    height: 40,
                                    width: w * 0.7,
                                    child: TextFormField(
                                      textDirection: TextDirection.ltr,
                                      onChanged: (s) {},
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black54),
                                      controller: textController,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  RatingBar(
                                      ratingWidget: RatingWidget(
                                          full: const Icon(Icons.star,
                                              color: Colors.black),
                                          half: const Icon(
                                            Icons.star_half,
                                            color: Colors.black,
                                          ),
                                          empty: const Icon(
                                            Icons.star_outline,
                                            color: Colors.black,
                                          )),
                                      updateOnDrag: true,
                                      onRatingUpdate: (value) {
                                        setState(() {
                                          _ratingValue = value;
                                        });
                                      }),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  InkWell(
                                      onTap: () async {
                                        await addReview(
                                            textController.text,
                                            _ratingValue,
                                            widget.title
                                                .toString()
                                                .toLowerCase());
                                        setState(() {});

                                        textController.clear();
                                      },
                                      child: Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                            border: Border.all(),
                                            color: mybackground,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        width: 120,
                                        child: Center(
                                            child: Text(
                                          "submit",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: myyellow,
                                              fontFamily: "Poppins"),
                                        )),
                                      ))
                                ],
                              ),
                            ));

                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(217, 217, 217, 1),
                        borderRadius: BorderRadius.circular(20)),
                    height: 32,
                    width: 210,
                    child: Center(
                        child: Text(
                      "Add your Review",
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: "Poppins",
                          // color: Color.fromARGB(1, 217, 217, 217),
                          color: Colors.orange[400],
                          fontWeight: FontWeight.w500),
                    )),
                  ),
                ),
                SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
