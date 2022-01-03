import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:my_first_app/data/api/buyer_api.dart';
import 'package:my_first_app/data/api/driver_api.dart';
import 'package:my_first_app/data/api/seller_api.dart';
import 'package:my_first_app/data/models/drink.dart';
import 'package:my_first_app/data/models/food.dart';
import 'package:my_first_app/data/models/pesanForBuyer.dart';
import 'package:my_first_app/data/models/shop.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider untuk pemesanan
import 'AuthProvider.dart';

class PesanProvider extends ChangeNotifier {
  final List<FoodElement> food = [];
  final List<DrinkElement> drink = [];

  late BuyerApiService apiBuyerService;
  late AuthProvider authProvider;
  late SellerApiService apiSellerService;
  late DriverApiService apiDriverService;

  late final String typeShopIdD;

  PesanProvider(AuthProvider authProvider) {
    this.authProvider = authProvider;
    this.apiBuyerService = BuyerApiService(authProvider.token);
    this.apiSellerService = SellerApiService(authProvider.token);
    this.apiDriverService = DriverApiService(authProvider.token);
  }
  List<Map<String, dynamic>> getFoodForPesan() {
    return food.map((e) => {
      "id" : e.id,
      "name" :e.name,
      "price" : e.price,
    }).toList();
  }
  List<Map<String, dynamic>> getDrinkForPesan() {
    return drink.map((e) => {
      "id" : e.id,
      "name" :e.name,
      "price" : e.price,

    }).toList();
  }
  Future<void> addPesanToServer(Future<String> buyer_id , Future<String> shop_id ,
      String daftar , int total , String daftar_drink , Future<String> namaToko,
      String alamat_buyer , Future<String> alamat_toko
      ) async {
    await apiBuyerService.addPesanToServer(await buyer_id, await shop_id,
        daftar, total , daftar_drink , await namaToko , alamat_buyer ,await  alamat_toko);
  }
  Future<void> updateData(Future<String> id_driver , String id_order) async {
    await apiDriverService.updateOrdersDriver(await id_driver , id_order);
  }
  Future<PesanForBuyer> fetchRiwayatPesan(String buyerID) async{
    String text =  await apiBuyerService.getRiwayatBuyer(buyerID);
    final jsonResponse = json.decode(text);
    print(jsonResponse);
    return new PesanForBuyer.fromJson(jsonResponse);
  }

  Future<Shop> getShopName(String shopID) async{
    String text =  await apiBuyerService.getShopIDForRiwayatPesan(shopID);
    final jsonResponse = json.decode(text);

    return new Shop.fromJson(jsonResponse);
  }
  Future<PesanForBuyer> fetchDaftarPsan(String buyerID) async{
    String text =  await apiSellerService.getDafterPesan(buyerID);
    final jsonResponse = json.decode(text);

    return new PesanForBuyer.fromJson(jsonResponse);
  }
  Future<PesanForBuyer> fetOrderForDriver() async{
    String text =  await apiDriverService.getOrder();
    final jsonResponse = json.decode(text);

    return new PesanForBuyer.fromJson(jsonResponse);
  }
  Future<PesanForBuyer> acceptFormDriver() async{
    String text =  await apiDriverService.getOrder();
    final jsonResponse = json.decode(text);

    return new PesanForBuyer.fromJson(jsonResponse);
  }
  Future<void> updateDataSeller(String id , String text) async{
    await apiSellerService.updateMessage(id , text);


  }
  Future<void> updateDataBuyer(String id , String text) async{
    await apiBuyerService.updateData(id , text);


  }

  int getLengthFood(FoodElement item) {
    int count = 0;
    for (int i = 0; i < food.length; i++) {
      if (food[i].id == item.id) {
        count++;
      }
    }
    return count;
  }
  int getLengethDrink(DrinkElement item) {
    int count = 0;
    for (int i = 0; i < drink.length; i++) {
      if (drink[i].id == item.id) {
        count++;
      }
    }
    return count;
  }


  int total() {
    int total = 0;

    for (var i = 0; i < food.length; i++) {
      total = total + food[i].price;
    }
    for (var i = 0 ; i < drink.length ; i++){
      total = total + drink[i].price;
    }



    return total;
  }
  Future<void> setType(String idShop) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('idShopForBuyer', idShop);

  }
  Future<String> getShopID() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('idShopForBuyer') ?? '';
  }
  void addFood(FoodElement item , String idShop)  {

    getShopID().then((value)  {
      if (value == ''){
        setType(idShop);
        food.add(item);
      }else if(value == idShop){
        food.add(item);

      }else if(value != idShop){
        removeAll();
        setType(idShop);
        food.add(item);
      }
    });


    notifyListeners();
  }

  void addDrink(DrinkElement item , String idShop) {
    getShopID().then((value)  {
      if (value == ''){
        setType(idShop);
        drink.add(item);
      }else if(value == idShop){
        drink.add(item);

      }else if(value != idShop){
        removeAll();
        setType(idShop);
        drink.add(item);
      }
    });
    notifyListeners();
  }

  void removeFood(FoodElement item) {
    int index = -1;
    for (int i = 0 ; i < food.length ; i++){
          if(food[i].id == item.id){
            index = i ;
            break;
          }
    }
    if (index > -1){
      food.removeAt(index);
      print(this.food.remove(item));
      print("TOTAL FOOD : " + food.length.toString());
    }


    notifyListeners();
  }

  void removeDrink(DrinkElement item) {
    int index = -1;
    for (int i = 0 ; i < drink.length ; i++){
      if(drink[i].id == item.id){
        index = i ;
        break;
      }
    }
    if (index > -1){
      drink.removeAt(index);
      print("TOTAL DRINK : " + drink.length.toString());
    }
    notifyListeners();
  }

  void removeAll() {
    food.clear();
    drink.clear();
    notifyListeners();
  }
  Future<void> logOut() async {

    setType('');

    notifyListeners();
  }

}
