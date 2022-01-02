import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_first_app/data/api/buyer_api.dart';
import 'package:my_first_app/data/models/food.dart';

import 'package:my_first_app/providers/AuthProvider.dart';
import 'package:my_first_app/data/api/seller_api.dart';

class FoodProvider extends ChangeNotifier {
  late SellerApiService apiService;
  late AuthProvider authProvider;
  late BuyerApiService apiBuyerService;

  FoodProvider(AuthProvider authProvider) {
    this.authProvider = authProvider;
    this.apiService = SellerApiService(authProvider.token);
    this.apiBuyerService = BuyerApiService(authProvider.token);

    
  }

  
   Future<Food> getFood(String userID) async {
    String token = await authProvider.getToken();

    String text = await apiService.fetchFood(userID, token);
    final jsonResponse = json.decode(text);

    return new Food.fromJson(jsonResponse);
  }
  Future<Food> getFoodForBuyer(String shopId) async {
    String token = await authProvider.getToken();
    String text = await apiBuyerService.getShopByIdFood(shopId);
    final jsonResponse = json.decode(text);

    return new Food.fromJson(jsonResponse);
  }

  Future<void> addFood(String name, int price ,String image, String id, String token) async {
    await apiService.addFood(name, price, image , id, token);

    notifyListeners();
  }

  Future<void> deleteFood(String idFood ,Future<String> idShop  , Future<String> token ) async{

    await apiService.deleteFood(idFood, await idShop, await token);

    notifyListeners();
  }
  
  Future<void> updateFood(String name ,String idFood ,  int price ,String image , Future<String> idShop  , Future<String> token ) async{

    await apiService.updateFood(name , price ,idFood , image , await idShop, await token);

    notifyListeners();
  }
}