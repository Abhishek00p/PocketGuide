import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pocketguide/helper/colors.dart';
import 'package:pocketguide/tabs/personalChatRoom.dart';
import 'guide.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  getallChatsOfUser() async {
    final userid = FirebaseAuth.instance.currentUser!.uid;
    final messagesRef = FirebaseFirestore.instance.collection('chats');
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
        await messagesRef.get().then((value) => value.docs);

    List chatrooms = [];
    for (var doc in docs) {
      List users = doc.id.split('_');
      users.contains(userid) ? chatrooms.add(doc.id) : null;
    }
    return chatrooms;
  }

  getallGuides({String? dropvalue}) async {
    if (dropvalue == "Mumbai") {
      return await FirebaseFirestore.instance
          .collection("guides")
          .where("place", isEqualTo: "Mumbai")
          .get();
    }
    if (dropvalue == "Nashik") {
      return await FirebaseFirestore.instance
          .collection("guides")
          .where("place", isEqualTo: "Nashik")
          .get();
    }
    if (dropvalue == "Pune") {
      return await FirebaseFirestore.instance
          .collection("guides")
          .where("place", isEqualTo: "Pune")
          .get();
    }
    if (dropvalue == "Nagpur") {
      return await FirebaseFirestore.instance
          .collection("guides")
          .where("place", isEqualTo: "Nagpur")
          .get();
    }

    return await FirebaseFirestore.instance.collection("guides").get();
  }

  var _dropvalue = "Mumbai";

  bool isChats = false;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    getallChatsOfUser();
    return Scaffold(
      backgroundColor: mybackground,
      appBar: AppBar(
        backgroundColor: mybackground,
        title: Center(
          child: Text(
            "ChatRoom",
            style: TextStyle(color: myyellow),
          ),
        ),
      ),
      body: SafeArea(
          child: Container(
              height: h,
              width: w,
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: h * 0.08,
                    width: w * 0.8,
                    child: TabBar(
                        isScrollable: false,
                        indicatorColor: Colors.transparent,
                        controller: _tabController,
                        tabs: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                isChats = false;
                                _tabController.index = 0;
                              });
                            },
                            child: Container(
                              height: h * 0.06,
                              width: w * 0.3,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: myyellow),
                                  color: !isChats
                                      ? myyellow
                                      : myyellow.withOpacity(0.1)),
                              child: Center(
                                  child: Text(
                                "Find Guide",
                                style: TextStyle(color: Colors.white),
                              )),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                isChats = true;
                                _tabController.index = 1;
                              });
                            },
                            child: Container(
                              height: h * 0.06,
                              width: w * 0.3,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: myyellow),
                                  color: isChats
                                      ? myyellow
                                      : myyellow.withOpacity(0.1)),
                              child: Center(
                                  child: Text(
                                "Chats",
                                style: TextStyle(color: Colors.white),
                              )),
                            ),
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(context,
                  //         MaterialPageRoute(builder: (_) => Creategude()));
                  //   },
                  //   child: Container(
                  //     height: 50,
                  //     width: 120,
                  //     child: Center(
                  //       child: Text("aDd guide"),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  Expanded(
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: [
                        Column(
                          children: [
                            Container(
                              height: h * 0.06,
                              width: w * 0.7,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: mywhite)),
                              child: Center(
                                child: DropdownButton(
                                    dropdownColor: mybackground,
                                    style: TextStyle(
                                      color: Colors
                                          .white, // Set the desired color here
                                    ),
                                    underline: SizedBox(),
                                    value: _dropvalue,
                                    alignment: Alignment.center,
                                    onChanged: (value) {
                                      _dropvalue = value!;
                                      setState(() {});
                                    },
                                    items: [
                                      DropdownMenuItem(
                                          value: "Mumbai",
                                          child: Center(
                                            child: Text(
                                              "Mumbai",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                          )),
                                      DropdownMenuItem(
                                          value: "Nagpur",
                                          child: Center(
                                            child: Text(
                                              "Nagpur",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                          )),
                                      DropdownMenuItem(
                                          value: "Pune",
                                          child: Center(
                                            child: Text(
                                              "Pune",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                          )),
                                      DropdownMenuItem(
                                          value: "Nashik",
                                          child: Center(
                                            child: Text(
                                              "Nashik",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                          )),
                                    ]),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Expanded(
                              child: FutureBuilder(
                                future: getallGuides(dropvalue: _dropvalue),
                                builder: (context, AsyncSnapshot snap) {
                                  if (snap.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (snap.hasError || !snap.hasData) {
                                    return Center(
                                      child: Text("Something missing"),
                                    );
                                  }

                                  print(
                                      "Data from drop : ${snap.data.docs.first.data()}");

                                  return ListView.builder(
                                      itemCount: snap.data.docs.length,
                                      itemBuilder: (_, ind) {
                                        final docData =
                                            snap.data.docs[ind].data();

                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 15),
                                          child: InkWell(
                                            onTap: () {
                                              final senderID = FirebaseAuth
                                                  .instance.currentUser!.uid;
                                              final recId = docData["uid"];
                                              final mylist = [senderID, recId];
                                              mylist.sort();
                                              final chatroomID =
                                                  mylist[0] + "_" + mylist[1];
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChatMessagesScreen(
                                                            chatroomId:
                                                                chatroomID,
                                                            senderId: senderID,
                                                            receiverId: recId,
                                                          )));
                                            },
                                            child: Container(
                                              height: h * 0.1,
                                              width: w * 0.8,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: mywhite),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Colors.white
                                                      .withOpacity(0.4)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    height: h * 0.8,
                                                    width: w * 0.2,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child: Image.asset(
                                                        "assets/image/dummyGuide.jfif",
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    docData["name"],
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: mybackground),
                                                  ),
                                                  SizedBox()
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                },
                              ),
                            )
                          ],
                        ),

                        //chats
                        Container(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Expanded(
                                child: FutureBuilder(
                                  future: getallChatsOfUser(),
                                  builder: (context, AsyncSnapshot snap) {
                                    if (snap.hasError || !snap.hasData) {
                                      return Center(
                                        child: Text("Something missing"),
                                      );
                                    }
                                    if (snap.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    print(
                                        "Data from chat : ${snap.data.runtimeType}");

                                    final List chatrooms = snap.data;

                                    return ListView.builder(
                                        itemCount: chatrooms.length,
                                        itemBuilder: (_, ind) {
                                          final senderID = FirebaseAuth
                                              .instance.currentUser!.uid;
                                          final alluser =
                                              chatrooms[ind].split('_');

                                          final recId = alluser[0] == senderID
                                              ? alluser[1]
                                              : alluser[0];

                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 15),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ChatMessagesScreen(
                                                              chatroomId:
                                                                  chatrooms[
                                                                      ind],
                                                              senderId:
                                                                  senderID,
                                                              receiverId: recId,
                                                            )));
                                              },
                                              child: Container(
                                                height: h * 0.09,
                                                width: w * 0.8,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: mywhite),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    color: Colors.white
                                                        .withOpacity(0.4)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Container(
                                                      height: h * 0.07,
                                                      width: w * 0.15,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        child: Image.asset(
                                                          "assets/image/dummyUser.png",
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                    ),
                                                    FutureBuilder(
                                                      future: getName(recId),
                                                      builder: (_, snapshot) {
                                                        return Text(
                                                          snapshot.data
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  mybackground),
                                                        );
                                                      },
                                                    ),
                                                    SizedBox()
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ))),
    );
  }
}

Future<String> getName(rid) async {
  final userREf = FirebaseFirestore.instance
      .collection("allUser")
      .where("uid", isEqualTo: rid);
  final userrefdata = await userREf.get().then((value) => value.docs.first);
  final userData = await userrefdata.data();

  String nam = userData["name"];
  return nam;
}
