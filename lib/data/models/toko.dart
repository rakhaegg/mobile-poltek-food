// model untuk toko
// To parse this JSON data, do
//
//     final toko = tokoFromMap(jsonString);

import 'dart:convert';

List<Toko> tokoFromMap(String str) =>
    List<Toko>.from(json.decode(str).map((x) => Toko.fromMap(x)));

String tokoToMap(List<Toko> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Toko {
  Toko({
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  String restaurantId;
  String name;
  String description;
  String pictureId;
  String city;
  double rating;

  factory Toko.fromMap(Map<String, dynamic> json) => Toko(
        restaurantId: json["restaurant_id"],
        name: json["name"],
        description: json["description "],
        pictureId: json["pictureId"],
        city: json["city"],
        rating: json["rating"],
      );

  Map<String, dynamic> toMap() => {
        "restaurant_id": restaurantId,
        "name": name,
        "description ": description,
        "pictureId": pictureId,
        "city": city,
        "rating": rating,
      };
}
