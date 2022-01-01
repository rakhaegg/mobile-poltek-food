import 'package:flutter/cupertino.dart';
import 'package:my_first_app/data/api/buyer_api.dart';
import 'package:my_first_app/data/models/drink.dart';
import 'package:my_first_app/data/models/food.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AuthProvider.dart';

class PesanProvider extends ChangeNotifier {
  final List<FoodElement> food = [];
  final List<DrinkElement> drink = [];

  late BuyerApiService apiBuyerService;
  late AuthProvider authProvider;

  late final String typeShopIdD;

  PesanProvider(AuthProvider authProvider) {
    this.authProvider = authProvider;
    this.apiBuyerService = BuyerApiService(authProvider.token);
  }
  List<FoodElement> getFood() {
    return food;
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

  double totalFood() {
    double total = 0;
    /*
    for (var i = 0; i < food.length; i++) {
      total = total + double.parse(food[i].harga );
    }

     */
    return total;
  }

  double total() {
    double total = 0;
    /*
    for (var i = 0; i < drink.length; i++) {
      total = total + double.parse(drink[i].harga);
    }
    total = total + totalFood();

     */
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
}
