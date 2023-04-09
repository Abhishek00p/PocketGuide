import 'dart:convert';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pocketguide/helper/colors.dart';

import 'notification.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final pagController = PageController();

  NotifiServices _notifiServices = NotifiServices();

  Future getNews() async {
    var response;
    await http
        .get(Uri.parse(dotenv.env["SITE"]!))
        .then((value) => response = value);

    // Parse the response JSON
    final data = json.decode(response.body);
    print("result from newsapi : ${await data["articles"].runtimeType}");

    // Send a notification for each article
    // for (var article in data['articles']) {
    //   article["description"] != null
    //       ? NotifiServices()
    //           .sendnotification(article['title'], article["description"])
    //       : null;
    // }
    return await data["articles"];
  }

  @override
  void initState() {
    NotifiServices().initializeNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: mybackground,
      appBar: AppBar(
        backgroundColor: mybackground,
      ),
      body: SafeArea(
          child: Container(
        height: h,
        width: w,
        child: FutureBuilder(
            future: getNews(),
            builder: (context, AsyncSnapshot snap) {
              if (snap.connectionState == ConnectionState.done &&
                  snap.hasData) {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: snap.data!.length,
                    itemBuilder: (context, index) {
                      print(snap.data.runtimeType);
                      return Padding(
                        padding:
                            EdgeInsets.only(bottom: 10, left: 10, right: 10),
                        child: GestureDetector(
                          onTap: () async {
                            launchUrl(
                                Uri.parse(
                                  snap.data![index]["url"],
                                ),
                                mode: LaunchMode.inAppWebView);
                          },
                          child: Container(
                            height: h * 0.1,
                            width: w * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white60,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: h * 0.06,
                                    width: w * 0.15,
                                    child: snap.data![index]["urlToImage"] !=
                                            null
                                        ? Image.network(
                                            snap.data![index]["urlToImage"]!)
                                        : SizedBox(),
                                  ),
                                ),
                                Container(
                                  width: w * 0.6,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                            snap.data![index]["title"]! != null
                                                ? snap.data![index]["title"]!
                                                : "",
                                            style: TextStyle(
                                                fontSize: snap.data![index]
                                                                ["title"]
                                                            .toString()
                                                            .length >
                                                        90
                                                    ? 10
                                                    : 14,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            snap.data![index]["description"] !=
                                                    null
                                                ? snap.data![index]
                                                    ["description"]!
                                                : "",
                                            overflow: TextOverflow.fade,
                                            softWrap: true,
                                            style: TextStyle(
                                                fontSize: snap.data![index]
                                                                ["description"]
                                                            .toString()
                                                            .length >
                                                        120
                                                    ? 10
                                                    : 12)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              } else if (snap.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                return SizedBox();
              }
            }),
      )),
    );
  }
}
