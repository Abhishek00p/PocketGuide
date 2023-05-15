import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pocketguide/helper/login.dart';
import 'package:pocketguide/news.dart';
import 'package:pocketguide/tabs/explore.dart';
import 'package:pocketguide/helper/helper.dart';
import 'package:pocketguide/api/myfile.dart';
import 'package:pocketguide/helper/colors.dart';
import 'package:pocketguide/screens/final.dart';
import 'package:pocketguide/screens/scanner.dart';
import 'package:pocketguide/screens/searchBar.dart';
import 'package:pocketguide/tabs/bookmark.dart';
import 'package:toast/toast.dart';
import 'package:pocketguide/screens/databse.dart';

import '../api/model.dart';
import 'chatroom.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controll = Get.put(GetXControllers());

  getDAta() async {
    return await Database().loadData();
  }

  getFirebaseMesgToken() async {
    FirebaseMessaging fmessaging = FirebaseMessaging.instance;

    NotificationSettings settings = await fmessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    final fireref = await FirebaseFirestore.instance
        .collection("allUser")
        .doc(FirebaseAuth.instance.currentUser!.uid);

    await fmessaging.getToken().then((value) {
      if (value != null) {
        print("tokken :$value");
        fireref.update({"pushtoken": value});
      }
    });
  }

  var username;
  @override
  void initState() {
    super.initState();
    username = FirebaseAuth.instance.currentUser!.displayName;

    getFirebaseMesgToken();
  }

  @override
  void dispose() {
    _controll.dispose();
    super.dispose();
  }

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
              child: IconButton(
                  onPressed: () async {
                    await AuthService().signOut();
                    await Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  icon: Icon(
                    Icons.logout,
                    color: myyellow,
                  )),
            ),
          ],
        ),
        actions: [
          FutureBuilder(
              future: getDAta(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.done) {
                  return InkWell(
                      onTap: () async {
                        var list = await Helper(snap.data).getTitle();
                        // print("home 39 Searchicon $list\n");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SearchMe(dataList: list, data: snap.data)));
                      },
                      child: Image.asset(
                        "assets/image/search.png",
                        height: 50,
                        width: 50,
                      ));
                } else {
                  return Container();
                }
              }),
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.white.withOpacity(0.05)),
            height: h * 0.08,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    height: 75,
                    width: w / 4.1,
                    child: Center(
                      child: Icon(
                        Icons.home,
                        color: myyellow,
                      ),
                    ),
                  ),
                ),
                FutureBuilder(
                    future: getDAta(),
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.done) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Explore(data: snap.data)));
                          },
                          child: Container(
                              height: 75,
                              width: w / 4.3,
                              child: Center(
                                  child:
                                      Image.asset("assets/image/Compass.png"))),
                        );
                      } else {
                        return Container();
                      }
                    }),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => NewsPage()));
                  },
                  child: Container(
                    height: 75,
                    width: w / 4.3,
                    child: Center(
                      child: Icon(
                        Icons.newspaper,
                        color: myyellow,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => BookMark()));
                  },
                  child: Container(
                      height: 75,
                      width: w / 4.3,
                      child: Center(
                          child: Image.asset("assets/image/Bookmark.png"))),
                )
              ],
            )),
      ),
      body: SafeArea(
        child: Container(
          height: h,
          width: w,
          child: Column(
            children: [
              SizedBox(
                height: 2,
              ),
              Text(
                "Hello, $username ",
                style: TextStyle(color: mywhite),
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
                  child: FutureBuilder(
                    future: getDAta(),
                    builder: (context, AsyncSnapshot snap) {
                      if (snap.connectionState == ConnectionState.done) {
                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            final usableData = snap.data!["res"].keys;
                            // print("--$usableData");
                            final modelData = Model.fromJson(
                                snap.data!["res"][usableData.toList()[index]]);

                            // print("--------${modelData.image}");
                            var booking = false;

                            var isBookmarked =
                                checkIfBookMarked(modelData.title);
                            return Padding(
                              padding: const EdgeInsets.only(left: 22.0),
                              child: Container(
                                height: h * 0.6,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      child: InkWell(
                                        onTap: () async {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FinalPage(
                                                        isCameraImage: false,
                                                        image: modelData.image,
                                                        location:
                                                            modelData.city,
                                                        description: modelData
                                                            .description,
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
                                            height: h * 0.6,
                                            width: w * 0.82,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 15,
                                      left: 20,
                                      child: FutureBuilder(
                                        future:
                                            checkIfBookMarked(modelData.title),
                                        builder: (context,
                                            AsyncSnapshot<bool> snapshot) {
                                          return snapshot.data != null
                                              ? snapshot.data!
                                                  ? IconButton(
                                                      onPressed: () async {
                                                        await BookMarkFunctions()
                                                            .removeFromBookMark(
                                                                modelData
                                                                    .title);

                                                        setState(() {});
                                                      },
                                                      icon: Icon(
                                                        Icons.bookmark,
                                                        color: myyellow,
                                                      ))
                                                  : IconButton(
                                                      onPressed: () async {
                                                        await BookMarkFunctions()
                                                            .addMyBookMark(
                                                                modelData.title)
                                                            .then((value) =>
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            "Added"));

                                                        setState(() {});
                                                      },
                                                      icon: Icon(
                                                          Icons
                                                              .bookmark_border_outlined,
                                                          color: myyellow))
                                              : SizedBox();
                                        },
                                      ),
                                    ),
                                    Positioned(
                                      top: 40,
                                      left: 20,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                              ),
                            );
                          },
                        );
                      } else {
                        return Container();
                      }
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
                  height: h * 0.07,
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
                        left: 15,
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
                      ),
                      Positioned(
                        right: 15,
                        top: 0,
                        child: InkWell(
                          onTap: () async {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => ChatRoom()));
                          },
                          child: Row(
                            children: [
                              Text(
                                "Need a Guide ? ",
                                style: TextStyle(
                                    color: mywhite,
                                    fontSize: 16,
                                    fontFamily: "Inter"),
                              ),
                              Image.asset(
                                "assets/image/guider.png",
                                height: 45,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> checkIfBookMarked(String title) async {
  final user = FirebaseAuth.instance.currentUser!;
  final firestore = await FirebaseFirestore.instance
      .collection("allUser")
      .doc(user.uid)
      .collection("Bookmarks")
      .get();

  for (var element in firestore.docs) {
    if (element.id.toString().trim() == title.trim()) {
      return true;
    }
  }
  return false;
}
