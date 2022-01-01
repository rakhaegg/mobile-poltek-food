

import 'package:flutter/cupertino.dart';
import 'package:my_first_app/data/api/buyer_api.dart';
import 'package:my_first_app/data/models/drink.dart';
import 'package:my_first_app/data/models/food.dart';

import 'AuthProvider.dart';

class PesanProvider extends ChangeNotifier{
  final List<Food> food = [];
  final List<Drink> drink = [];

  late BuyerApiService apiBuyerService;
  late AuthProvider authProvider;

  PesanProvider(AuthProvider authProvider) {
    this.authProvider = authProvider;
    this.apiBuyerService = BuyerApiService(authProvider.token);
  }

}

