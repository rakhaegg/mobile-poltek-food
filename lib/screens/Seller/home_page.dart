import 'dart:async';
import 'dart:io' as Io;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_first_app/data/models/drink.dart';
import 'package:my_first_app/data/models/food.dart';
import 'package:my_first_app/data/models/shop.dart';
import 'package:my_first_app/providers/AuthProvider.dart';
import 'package:my_first_app/providers/DrinkProvider.dart';
import 'package:my_first_app/providers/FoodProvider.dart';
import 'package:my_first_app/providers/ShopProvider.dart';
import 'package:my_first_app/screens/Seller/RegisterShop.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:typed_data';

Image imageFromBase64String(String base64String) {
  return Image.memory(base64Decode(base64String));
}

Uint8List dataFromBase64String(String base64String) {
  return base64Decode(base64String);
}

String base64String(Uint8List data) {
  return base64Encode(data);
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(
          title: Text("Penjual"),
        ),
        body: NewWidget()
    );
  }
}

class NewWidget extends StatefulWidget {
  const NewWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<NewWidget> createState() => _NewWidgetState();
}

class _NewWidgetState extends State<NewWidget> {
  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);


    Future<Shop> fetchShop() async {
      Future<Shop> shop = shopProvider.getShop(await shopProvider.getShopID());
      return shop;
    }
    return FutureBuilder(
        future: fetchShop(),
        builder: (BuildContext context, AsyncSnapshot<Shop> snapshot) {
          if (snapshot.data != null) {
            return ListView.builder(
                shrinkWrap: true,

                itemCount: snapshot.data!.data.user.length,
                itemBuilder: (BuildContext context, index) {
                  return Container(
                    child: Column(
                      children: [
                        Image.memory(base64Decode(
                            snapshot.data?.data.user[index].image as String)),
                        Text(snapshot.data?.data.user[index].name as String),
                        Text(snapshot.data?.data.user[index].noPhone as String),
                        FoodPage(token: authProvider.getToken()),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Drink"),
                        DrinkPage(token: authProvider.getToken())
                      ],
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            return new Text(snapshot.error.toString());
          }
          return new CircularProgressIndicator();
        });
  }
}

class FoodPage extends StatefulWidget {
  final Future<String> token;
  const FoodPage({Key? key, required this.token}) : super(key: key);

  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  final TextEditingController nameEditingController = TextEditingController();
  final TextEditingController priceEditingController = TextEditingController();
  late  String name = "";
  late  int price = 0;
  Io.File? image;

  @override
  void dispose() {
    super.dispose();
    nameEditingController.dispose();
    priceEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final foodProver = Provider.of<FoodProvider>(context);
    final shopID = Provider.of<ShopProvider>(context);
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    Future<Food> fethFood() async {
      Future<Food> food = foodProver.getFood( await shopID.getShopID());
      return food;
    }
    return FutureBuilder(
        future: fethFood(),
        builder: (BuildContext context, AsyncSnapshot<Food> snapshot) {
          if (snapshot.data != null) {
            return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.data.food.length,
                itemBuilder: (BuildContext context, index) {
                  return ListTile(
                    leading: Image.memory(base64Decode(
                        snapshot.data?.data.food[index].image as String)),
                    title: Text(snapshot.data?.data.food[index].name as String),
                    subtitle: Text(snapshot.data?.data.food[index].price
                        .toString() as String),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                            onPressed: () {
                              foodProver.deleteFood(
                                  snapshot.data?.data.food[index].id as String,
                                  shopID.getShopID(),
                                  widget.token);
                            },
                            icon: Icon(Icons.delete)),
                        IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                    builder: (context,setState) {

                                      Future pickImage() async {
                                        try {
                                          final image = await ImagePicker()
                                              .pickImage(
                                              source: ImageSource.gallery);


                                          if (image == null) return;

                                          final imageTemporary = Io.File(
                                              image.path);
                                          setState(() {
                                            this.image = imageTemporary;
                                          });
                                        } on PlatformException catch (e) {
                                          print('Failed to pick Image $e');
                                        }
                                      }


                                      return AlertDialog(
                                        content: Form(
                                          key: _formKey,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[

                                              TextFormField(
                                                initialValue: snapshot.data
                                                    ?.data
                                                    .food[index].name as String,
                                                keyboardType: TextInputType
                                                    .text,
                                                validator: (value) {
                                                  return value!.isNotEmpty
                                                      ? null
                                                      : "Isi Nama Makanan";
                                                },
                                                onChanged: (s) {
                                                  setState(() {
                                                    this.name = s;
                                                    print(name);
                                                  });

                                                },
                                                decoration: InputDecoration(
                                                    hintText: "Nama Makanan "),
                                              ),
                                              TextFormField(
                                                initialValue: snapshot.data
                                                    ?.data
                                                    .food[index].price
                                                    .toString(),
                                                keyboardType:
                                                TextInputType.number,
                                                validator: (value) {
                                                  return value!.isNotEmpty
                                                      ? null
                                                      : "Isi Harga Makanan";
                                                },
                                                onChanged: (s) {

                                                  setState(() {
                                                    this.price = int.parse(s);
                                                    print(price);
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                    hintText: "Nama Minuman"),
                                              ),
                                              SizedBox(height: 20),
                                              Row(
                                                children: <Widget>[
                                                  image != null ? Image.file(
                                                    this.image!,
                                                    width: 125,
                                                    height: 150,
                                                    fit: BoxFit.cover,
                                                  ) : Image.memory(base64Decode(
                                                      snapshot.data?.data
                                                          .food[index]
                                                          .image as String),

                                                    width: 125,
                                                    height: 150,),
                                                  SizedBox(width: 20),

                                                  ElevatedButton(
                                                      onPressed: () =>
                                                          pickImage(),
                                                      child: Text(
                                                          "Pick a Gallery")
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        title: Text("Update Data"),
                                        actions: <Widget>[
                                          InkWell(
                                            child: Text("OK "),
                                            onTap: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                String img64 = "";
                                                Uint8List? imageBytes = this
                                                    .image?.readAsBytesSync();
                                                if (image == null) {
                                                  Uint8List? imageBytes = this
                                                      .image?.readAsBytesSync();
                                                  img64 =
                                                  snapshot.data?.data
                                                      .food[index]
                                                      .image as String;
                                                } else {
                                                  img64 = base64Encode(
                                                      imageBytes!);
                                                }
                                                 if(this.name == ""){
                                                   name = snapshot.data?.data
                                                       .food[index]
                                                       .name as String;
                                                 }
                                                if(this.price == 0){
                                                  price = snapshot.data?.data
                                                      .food[index]
                                                      .price as int ;
                                                }

                                                    foodProver.updateFood(
                                                        name,
                                                         snapshot.data?.data
                                                             .food[index]
                                                             .id as String,
                                                         price,
                                                         img64,
                                                        shopID.getShopID(),
                                                         widget.token);

                                              }
                                            },
                                          )
                                        ],
                                      );
                                    });
                                  });
                            },
                            icon: Icon(Icons.update)),
                      ],
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            return new Text(
                snapshot.error.toString().replaceAll("Exception: ", " "));
          }
          return new CircularProgressIndicator();
        });
  }


}

class DrinkPage extends StatefulWidget {
  final Future<String> token;
  const DrinkPage({Key? key, required this.token}) : super(key: key);

  @override
  _DrinkPageState createState() => _DrinkPageState();
}

class _DrinkPageState extends State<DrinkPage> {
  final TextEditingController nameEditingController = TextEditingController();
  final TextEditingController priceEditingController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    nameEditingController.dispose();
    priceEditingController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final drinkProvider = Provider.of<DrinkProvider>(context);
    final shopID = Provider.of<ShopProvider>(context);
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


    Future<Drink> fetchDrink() async {
      Future<Drink> drink = drinkProvider.getDrink( await shopID.getShopID());
      return drink;
    }
  /* Test */
    return FutureBuilder(
        future: fetchDrink(),
        builder: (BuildContext context, AsyncSnapshot<Drink> snapshot) {
          if (snapshot.data != null) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.data.drink.length,
                itemBuilder: (BuildContext context, index) {
                  return ListTile(
                    leading: Image.memory(base64Decode(snapshot.data?.data.drink[index].image as String)),
                    title:
                        Text(snapshot.data?.data.drink[index].name as String),
                    subtitle: Text(snapshot.data?.data.drink[index].price
                        .toString() as String),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                            onPressed: () {
                              drinkProvider.deleteDrink(
                                  snapshot.data?.data.drink[index].id as String,
                                  shopID.getShopID(),
                                  widget.token);
                            },
                            icon: Icon(Icons.delete)),
                        IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Form(
                                        key: _formKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            TextFormField(
                                              controller: nameEditingController,
                                              keyboardType: TextInputType.text,
                                              validator: (value) {
                                                return value!.isNotEmpty
                                                    ? null
                                                    : "Isi Nama Minuman";
                                              },
                                              decoration: InputDecoration(
                                                  hintText: "Nama Minuman "),
                                            ),
                                            TextFormField(
                                              controller:
                                                  priceEditingController,
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: (value) {
                                                return value!.isNotEmpty
                                                    ? null
                                                    : "Isi Harga Minuman";
                                              },
                                              decoration: InputDecoration(
                                                  hintText: "Nama Minuman"),
                                            ),
                                          ],
                                        ),
                                      ),
                                      title: Text("Update Data"),
                                      actions: <Widget>[
                                        InkWell(
                                          child: Text("OK "),
                                          onTap: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              drinkProvider.updateDrink(
                                                  nameEditingController.text,
                                                  snapshot
                                                      .data
                                                      ?.data
                                                      .drink[index]
                                                      .id as String,
                                                  int.parse(
                                                      priceEditingController
                                                          .text),
                                                  shopID.getShopID(),
                                                  widget.token);
                                            }
                                          },
                                        )
                                      ],
                                    );
                                  });
                            },
                            icon: Icon(Icons.update)),
                      ],
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            return new Text(
                snapshot.error.toString().replaceAll("Exception: ", " "));
          }
          return new CircularProgressIndicator();
        });
  }
}

/*
  Test Case
  1. Jika Toko belum mempunyai Makanan maka menampilkan pesan
  2. Jika Toko belum mempunyai Minuman maka menampilkan pesan

  Test Case Update Data
  1. Jika Salah satu field atau keduanya kosong maka keluar pesan
  2.


 */
