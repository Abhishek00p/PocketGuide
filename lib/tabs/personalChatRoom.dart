import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pocketguide/helper/colors.dart';

class ChatMessagesScreen extends StatefulWidget {
  final String senderId;
  final String receiverId;
  final String chatroomId;

  ChatMessagesScreen(
      {required this.senderId,
      required this.receiverId,
      required this.chatroomId});

  @override
  State<ChatMessagesScreen> createState() => _ChatMessagesScreenState();
}

class _ChatMessagesScreenState extends State<ChatMessagesScreen> {
  TextEditingController _mesgcontrooller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getuserInfo();
  }

  String Title = "";

  getuserInfo() async {
    final userREf = FirebaseFirestore.instance
        .collection("allUser")
        .where("uid", isEqualTo: widget.receiverId);
    final userrefdata = await userREf.get().then((value) => value.docs.first);
    final userData = await userrefdata.data();
    setState(() {
      Title = userData["name"];
    });
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    CollectionReference messagesRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatroomId)
        .collection("messages");

    Query query = messagesRef;

    return Scaffold(
      backgroundColor: mybackground,
      appBar: AppBar(
        backgroundColor: mybackground,
        title: Text(
          Title,
          style: TextStyle(fontSize: 18, fontFamily: "Poppins"),
        ),
      ),
      body: Container(
        height: h - kToolbarHeight,
        width: w,
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    query.orderBy('timestamp', descending: true).snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: Text('Loading...'));
                  }

                  return ListView(
                    reverse: true,
                    shrinkWrap: true,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      return ListTile(
                        title: Text(data['content']),
                        subtitle: Text(data['timestamp'].toString()),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Container(
                height: h * 0.08,
                width: w - 24,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: mywhite)),
                child: TextFormField(
                  controller: _mesgcontrooller,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () async {
                            await sendmyMessage(
                                mesg: _mesgcontrooller.text,
                                reciverID: widget.receiverId,
                                senderIdd: widget.senderId,
                                chatroom: widget.chatroomId);
                          },
                          icon: Icon(
                            Icons.send,
                            color: mywhite,
                          ))),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

sendmyMessage(
    {required String mesg,
    required String senderIdd,
    required reciverID,
    required String chatroom}) async {
  final myref = FirebaseFirestore.instance.collection("chats").doc(chatroom);

  await myref.set({"senderid": senderIdd, "reciverId": reciverID});

  final data = {
    "content": mesg,
    "senderId": senderIdd,
    "recieverId": reciverID,
    "timestamp": DateTime.now()
  };
  await myref.collection("messages").doc().set(data);
}
