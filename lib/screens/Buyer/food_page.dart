import 'package:flutter/material.dart';
import 'package:my_first_app/models/drink.dart';
import 'package:my_first_app/models/food.dart';
import 'package:my_first_app/models/toko.dart';
import 'package:my_first_app/providers/DrinkProvider.dart';
import 'package:my_first_app/providers/FoodProvider.dart';
import 'package:my_first_app/providers/PesanProvider.dart';
import 'package:my_first_app/providers/TokoProvider.dart';
import 'package:my_first_app/services/api.dart';
import 'package:provider/provider.dart';

class FoodPage extends StatefulWidget {
  final String id;
  final List<Food> food;
  final List<Drink> drinks;

  const FoodPage(
      {Key? key, required this.id, required this.food, required this.drinks})
      : super(key: key);

  @override
  _FoodState createState() => _FoodState();
}

class _FoodState extends State<FoodPage> {
  List<Food> food = [];
  List<Drink> drinks = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var i = 0; i < widget.food.length; i++) {
      if (widget.food[i].idRestaurant == widget.id) {
        food.add(widget.food[i]);
      }
    }
    for (var i = 0; i < widget.drinks.length; i++) {
      if (widget.drinks[i].idRestaurant == widget.id) {
        drinks.add(widget.drinks[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Pesan")),
        body: SingleChildScrollView(
            child: Column(children: [
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: food.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListView(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(10.0),
                          children: [
                            CustomerListItem(
                              idRestaurant: food[index].idRestaurant,
                              title: food[index].name,
                              description: food[index].description,
                              harga: food[index].harga,
                              thumbnail: Container(
                                  child: Image.network(food[index].picture)),
                              food: food[index],
                            )
                          ],
                        ),
                      ],
                    );
                  }),
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: drinks.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListView(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(10.0),
                          children: [
                            CustomerListItemDrink(
                              idRestaurant: drinks[index].idRestaurant,
                              title: drinks[index].name,
                              description: drinks[index].description,
                              harga: drinks[index].harga,
                              thumbnail: Container(
                                  child: Image.network(drinks[index].picture)),
                              drink: drinks[index],
                            )
                          ],
                        ),
                      ],
                    );
                  }),
            ])));
  }
}

class _FoodDescp extends StatefulWidget {
  final String title;
  final String description;
  final String harga;
  final Widget pesan;

  const _FoodDescp(
      {Key? key,
        required this.title,
        required this.description,
        required this.harga,
        required this.pesan})
      : super(key: key);

  @override
  __FoodDescpState createState() => __FoodDescpState();
}

class __FoodDescpState extends State<_FoodDescp> {
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Padding(padding: EdgeInsets.only(bottom: 2.0)),
                Text(widget.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                    const TextStyle(fontSize: 12.0, color: Colors.black54)),
              ],
            ),
          ),
          Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        widget.harga,
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.black87,
                        ),
                      ),
                      widget.pesan
                    ]),
              ))
        ]);
  }
}

class CustomerListItem extends StatefulWidget {
  const CustomerListItem(
      {Key? key,
        required this.description,
        required this.thumbnail,
        required this.harga,
        required this.title,
        required this.food,
        required this.idRestaurant})
      : super(key: key);
  final Food food;
  final Widget thumbnail;
  final String title;
  final String description;
  final String harga;
  final String idRestaurant;
  @override
  _CustomerListItemState createState() => _CustomerListItemState();
}

class _CustomerListItemState extends State<CustomerListItem> {
  List yangDiPesan = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: SizedBox(
            height: 100,
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: <
                Widget>[
              AspectRatio(
                aspectRatio: 1.0,
                child: widget.thumbnail,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                  child: _FoodDescp(
                      title: widget.title,
                      description: widget.description,
                      harga: widget.harga,
                      pesan: Row(children: [
                        ElevatedButton(
                            onPressed: () {
                              Provider.of<PesanProvider>(context, listen: false)
                                  .addFood(widget.food);
                              setState(() {
                                yangDiPesan.add(widget.food);
                              });
                            },
                            child: Icon(Icons.add)),
                        Text(Provider.of<PesanProvider>(context)
                            .getLengthFood(
                            widget.idRestaurant, widget.food.name)
                            .toString()
                          // Provider.of<PesanProvider>(context)
                          //   .getLengthFood(widget.idRestaurant ,).toString()
                          //   ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Provider.of<PesanProvider>(context, listen: false)
                                  .removeFood(widget.food);

                              setState(() {
                                yangDiPesan.remove(widget.food);
                              });
                            },
                            child: Icon(Icons.remove))
                      ])),
                ),
              ),
            ])));
  }
}

class CustomerListItemDrink extends StatefulWidget {
  const CustomerListItemDrink(
      {Key? key,
        required this.description,
        required this.thumbnail,
        required this.harga,
        required this.title,
        required this.drink,
        required this.idRestaurant})
      : super(key: key);
  final Drink drink;
  final Widget thumbnail;
  final String title;
  final String description;
  final String harga;
  final String idRestaurant;
  @override
  _CustomerListItemDrinkState createState() => _CustomerListItemDrinkState();
}

class _CustomerListItemDrinkState extends State<CustomerListItemDrink> {
  List yangDiPesan = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: SizedBox(
            height: 100,
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: <
                Widget>[
              AspectRatio(
                aspectRatio: 1.0,
                child: widget.thumbnail,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                  child: _FoodDescp(
                      title: widget.title,
                      description: widget.description,
                      harga: widget.harga,
                      pesan: Row(children: [
                        ElevatedButton(
                            onPressed: () {
                              Provider.of<PesanProvider>(context, listen: false)
                                  .addDrink(widget.drink);
                              setState(() {
                                yangDiPesan.add(widget.drink);
                              });
                            },
                            child: Icon(Icons.add)),
                        Text(Provider.of<PesanProvider>(context)
                            .getLengethDrink(
                            widget.idRestaurant, widget.drink.name)
                            .toString()
                          // Provider.of<PesanProvider>(context)
                          //   .getLengthFood(widget.idRestaurant ,).toString()
                          //   ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Provider.of<PesanProvider>(context, listen: false)
                                  .removeDrink(widget.drink);

                              setState(() {
                                yangDiPesan.remove(widget.drink);
                              });
                            },
                            child: Icon(Icons.remove))
                      ])),
                ),
              ),
            ])));
  }
}
