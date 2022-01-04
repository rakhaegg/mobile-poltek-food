// To parse this JSON data, do
//
//     final pesanForBuyer = pesanForBuyerFromJson(jsonString);

import 'dart:convert';

PesanForBuyer pesanForBuyerFromJson(String str) => PesanForBuyer.fromJson(json.decode(str));

String pesanForBuyerToJson(PesanForBuyer data) => json.encode(data.toJson());

class PesanForBuyer {
  PesanForBuyer({
    required this.status,
    required   this.data,
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
    required  this.user,
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
    required  this.buyerId,
    required this.shopId,
    required  this.driverId,
    required this.statusShop,
    required this.statusDriver,
    required  this.statusBuyer,
    required  this.daftar,
    required  this.total,
    required this.namaToko,
    required this.alamatBuyer,
    required this.alamatToko,
  });

  String id;
  String buyerId;
  String shopId;
  String driverId;
  String statusShop;
  String statusDriver;
  String statusBuyer;
  String daftar;
  int total;
  String namaToko;
  String alamatBuyer;
  String alamatToko;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    buyerId: json["buyer_id"],
    shopId: json["shop_id"],
    driverId: json["driver_id"],
    statusShop: json["status_shop"],
    statusDriver: json["status_driver"],
    statusBuyer: json["status_buyer"],
    daftar: json["daftar"],
    total: json["total"],
    namaToko: json["nama_toko"],
    alamatBuyer: json["alamat_buyer"],
    alamatToko: json["alamat_toko"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "buyer_id": buyerId,
    "shop_id": shopId,
    "driver_id": driverId,
    "status_shop": statusShop,
    "status_driver": statusDriver,
    "status_buyer": statusBuyer,
    "daftar": daftar,
    "total": total,
    "nama_toko": namaToko,
    "alamat_buyer": alamatBuyer,
    "alamat_toko": alamatToko,
  };
}
