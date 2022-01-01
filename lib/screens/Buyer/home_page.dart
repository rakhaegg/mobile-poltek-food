import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_first_app/data/models/shop.dart';
import 'package:my_first_app/providers/DrinkProvider.dart';
import 'package:my_first_app/providers/FoodProvider.dart';
import 'package:my_first_app/providers/ShopProvider.dart';
import 'package:provider/provider.dart';

import 'food_page.dart';

class HomeBuyerPage extends StatefulWidget {
  const HomeBuyerPage({Key? key}) : super(key: key);

  @override
  _HomeBuyerPage createState() => _HomeBuyerPage();
}

class _HomeBuyerPage extends State<HomeBuyerPage> {

  @override
  Widget build(BuildContext context) {
    //final provider = Provider.of<ShopProvider>(context);
    //final drinkProv = Provider.of<DrinkProvider>(context);
    final shopProv = Provider.of<ShopProvider>(context);

    // List<Toko> toko = provider.toko;
    // List<Drink> drink = drinkProv.toko;
    // List<Food> food = foodProv.toko;

    Future<Shop> fetchShop() async {
      Future<Shop> shop = shopProv.getAllShop();

      return shop;
    }


    return new Scaffold(
        appBar: AppBar(title: Text("Buyer")),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              FutureBuilder(
                  future: fetchShop(),
                  builder:
                      (BuildContext context, AsyncSnapshot<Shop> snapshot) {
                    if (snapshot.data != null) {
                        return ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.data.user.length,
                        itemBuilder: (context, index) {
                          return  ListTile(
                            leading: Image.memory(base64Decode(snapshot
                                .data?.data.user[index].image as String)),
                            title: Text(
                                snapshot.data?.data.user[index].name as String),
                            subtitle: Text(snapshot
                                .data?.data.user[index].noPhone as String),

                            onTap: () {
                               Navigator.pushNamed(context, '/detailPageShop' , arguments: {
                                 "idShop" : snapshot
                                     .data?.data.user[index].id as String
                               });

                            },


                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
                      return new Text(snapshot.error.toString());
                    }
                    return new CircularProgressIndicator();
                  }),
            ],
          ),
        ));
  }
}
