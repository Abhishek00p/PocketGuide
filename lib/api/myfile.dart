import 'dart:convert';

Map<String, Model> modelFromJson(String str) => Map.from(json.decode(str))
    .map((k, v) => MapEntry<String, Model>(k, Model.fromJson(v)));

String modelToJson(Map<String, Model> data) => json.encode(
    Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class Model {
  Model({
    required this.address,
    required this.bestTime,
    required this.city,
    required this.description,
    required this.feedback,
    required this.title,
    required this.image,
  });

  String address;
  String bestTime;
  String city;
  String description;
  String feedback;
  String title;
  String image;

  factory Model.fromJson(Map<String, dynamic> json) => Model(
        address: json["Address"],
        bestTime: json["Best_time"],
        city: json["City"],
        description: json["Description"],
        feedback: json["Feedback"],
        title: json["Title"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "Address": address,
        "Best_time": bestTime,
        "City": city,
        "Description": description,
        "Feedback": feedback,
        "Title": title,
        "image": image,
      };
}
