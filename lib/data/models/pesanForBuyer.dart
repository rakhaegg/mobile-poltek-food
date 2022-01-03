// Model untuk buyer memesan
// To parse this JSON data, do
//
//     final pesanForBuyer = pesanForBuyerFromJson(jsonString);

import 'dart:convert';

PesanForBuyer pesanForBuyerFromJson(String str) => PesanForBuyer.fromJson(json.decode(str));

String pesanForBuyerToJson(PesanForBuyer data) => json.encode(data.toJson());

class PesanForBuyer {
  PesanForBuyer({
    required this.status,
    required this.data,
  });

  String status;
  Data data;

  factory PesanForBuyer.fromJson(Map<String, dynamic> json) => PesanForBuyer(
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
    required this.id,
    required this.buyerId,
    required this.shopId,
    required  this.driverId,
    required this.namaToko,
    required this.statusShop,
    required  this.statusBuyer,
    required this.alamatBuyer,
    required this.alamatToko,
    required  this.daftar,
    required this.daftarDrink,
  });

  String id;
  String buyerId;
  String shopId;
  String driverId;
  String namaToko;
  String statusShop;
  String statusBuyer;
  String alamatBuyer;
  String alamatToko;
  String daftar;
  String daftarDrink;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    buyerId: json["buyer_id"],
    shopId: json["shop_id"],
    driverId: json["driver_id"],
    namaToko: json["nama_toko"],
    statusShop: json["status_shop"],
    statusBuyer: json["status_buyer"],
    alamatBuyer: json["alamat_buyer"],
    alamatToko: json["alamat_toko"],
    daftar: json["daftar"],
    daftarDrink: json["daftar_drink"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "buyer_id": buyerId,
    "shop_id": shopId,
    "driver_id": driverId,
    "nama_toko": namaToko,
    "status_shop": statusShop,
    "status_buyer": statusBuyer,
    "alamat_buyer": alamatBuyer,
    "alamat_toko": alamatToko,
    "daftar": daftar,
    "daftar_drink": daftarDrink,
  };
}
