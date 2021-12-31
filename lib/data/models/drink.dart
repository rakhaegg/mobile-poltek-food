// To parse this JSON data, do
//
//     final drink = drinkFromJson(jsonString);

import 'dart:convert';

Drink drinkFromJson(String str) => Drink.fromJson(json.decode(str));

String drinkToJson(Drink data) => json.encode(data.toJson());

class Drink {
    Drink({
        required this.status,
        required this.data,
    });

    String status;
    Data data;

    factory Drink.fromJson(Map<String, dynamic> json) => Drink(
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
        required this.drink,
    });

    List<DrinkElement> drink;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        drink: List<DrinkElement>.from(json["drink"].map((x) => DrinkElement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "drink": List<dynamic>.from(drink.map((x) => x.toJson())),
    };
}

class DrinkElement {
    DrinkElement({
        required  this.id,
        required this.name,
        required  this.price,
        required this.image,
    });

    String id;
    String name;
    int price;
    String image;

    factory DrinkElement.fromJson(Map<String, dynamic> json) => DrinkElement(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "image": image,
    };
}
