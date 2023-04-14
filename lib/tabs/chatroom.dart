import 'package:flutter/material.dart';
import 'package:pocketguide/helper/colors.dart';

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

  final GuideList = {
    "Mumbai": ["RAhul", "Nimesh", "Pratap", "komal"],
    "Nashik": ["r", "n", "p", "k"],
    "Pune": ["Pratap", "komal", "RAhul", "Nimesh"],
    "Nagpur": ["komal", "RAhul", "Nimesh", "Pratap"],
  };

  var _dropvalue = "Mumbai";

  bool isChats = false;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
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
                              child: ListView.builder(
                                  itemCount: GuideList[_dropvalue]!.length,
                                  itemBuilder: (_, ind) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 15),
                                      child: InkWell(
                                        onTap: () {},
                                        child: Container(
                                          height: h * 0.1,
                                          width: w * 0.8,
                                          decoration: BoxDecoration(
                                              border:
                                                  Border.all(color: mywhite),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.white
                                                  .withOpacity(0.4)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                height: h * 0.8,
                                                width: w * 0.2,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Image.asset(
                                                    "assets/image/dummyGuide.jfif",
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                GuideList[_dropvalue]![ind],
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
                                  }),
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
                                child: ListView.builder(
                                    itemCount: GuideList[_dropvalue]!.length,
                                    itemBuilder: (_, ind) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 15),
                                        child: InkWell(
                                          onTap: () {},
                                          child: Container(
                                            height: h * 0.09,
                                            width: w * 0.8,
                                            decoration: BoxDecoration(
                                                border:
                                                    Border.all(color: mywhite),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors.white
                                                    .withOpacity(0.4)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  height: h * 0.07,
                                                  width: w * 0.15,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: Image.asset(
                                                      "assets/image/dummyUser.png",
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  GuideList[_dropvalue]![ind],
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
                                    }),
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



//  Padding(
//               padding: const EdgeInsets.all(15.0),
//               child: Container(
//                 height: h * 0.08,
//                 // color: Colors.red,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Container(
//                       height: h * 0.06,
//                       width: w / 2.3,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20),
//                           color: myyellow),
//                       child: Center(
//                         child: Text(
//                           "Find your Guide",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       height: h * 0.06,
//                       width: w / 2.3,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20),
//                           color: myyellow),
//                       child: Center(
//                         child: Text(
//                           "Chats",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             )
