import 'package:flutter/material.dart';
import 'package:my_first_app/data/api/buyer_api.dart';
import 'package:my_first_app/data/api/driver_api.dart';
import 'package:my_first_app/data/api/seller_api.dart';
import 'package:my_first_app/data/models/buyer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'ShopProvider.dart';

// Provider untuk autentikasi 
class AuthProvider extends ChangeNotifier {

  bool isAuthenticated = false;
  late String token;
  late SellerApiService apiSellerService;
  late DriverApiService apiDriverService;
  late BuyerApiService apiBuyerService;
  late String userID;
  late String type;
  late bool isExists ;

  AuthProvider() {
    isExists = true;
    init();
  }

  Future<void> init() async {
    this.token = await getToken();
    if (this.token.isNotEmpty) {
      this.isAuthenticated = true;
    }

    this.apiSellerService = new SellerApiService(this.token);
    this.apiDriverService = new DriverApiService(this.token);
    this.apiBuyerService = new BuyerApiService(this.token);

    this.type = await getType();
    this.userID = await getUserID();

    print("INIT ");
    notifyListeners();
  }

  Future<void> register(String username,  String password, String fullname , String type) async {
    if(type == "Driver"){
      Map userID = json.decode( await apiDriverService.register(username , password , fullname)) as Map;

      setUserID(userID["data"]["userId"]);
      notifyListeners();
    }else if(type =="Seller"){
      Map userID = json.decode( await apiSellerService.register(username , password , fullname)) as Map;

      setUserID(userID["data"]["userId"]);
      notifyListeners();
    }else if(type == "Buyer"){
      Map userID = json.decode( await apiBuyerService.register(username , password , fullname)) as Map;
      setUserID(userID["data"]["userId"]);
      notifyListeners();

    }
    this.isAuthenticated = false;
    notifyListeners();
  }

  Future<void> login(String email, String password, String deviceName , String type) async {

    if(type == "Driver"){
      Map userID = json.decode( await apiDriverService.login(email , password , deviceName)) as Map;
      setUserID(userID["data"]["id"]);
      setToken(userID["data"]["accessToken"]);
      setType("Driver");
      this.type = "Driver";
      notifyListeners();
    }else if(type =="Seller"){
      Map userID = json.decode( await apiSellerService.login(email , password , deviceName)) as Map;
      setUserID(userID["data"]["id"]);
      setToken(userID["data"]["accessToken"]);
      setType("Seller");
      this.type = "Seller";
      print("iser " + await getUserID());
      print("tokne" + await getToken());
      Map checkShop = json.decode(await apiSellerService.check( await getToken()));
      if ( checkShop["status"] == "fail"){
          print("Belum Dibuat");
          this.isExists =false;
      }

      notifyListeners();
    }else if(type == "Buyer"){

      final  Map userID = json.decode( await apiBuyerService.login(email , password , deviceName)) as Map;
      setUserID(userID["data"]["id"]);
      setToken(userID["data"]["accessToken"]);
      setType("Buyer");
      this.type = "Buyer";


    }
    this.isAuthenticated = true;
    notifyListeners();
  }
  Future<String> getShopID() async{
    Map checkShop = json.decode(await apiSellerService.check( await getToken()));

    return checkShop["data"]["shopId"][0]["id"];
  }

  Future<void> logOut() async {
    setToken('');
    setUserID('');
    setType('');
    this.isAuthenticated = false;
    this.type = "";
    this.isExists = true;
    notifyListeners();
  }

  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }
  Future<void> setType(String type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('type', type);
  }
  Future<void> setUserID(String id) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', id);

  }

  Future<String> getUserID() async{
     final prefs = await SharedPreferences.getInstance();
    return prefs.getString('id') ?? '';
  }
  Future<String> getType() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('type') ?? '';
  }


  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  Future<Buyer> getName(String id) async {
    print(id);
    String buyer = await apiSellerService.getName(id);
    final jsonResponse = json.decode(buyer);

    return Buyer.fromJson(jsonResponse);

  }
}