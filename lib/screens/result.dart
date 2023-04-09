import 'package:flutter/material.dart';
import 'package:pocketguide/helper/colors.dart';
import 'package:translator/translator.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'language.dart';

class ResultScreen extends StatefulWidget {
  final String text;
  final String language;

  const ResultScreen({super.key, required this.text, required this.language});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String dropValue = "en";
  List<DropdownMenuItem<String>> dropdownItems = [];
  bool isButtonClicked = false;
  final googletranslate = GoogleTranslator();

  String translatedTExt = "";

  createItems() {
    for (var elem in countriesLang) {
      dropdownItems.add(
        DropdownMenuItem(
          value: elem["code"],
          child: Text(elem["name"].toString()),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    createItems();
  }

  String transTExt = "";

  translate() async {
    await googletranslate
        .translate(widget.text, to: dropValue, from: widget.language)
        .then((value) {
      print("converted text : ${value.text}");
      transTExt = value.text;
      setState(() {
        waiting = false;
      });
    });
  }

  bool waiting = false;
  final tts = FlutterTts();

  speackTheText(String text, String langCode) async {
    setState(() {
      waiting = true;
    });
    await tts.setLanguage(langCode);
    await tts.setVolume(0.5);
    await tts.setSpeechRate(0.5);
    await tts.setPitch(1);
    await tts.speak(text);
    setState(() {
      waiting = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    tts.stop();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    print("detected lang : ${widget.language}");
    return Scaffold(
      backgroundColor: mybackground,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: h,
          width: w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  GestureDetector(
                    child: Icon(
                      Icons.arrow_back,
                      color: myyellow,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: h * 0.2,
                width: w * 0.75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Card(
                  color: Color.fromRGBO(54, 54, 54, 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Text(
                        widget.text,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Poppins"),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(54, 54, 54, 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<String>(
                        value: dropValue,
                        dropdownColor: Colors.grey,
                        focusColor: Colors.black,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        items: dropdownItems,
                        onChanged: (val) {
                          setState(() {
                            dropValue = val!;
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromRGBO(52, 52, 52, 1)),
                    child: Center(
                      child: InkWell(
                        onTap: () async {
                          setState(() {
                            waiting = true;
                          });
                          await translate();
                        },
                        child: Text(
                          "Translate now",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                height: 200,
                width: w * 0.65,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromRGBO(54, 54, 54, 1)),
                child: SingleChildScrollView(
                  child: Center(
                    child: Text(
                      transTExt,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  await speackTheText(transTExt, dropValue);
                },
                child: Container(
                  height: 50,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white)),
                  child: Center(
                    child: Text(
                      "Speak now",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
              waiting ? LinearProgressIndicator() : SizedBox()
            ],
          ),
        ),
      )),
    );
  }
}
