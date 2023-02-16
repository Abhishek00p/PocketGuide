import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:firebase_storage/firebase_storage.dart';

// https://github.com/apoorva2810/Google-Lens-Clone.git

// Try above app

class CameraAI extends StatefulWidget {
  const CameraAI({super.key});

  @override
  State<CameraAI> createState() => _CameraAIState();
}

class _CameraAIState extends State<CameraAI> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
    );
  }
}

class AIScanner {
  final url = "POST https://vision.googleapis.com/v1/images:annotate";

  getData(Uri imgUrl) async {
    final bod = {
      "requests": [
        {
          "image": {
            "source": {"imageUri": "$imgUrl"}
          },
          "features": [
            {"type": "LOGO_DETECTION", "maxResults": 1}
          ]
        }
      ]
    };
    try {
      final resp = await http.post(Uri.parse(url), body: bod);
      print(resp.body);
    } catch (e) {
      print(e.toString());
    }
  }

  Future uploadFile(XFile? _file) async {
    final _ref = FirebaseStorage.instance
        .ref("cameraImage")
        .child("camera/${_file!.path}");
    final uploadTask = _ref.putFile(File(_file.path));
    await uploadTask.whenComplete(() => print("completed"));
    _ref.getDownloadURL().then((value) {
      getData(Uri.parse(value));
      print(value);
    });
    // StorageReference storageReference = FirebaseStorage.instance
    //     .ref()
    //     .child('chats/${Path.basename(_image.path)}}');
    // StorageUploadTask uploadTask = storageReference.putFile(_image);
    // await uploadTask.onComplete;
    // print('File Uploaded');
    // storageReference.getDownloadURL().then((fileURL) {
    //   setState(() {
    //     _uploadedFileURL = fileURL;
    //   });
    // });
  }
}
