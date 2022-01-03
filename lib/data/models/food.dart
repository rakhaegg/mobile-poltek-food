// Model untuk makanan
// To parse this JSON data, do
//
//     final food = foodFromJson(jsonString);

import 'dart:convert';

Food foodFromJson(String str) => Food.fromJson(json.decode(str));

String foodToJson(Food data) => json.encode(data.toJson());

class Food {
    Food({
        required this.status,
        required this.data,
    });

    String status;
    Data data;

    factory Food.fromJson(Map<String, dynamic> json) => Food(
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
        required this.food,
    });

    List<FoodElement> food;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        food: List<FoodElement>.from(json["food"].map((x) => FoodElement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "food": List<dynamic>.from(food.map((x) => x.toJson())),
    };
}

class FoodElement {
    FoodElement({
        required this.id,
        required  this.name,
        required this.price,
        required this.image,
    });

    String id;
    String name;
    int price;
    String image;

    factory FoodElement.fromJson(Map<String, dynamic> json) => FoodElement(
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
