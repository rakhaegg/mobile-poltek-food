import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_first_app/data/models/drink.dart';
import 'package:my_first_app/data/models/food.dart';
import 'package:my_first_app/providers/DrinkProvider.dart';
import 'package:my_first_app/providers/FoodProvider.dart';
import 'package:provider/provider.dart';

class DetailPageShop extends StatefulWidget {
  final String shopId;
  const DetailPageShop({Key? key, required this.shopId}) : super(key: key);

  @override
  _DetailPageShopState createState() => _DetailPageShopState();
}

class _DetailPageShopState extends State<DetailPageShop> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final foodProv = Provider.of<FoodProvider>(context);
    final drinkProv = Provider.of<DrinkProvider>(context);
    Future<Drink> fetchDrink() async {
      Drink drink = await drinkProv.getDrinkForBuyer(widget.shopId);
      return drink;
    }

    Future<Food> fetchFood() async {
      Food food = await foodProv.getFoodForBuyer(widget.shopId);
      return food;
    }

    return Scaffold(
        appBar: AppBar(title: Text("Pesan")),
        body: SingleChildScrollView(
            child: Column(children: [
          FutureBuilder(
              future: fetchFood(),
              builder: (BuildContext context, AsyncSnapshot<Food> snapshot) {
                if (snapshot.data != null) {
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data?.data.food.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Image.memory(base64Decode(
                              snapshot.data?.data.food[index].image as String)),
                          title: Text(
                              snapshot.data?.data.food[index].name as String),
                          subtitle: Text(snapshot.data?.data.food[index].price
                              .toString() as String),
                        );
                      });
                } else if (snapshot.hasError) {}
                return new CircularProgressIndicator();
              }),
          FutureBuilder(
              future: fetchDrink(),
              builder: (BuildContext context, AsyncSnapshot<Drink> snapshot) {
                if (snapshot.data != null) {
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data?.data.drink.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Image.memory(base64Decode(snapshot
                              .data?.data.drink[index].image as String)),
                          title: Text(
                              snapshot.data?.data.drink[index].name as String),
                          subtitle: Text(snapshot.data?.data.drink[index].price
                              .toString() as String),
                        );
                      });
                } else if (snapshot.hasError) {}
                print(snapshot.toString());
                return new CircularProgressIndicator();
              }),
        ])));
  }
}
