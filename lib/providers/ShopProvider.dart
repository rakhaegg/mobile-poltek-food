


import 'package:flutter/foundation.dart';
import 'package:my_first_app/data/api/buyer_api.dart';
import 'package:my_first_app/data/api/seller_api.dart';
import 'package:my_first_app/data/models/shop.dart';
import 'package:my_first_app/providers/AuthProvider.dart';
import 'dart:convert';

// Provider untuk pembelian
import 'package:shared_preferences/shared_preferences.dart';

class ShopProvider extends ChangeNotifier{
  bool isExists = false;
  
  late SellerApiService apiService;
  late BuyerApiService apiBuyerService;
  late AuthProvider authProvider;
  String idShop = "";


  ShopProvider(AuthProvider authProvider){
    this.authProvider = authProvider;
    this.apiService = SellerApiService(authProvider.token);
    this.apiBuyerService = BuyerApiService(authProvider.token);
    init();
  }

  bool getIsExists(){
    return this.isExists;
  }

  Future<void> init() async {

    notifyListeners();
  }
  

  Future<void> register (String nameShop , String addressShop , String noShop , String image) async {

    print(await authProvider.getToken());
    final getToken = await authProvider.getToken();
    Map response  = json.decode(await apiService.registerShop(nameShop, addressShop, noShop , image ,  getToken)) as Map;
    setShopID(response["data"]["shopId"]);

    notifyListeners();
  }

    

  Future<Shop> getShop(String userID)async{
    setShopID(await authProvider.getShopID());
    String token = await authProvider.getToken(); 

    String text = await apiService.getShop(await getShopID(), token);
    final jsonResponse = json.decode(text);
    return new Shop.fromJson(jsonResponse);


  }
  Future<Shop> getAllShop()async{

    //print(await authProvider.getShopID());
    //setShopID(await authProvider.getShopID());
    this.apiBuyerService = BuyerApiService(authProvider.token);
    String token = await authProvider.getToken();

    return new Shop.fromJson(json.decode(await apiBuyerService.getShop( token)));


  }
  Future<void> setShopID(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('shop', token);
  }
    Future<String> getShopID() async{
     final prefs = await SharedPreferences.getInstance();
    return prefs.getString('shop') ?? '';
  }
  Future<void> logOut() async {
    setShopID('');

    this.isExists = false;
    notifyListeners();
  }
  
}