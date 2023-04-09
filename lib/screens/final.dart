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

  getREviews() async {
    final placeDAta = await FirebaseFirestore.instance
        .collection("reviews")
        .doc(widget.title.toString().toLowerCase())
        .get();
    // print(placeDAta.data());
  }

  @override
  void initState() {
    // getREviews();
    super.initState();
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
                // Container(
                //   height: 400,
                //   // color: Colors.red,
                //   padding: EdgeInsets.all(8),
                //   child: FutureBuilder(
                //     future: getREviews(),
                //     builder: (context, AsyncSnapshot snapshot) {
                //       if (snapshot.hasData &&
                //           snapshot.connectionState == ConnectionState.done) {
                //         return GridView.builder(
                //             shrinkWrap: true,
                //             gridDelegate:
                //                 SliverGridDelegateWithMaxCrossAxisExtent(
                //                     maxCrossAxisExtent: 180,
                //                     childAspectRatio: 2 / 2,
                //                     crossAxisSpacing: 10,
                //                     mainAxisSpacing: 10),
                //             itemCount: snapshot.data.length,
                //             itemBuilder: (context, index) => Card(
                //                   shape: RoundedRectangleBorder(
                //                       borderRadius: BorderRadius.circular(20)),
                //                   elevation: 2,
                //                   child: Container(
                //                     padding: EdgeInsets.all(8),
                //                     decoration: BoxDecoration(
                //                       borderRadius: BorderRadius.circular(20),
                //                       color: Color.fromRGBO(214, 162, 102, 1),
                //                     ),
                //                     height: 85,
                //                     width: 150,
                //                     child: Column(
                //                       mainAxisAlignment:
                //                           MainAxisAlignment.spaceEvenly,
                //                       children: [
                //                         Text(
                //                           snapshot.data[index]["name"]
                //                               .toString(),
                //                           style: TextStyle(
                //                               fontSize: 20,
                //                               fontFamily: "Poppins",
                //                               color: Colors.white,
                //                               fontWeight: FontWeight.w400),
                //                         ),
                //                         Row(
                //                           children: [
                //                             Container(
                //                               width: 120,
                //                               height: 20,
                //                               child: ListView.builder(
                //                                 scrollDirection:
                //                                     Axis.horizontal,
                //                                 itemBuilder: (context, index) {
                //                                   return Icon(
                //                                     Icons.star,
                //                                     color: Colors.white,
                //                                     size: 20,
                //                                   );
                //                                 },
                //                                 itemCount: int.parse(snapshot
                //                                     .data[index]["star"]
                //                                     .toString()),
                //                               ),
                //                             )
                //                           ],
                //                         ),
                //                         Text(
                //                           snapshot.data[index]["feedback"]
                //                               .toString(),
                //                           style: TextStyle(
                //                               fontWeight: FontWeight.w300,
                //                               color: Colors.white,
                //                               fontFamily: "Poppins"),
                //                         )
                //                       ],
                //                     ),
                //                   ),
                //                 ));
                //       } else if (snapshot.connectionState ==
                //           ConnectionState.waiting) {
                //         return CircularProgressIndicator();
                //       } else {
                //         return Container(
                //           child: Center(
                //             child: Text("No reviews yet !! "),
                //           ),
                //         );
                //       }
                //     },
                //   ),
                // ),
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
