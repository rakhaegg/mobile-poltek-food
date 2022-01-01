import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_first_app/data/api/buyer_api.dart';
import 'package:my_first_app/data/models/drink.dart';

import 'package:my_first_app/providers/AuthProvider.dart';
import 'package:my_first_app/data/api/seller_api.dart';

class DrinkProvider extends ChangeNotifier {

  late SellerApiService apiService;
  late AuthProvider authProvider;
  late BuyerApiService apiBuyerService;

  DrinkProvider(AuthProvider authProvider) {
    this.authProvider = authProvider;
    this.apiService = SellerApiService(authProvider.token);
    this.apiBuyerService = BuyerApiService(authProvider.token);

  }

  Future<Drink> getDrink(String userID) async {
    String token = await authProvider.getToken();

    String text = await apiService.fetchDrink(userID, token);
    final jsonResponse = json.decode(text);
    return new Drink.fromJson(jsonResponse);
  }

  Future<Drink> getDrinkForBuyer(String shopId) async {

    String text = await apiBuyerService.getShopByIdDrink(shopId);
    final jsonResponse = json.decode(text);

    return new Drink.fromJson(jsonResponse);
  }

  Future<void> addDrink(String name, int price, String image ,String id, String token) async {
    await apiService.addDrink(name, price,image , id, token);

    notifyListeners();
  }

  Future<void> deleteDrink(String idDrink ,Future<String> idShop  , Future<String> token ) async{

    await apiService.deleteDrink(idDrink, await idShop, await token);

    notifyListeners();
  }
Future<void> updateDrink(String name ,String idDrink ,  int price , Future<String> idShop  , Future<String> token ) async{

    await apiService.updateDrink(name , price ,idDrink , await idShop, await token);

    notifyListeners();
  }
}