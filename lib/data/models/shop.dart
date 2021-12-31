// To parse this JSON data, do
//
//     final shop = shopFromJson(jsonString);

import 'dart:convert';

Shop shopFromJson(String str) => Shop.fromJson(json.decode(str));

String shopToJson(Shop data) => json.encode(data.toJson());

class Shop {
    Shop({
        required this.status,
        required this.data,
    });

    String status;
    Data data;

    factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        status: json["status"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
    };
}

class Data {
    Data({
        required this.user,
    });

    List<User> user;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: List<User>.from(json["user"].map((x) => User.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "user": List<dynamic>.from(user.map((x) => x.toJson())),
    };
}

class User {
    User({
       required  this.id,
      required   this.name,
       required this.noPhone,

        required this.image
    });

    String id;
    String name;
    String noPhone;

    String image;

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        noPhone: json["no_phone"],

        image: json["image"]
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "no_phone": noPhone,

        "image" :image
    };
}
