import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocketguide/api/Ai.dart';
import 'package:pocketguide/helper/colors.dart';
import 'package:pocketguide/screens/final.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:translator/translator.dart';
import 'result.dart';

class Scanner extends StatefulWidget {
  final List<CameraDescription>? cameras;
  Scanner({this.cameras});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  late CameraController controller;
  final _pick = ImagePicker();
  XFile? imgFile;
  bool imgCaptured = false;

  final textrec = TextRecognizer();

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.cameras!.first, ResolutionPreset.high);
    controller.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    textrec.close();
  }

  getText() async {
    final inputimage = InputImage.fromFilePath(imgFile!.path);
    RecognizedText recognizedText = await textrec.processImage(inputimage);
    final lang = recognizedText.blocks.first.recognizedLanguages;
    var scannedtext = recognizedText.text;
    GoogleTranslator _googletrans = GoogleTranslator();
    final res = await _googletrans.translate(scannedtext);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResultScreen(
                text: scannedtext, language: res.sourceLanguage.code)));
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return !controller.value.isInitialized
        ? Container(child: Center(child: CircularProgressIndicator()))
        : Scaffold(
            backgroundColor: Color.fromRGBO(27, 50, 50, 1),
            body: SafeArea(
              child: Container(
                height: h,
                width: w,
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: mywhite,
                              size: 35,
                            )),
                        SizedBox(
                          width: 70,
                        ),
                        Text(
                          "Pocket Guide",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(214, 162, 102, 1),
                              fontSize: 20,
                              fontFamily: "Poppins"),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Divider(
                      indent: 40,
                      thickness: 2.5,
                      color: myyellow,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Card(
                      elevation: 2,
                      child: Container(
                        height: h * 0.6,
                        width: w * 0.8,
                        child: !imgCaptured
                            ? CameraPreview(controller)
                            : Image.file(File(imgFile!.path)),
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Divider(
                      endIndent: 34,
                      thickness: 2.5,
                      color: myyellow,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.upload_file,
                            size: 32,
                            color: mywhite,
                          ),
                          onPressed: () async {
                            imgFile = await _pick.pickImage(
                                source: ImageSource.gallery);
                          },
                        ),
                        InkWell(
                          onTap: () async {
                            imgFile = await _pick.pickImage(
                                source: ImageSource.camera);
                            if (imgFile != null) {
                              setState(() {
                                imgCaptured = true;
                              });
                            }
                          },
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              backgroundColor: mybackground,
                              radius: 22,
                              child: CircleAvatar(
                                backgroundColor: myyellow,
                                radius: 19,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () async {
                              getText();
                            },
                            icon: Icon(
                              Icons.arrow_forward,
                              color: mywhite,
                              size: 32,
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
