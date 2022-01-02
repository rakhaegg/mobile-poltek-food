import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_first_app/providers/AuthProvider.dart';
import 'package:my_first_app/providers/PesanProvider.dart';
import 'package:provider/provider.dart';

class BayarPage extends StatefulWidget {
  const BayarPage({Key? key}) : super(key: key);

  @override
  _BayarPageState createState() => _BayarPageState();
}

class _BayarPageState extends State<BayarPage> {
  TextEditingController alamatRumah = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    alamatRumah.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pesan")),
      body: Consumer<PesanProvider>(builder: (context, bayar, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.only(right: 300 , top : 20),
                  child: Text("Deliver To" , style: TextStyle(fontWeight: FontWeight.bold
                  , fontSize: 15),)),
              SizedBox(height: 10,),
              Card(
                margin:EdgeInsets.only(right:20 , left:20),
                child: TextFormField(
                    decoration : const  InputDecoration(
                      icon : Icon(  Icons.location_pin , size: 20,),
                      hintText: "Alamat Rumah",

                    ),
                   controller: alamatRumah,
                ),
              ),
              SizedBox(height: 10,),
              Container(
                margin:EdgeInsets.only(right: 275),
                child : Text(
                  "Order Summary",
                  style:TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15

                  )
                )
              ),

              Card(
                margin:EdgeInsets.only(right:10 , left:10),
                child: Column(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: Provider.of<PesanProvider>(context).food.length,
                        itemBuilder: (context, index) {
                          var food = bayar.food[index];
                          return ListTile(
                            leading : Image.memory(base64Decode(food.image)),
                            title: Text(food.name),
                            subtitle: Text(food.price.toString()),
                          );
                        }
                        ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: Provider.of<PesanProvider>(context).drink.length,
                        itemBuilder: (context, index) {
                          var drink = bayar.drink[index];
                          return ListTile(
                            leading : Image.memory(base64Decode(drink.image)),
                            title: Text(drink.name),
                            subtitle: Text(drink.price.toString()),
                          );
                        }),
                  ],
                ),
              ),


            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (Provider.of<PesanProvider>(context, listen: false).food.length !=
              0) {

            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                    title: Text('Pemesanan'),
                    content: Container(
                      height: 300.0, // Change as per your requirement
                      width: 300.0,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                                margin: EdgeInsets.only(right: 175),
                                child: Text("Alamat Rumah" , style: TextStyle(fontWeight: FontWeight.bold),)),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                                margin: EdgeInsets.only(right: 200),
                                child: Text(alamatRumah.text)),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                                margin: EdgeInsets.only(right: 200),
                                child: Text("Total Harga" , style: TextStyle(fontWeight: FontWeight.bold),)),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                                margin: EdgeInsets.only(right: 210),

                                child: Text(Provider.of<PesanProvider>(context).total().toString()))
                          ],
                        ),
                      ),
                    ),
                  actions: [
                InkWell(
                child: Text("OK "),
              onTap: () {
                      final authProve = Provider.of<AuthProvider>(context , listen: false);
                      final pesanProve = Provider.of<PesanProvider>(context , listen:false);
                      Future<String> getID()async{
                        return await authProve.getUserID();
                      }
                      Future<String> getShopID()async{
                        return await pesanProve.getShopID();
                      }
                      int end = Provider.of<PesanProvider>(context , listen: false).total() ;
                      Provider.of<PesanProvider>(context , listen:false).addPesanToServer(getID(), getShopID(), pesanProve.getFoodForPesan().toString(), end , pesanProve.getDrinkForPesan().toString());
                }
                )
                  ],
                ));
          }
        },
        label: const Text('Pesan'),
        icon: const Icon(Icons.check),
        backgroundColor: Colors.red,
      ),
    );
  }



}