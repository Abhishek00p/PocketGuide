import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketguide/tabs/explore.dart';
import 'package:pocketguide/helper/helper.dart';
import 'package:pocketguide/api/myfile.dart';
import 'package:pocketguide/helper/colors.dart';
import 'package:pocketguide/screens/final.dart';
import 'package:pocketguide/screens/scanner.dart';
import 'package:pocketguide/screens/searchBar.dart';
import 'package:pocketguide/tabs/bookmark.dart';
import 'package:toast/toast.dart';

class HomePage extends StatefulWidget {
  late final data;
  HomePage({required this.data});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controll = Get.put(GetXControllers());
  var isBookMarked = false;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    ToastContext().init(context);
    return Scaffold(
      backgroundColor: Color.fromRGBO(27, 50, 50, 1),
      appBar: AppBar(
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 8,
            ),
          ],
        ),
        actions: [
          InkWell(
              onTap: () async {
                var list = await Helper(widget.data).getTitle();
                // print("home 39 Searchicon $list\n");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SearchMe(dataList: list, data: widget.data)));
              },
              child: Image.asset(
                "assets/image/search.png",
                height: 50,
                width: 50,
              )),
          SizedBox(
            width: 8,
          )
        ],
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        title: Center(
          child: Text(
            "Pocket Guide",
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
      ),
      bottomNavigationBar: Container(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  height: 75,
                  width: w / 3.1,
                  child: Center(
                    child: Icon(
                      Icons.home,
                      color: myyellow,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Explore(data: widget.data)));
                },
                child: Container(
                    height: 75,
                    width: w / 3.1,
                    child:
                        Center(child: Image.asset("assets/image/Compass.png"))),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BookMark()));
                },
                child: Container(
                    height: 75,
                    width: w / 3.1,
                    child: Center(
                        child: Image.asset("assets/image/Bookmark.png"))),
              )
            ],
          )),
      body: Container(
        height: h,
        width: w,
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
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.only(left: 12, right: 12),
              child: Container(
                height: h / 1.66,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    final usableData = widget.data["res"].keys;
                    // print("--$usableData");
                    final modelData = Model.fromJson(
                        widget.data["res"][usableData.toList()[index]]);

                    // print("--------${modelData.image}");
                    var booking = false;
                    return Padding(
                      padding: const EdgeInsets.only(left: 22.0),
                      child: Stack(
                        children: [
                          Positioned(
                            child: InkWell(
                              onTap: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FinalPage(
                                              isCameraImage: false,
                                              image: modelData.image,
                                              location: modelData.city,
                                              description:
                                                  modelData.description,
                                              rating: "3.5",
                                              title: modelData.title,
                                            )));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(72),
                                    topRight: Radius.circular(72)),
                                child: Image.network(
                                  modelData.image,
                                  fit: BoxFit.fill,
                                  width: 296,
                                  height: 464,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                              bottom: 15,
                              left: 20,
                              child: IconButton(
                                  onPressed: () async {
                                    isBookMarked = await checkIfBookMarked(
                                        modelData.title);

                                    if (isBookMarked) {
                                      await BookMarkFunctions()
                                          .removeFromBookMark(modelData.title);

                                      Toast.show("Removed from BookMark",
                                          backgroundColor: mywhite,
                                          textStyle: TextStyle(
                                              color: mybackground,
                                              fontFamily: "Poppins",
                                              fontSize: 14));
                                    } else {
                                      await BookMarkFunctions().addMyBookMark(
                                          modelData.image,
                                          modelData.title,
                                          "3.5",
                                          modelData.description,
                                          false,
                                          modelData.city);

                                      Toast.show("Added to BookMark",
                                          backgroundColor: mywhite,
                                          textStyle: TextStyle(
                                              color: mybackground,
                                              fontFamily: "Poppins",
                                              fontSize: 14));
                                    }
                                    setState(() {});
                                  },
                                  icon: isBookMarked
                                      ? Icon(
                                          Icons.bookmark,
                                          size: 25,
                                          color: myyellow,
                                        )
                                      : Icon(
                                          Icons.bookmark_border_outlined,
                                          size: 25,
                                          color: myyellow,
                                        ))),
                          Positioned(
                            top: 40,
                            left: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "4.8 *",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "Poppins",
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "Recommanded",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "Poppins",
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  modelData.title,
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontFamily: "Poppins",
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "Mumbai maharashtra",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "Poppins",
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Divider(
              endIndent: 34,
              thickness: 2.5,
              color: myyellow,
            ),
            Container(
                height: 40,
                padding: EdgeInsets.only(top: 10),
                child: Stack(
                  children: [
                    Positioned(
                      top: 15,
                      left: 60,
                      child: Text(
                        "Scan your vista",
                        style: TextStyle(
                            color: mywhite,
                            fontFamily: "Inter",
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Positioned(
                      right: 30,
                      child: InkWell(
                        onTap: () async {
                          await availableCameras()
                              .then((value) => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Scanner(
                                            cameras: value,
                                          ))));
                        },
                        child: Image.asset(
                          "assets/image/scan.png",
                          height: 33,
                        ),
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

checkIfBookMarked(String title) {
  final _control = Get.put(GetXControllers());
  for (var element in _control.BookMarkList) {
    if (element["title"] == title) {
      return true;
    }
  }
  return false;
}
