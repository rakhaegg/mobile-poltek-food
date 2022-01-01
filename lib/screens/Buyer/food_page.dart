import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_first_app/data/models/drink.dart';
import 'package:my_first_app/data/models/food.dart';
import 'package:my_first_app/providers/DrinkProvider.dart';
import 'package:my_first_app/providers/FoodProvider.dart';
import 'package:provider/provider.dart';

class DetailPageShop extends StatefulWidget {

  const DetailPageShop({Key? key}) : super(key: key);

  @override
  _DetailPageShopState createState() => _DetailPageShopState();
}

class _DetailPageShopState extends State<DetailPageShop> {


  @override
  Widget build(BuildContext context) {
     final  drinkProv = Provider.of<DrinkProvider>(context );
     final  foodProv  =       Provider.of<FoodProvider>(context);

     final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    Future<Food> fetchFood() async {
      Food food = await foodProv.getFoodForBuyer(arguments["idShop"]);
      return food;
    }


    Future<Drink> fetchDrink() async {
      Drink drink = await drinkProv.getDrinkForBuyer(arguments["idShop"]);
      return drink;
    }

    return Scaffold(
        appBar: AppBar(
            title: Text("Pesan")),
        body: SingleChildScrollView(
            child: Column(children: [

              FutureBuilder<Food>(
                  future: fetchFood(),
                  builder: (context, AsyncSnapshot<Food> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Text('Loading....');
                      case ConnectionState.done :
                        if (snapshot.data?.data.food.length != 0) {
                          return ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: snapshot.data?.data.food.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: Image.memory(base64Decode(
                                      snapshot.data?.data.food[index]
                                          .image as String)),
                                  title: Text(snapshot.data?.data.food[index]
                                      .name as String),
                                  subtitle: Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text("Harga Makanan : "),
                                          Text(snapshot.data?.data.food[index]
                                              .price.toString() as String),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {},
                                            icon: const Icon(Icons.add),
                                          ),
                                          SizedBox(width: 5),

                                          Text(
                                              "0"
                                          ),
                                          SizedBox(width: 5),
                                          IconButton(
                                            onPressed: () {},
                                            icon: const Icon(Icons.remove),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              });
                        } else if (snapshot.hasError) {
                          print(snapshot.toString());
                        } else if (snapshot.data?.data.food.length == 0) {
                          return Container(
                              child: Text("Toko Belum Memiliki Menu")
                          );
                        }
                        return CircularProgressIndicator();

                      default:
                        if (snapshot.hasError)
                          return Text('Error: ${snapshot.error}');
                        else
                          return Text('Result: ${snapshot.data}');
                    }
                  }
        ),

                  FutureBuilder<Drink>(
                      future: fetchDrink(),
                      builder: (BuildContext context, AsyncSnapshot<Drink> snapshot) {
                        switch(snapshot.connectionState) {
                          case ConnectionState.waiting :
                            return CircularProgressIndicator();
                          case ConnectionState.done :
                            if (snapshot.data != null) {
                              print("ad");
                              return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data?.data.drink.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      leading: Image.memory(base64Decode(snapshot
                                          .data?.data.drink[index].image as String)),
                                      title: Text(
                                          snapshot.data?.data.drink[index].name as String),
                                      subtitle: Column(
                                        children: <Widget>[
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Text("Harga Minuman : "),
                                              Text(snapshot.data?.data.drink[index].price
                                                  .toString() as String),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {},
                                                icon: const Icon(Icons.add),
                                              ),
                                              SizedBox(width: 5),

                                              Text(
                                                  "0"
                                              ),
                                              SizedBox(width: 5),
                                              IconButton(
                                                onPressed: () {},
                                                icon: const Icon(Icons.remove),
                                              ),
                                            ],
                                          )
                                        ],
                                      )


                                    );
                                  });
                            } else if (snapshot.hasError) {
                              print(snapshot.toString());
                            } else if (snapshot.data?.data.drink.length == 0) {
                              return Container(
                                  child: Text("Toko Belum Memiliki Menu")
                              );
                            }
                            return CircularProgressIndicator();

                          default:
                            if (snapshot.hasError)
                              return Text('Error: ${snapshot.error}');
                            else
                              return Text('Result: ${snapshot.data}');
                        }



                      }),




            ]  )

            ));

  }
  }

