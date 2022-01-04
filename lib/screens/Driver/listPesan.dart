import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_first_app/data/models/buyer.dart';
import 'package:my_first_app/data/models/pesanForBuyer.dart';
import 'package:my_first_app/providers/AuthProvider.dart';
import 'package:my_first_app/providers/DrinkProvider.dart';
import 'package:my_first_app/providers/FoodProvider.dart';
import 'package:my_first_app/providers/PesanProvider.dart';
import 'package:my_first_app/providers/ShopProvider.dart';
import 'package:provider/provider.dart';
import 'dart:io' as Io;
class ListPesan extends StatefulWidget {
  const ListPesan({Key? key}) : super(key: key);

  @override
  _ListPesanState createState() => _ListPesanState();
}

class _ListPesanState extends State<ListPesan> {

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    final pesanProve = Provider.of<PesanProvider>(context, listen: false);
    final shopProv = Provider.of<ShopProvider>(context, listen: false);
    final authProve = Provider.of<AuthProvider>(context, listen: false);
    Future<PesanForBuyer> fetch() async {

      PesanForBuyer pesan = await pesanProve.fetOrderForDriver();

      return pesan;
    }
    bool _clicked = false;
    return Scaffold(
        appBar: AppBar(
          title: Text("List Pesan"),
        ),
        body:SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20,),
              FutureBuilder<PesanForBuyer>(
                  future: fetch(),
                  builder: (context, AsyncSnapshot<PesanForBuyer> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Text('Loading....');
                      case ConnectionState.done :
                        if (snapshot.data?.data.user.length != 0) {
                          return ListView.builder(
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data?.data.user.length,
                              itemBuilder: (context, index) {

                                return Card(
                                  shape: RoundedRectangleBorder(

                                    borderRadius: BorderRadius.circular(15.0),

                                  ),
                                  elevation: 10,
                                  child: ListTile(

                                    title: Text(snapshot.data?.data.user[index]
                                        .id as String),
                                    subtitle: Column(
                                      children: [
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Text("Nama Pembeli  : " , style :TextStyle(fontWeight: FontWeight.bold)),
                                            FutureBuilder<Buyer>(
                                                future: authProve.getName(snapshot.data?.data.user[index]
                                                    .buyerId as String),
                                                builder:   (context, AsyncSnapshot<Buyer> snapshot) {
                                                  switch (snapshot
                                                      .connectionState) {
                                                    case ConnectionState.waiting:
                                                      return Text('Loading....');
                                                    case ConnectionState.done :
                                                      if (snapshot.hasData) {
                                                        return Container(
                                                          child: Text(snapshot.data?.data.user.fullname as String
                                                            ,style: TextStyle(
                                                                fontWeight: FontWeight.bold
                                                            ),
                                                          ) ,
                                                        );
                                                      }else if (snapshot.hasError) {
                                                        print(snapshot.toString());
                                                      } else if (snapshot.data?.data.user.fullname == "") {
                                                        return Container(
                                                            child: Text("Tidak ada"
                                                            )
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

                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("Alamat Pembeli  : " , style :TextStyle(fontWeight: FontWeight.bold)),
                                            Text(snapshot.data?.data.user[index].alamatBuyer as String
                                            , style: TextStyle(
                                                  fontWeight: FontWeight.bold)
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("Nama Toko  : " , style :TextStyle(fontWeight: FontWeight.bold)),
                                            Text(snapshot.data?.data.user[index].namaToko as String)
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("Alamat Toko  : " , style :TextStyle(fontWeight: FontWeight.bold)),
                                            Text(snapshot.data?.data.user[index].alamatToko as String)
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            snapshot.data?.data.user[index].driverId as String == ""
                                                ?
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                primary: Colors.red,
                                              ),
                                              onPressed: () {
                                                setState(() {

                                                  Provider.of<PesanProvider>(context , listen: false).updateData(authProve.getUserID(),
                                                      snapshot.data?.data.user[index].id as String);
                                                });

                                              }, child: Text("Terima"),
                                            ) : snapshot.data?.data.user[index].statusShop == "" ?
                                                Text("Tunggu Toko Menerima") :
                                                snapshot.data?.data.user[index].statusShop  == "Sudah diantar toko" ?

                                                    snapshot.data?.data.user[index].statusBuyer == ""?
                                                        Text("Belum Diterim Buyer") : Text("Selesai")
                                                    : Text("Driver sedang ditoko"),

                                            SizedBox(width: 5),


                                            SizedBox(width: 5),


                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        } else if (snapshot.hasError) {
                          print(snapshot.toString());
                        } else if (snapshot.data?.data.user.length == 0) {
                          return Container(
                              child: Text("Tidak ada")
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
            ],
          ),
        ),

    );
  }
}