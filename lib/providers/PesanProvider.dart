import 'package:flutter/cupertino.dart';
import 'package:my_first_app/data/api/buyer_api.dart';
import 'package:my_first_app/data/models/drink.dart';
import 'package:my_first_app/data/models/food.dart';

import 'AuthProvider.dart';

class PesanProvider extends ChangeNotifier {
  final List<FoodElement> food = [];
  final List<DrinkElement> drink = [];

  late BuyerApiService apiBuyerService;
  late AuthProvider authProvider;

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

  void addFood(FoodElement item) {

      food.add(item);

    notifyListeners();
  }

  void addDrink(DrinkElement item) {
    drink.add(item);
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
