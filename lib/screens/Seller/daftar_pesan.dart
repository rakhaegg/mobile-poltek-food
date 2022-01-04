import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_first_app/data/models/buyer.dart';
import 'package:my_first_app/data/models/pesanForBuyer.dart';
import 'package:my_first_app/providers/AuthProvider.dart';
import 'package:my_first_app/providers/PesanProvider.dart';
import 'package:my_first_app/providers/ShopProvider.dart';
import 'package:provider/provider.dart';



class DaftarPesan extends StatefulWidget {
  const DaftarPesan({Key? key}) : super(key: key);

  @override
  _DaftarPesanState createState() => _DaftarPesanState();
}

class _DaftarPesanState extends State<DaftarPesan> {
  @override
  Widget build(BuildContext context) {
    final pesanProve = Provider.of<PesanProvider>(context , listen:false);
    final shopProv = Provider.of<ShopProvider>(context , listen:false);
    final authProve = Provider.of<AuthProvider>(context , listen: false);

    Future<PesanForBuyer> fetch()async{
      PesanForBuyer pesan = await pesanProve.fetchDaftarPsan(await shopProv.getShopID());

      return pesan;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Pesan"),
      ),
      body: SingleChildScrollView(
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
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [

                                            snapshot.data?.data.user[index].driverId == "" ?
                                                Text("Menunggu Driver") : snapshot.data?.data.user[index].statusShop == "" ?
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                primary: Colors.red,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  pesanProve.updateDataSeller(
                                                      snapshot.data?.data.user[index].id as String, "Diterima");
                                                });

                                              }, child: Text("Terima"),
                                            ) : snapshot.data?.data.user[index].statusShop == "Sudah diantar toko" ?

                                                Text("Selesai") :
                                            TextButton(
                                                style: TextButton.styleFrom(
                                                  primary: Colors.red,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    pesanProve.updateDataSeller(
                                                        snapshot.data?.data.user[index].id as String, "Sudah diantar toko");
                                                  });

                                                }, child: Text("Telah Diterima Driver? "),
                                            ),
                                            SizedBox(width: 5),


                                            SizedBox(width: 5),

                                          ],
                                        )
                                      ],
                                    ),
                                    onTap: () {
                                      var dataSp = snapshot.data?.data.user[index].daftar.split(',') as List<String> ;

                                      Widget okButton = FlatButton(
                                        child: Text("OK"),
                                        onPressed: () { },
                                      );
                                      Widget _listView(){
                                        return Container(
                                            height: 300.0, // Change as per your requirement
                                            width: 300.0, // Change as per your requirement
                                            child:  ListView.builder(
                                                scrollDirection: Axis
                                                    .vertical,
                                                shrinkWrap: true,
                                                itemCount: dataSp?.length,
                                                itemBuilder: (context , index){
                                                  return Card(
                                                      child:
                                                          index == 0 || index == 3 || index == 6
                                                              || index ==9 || index == 12
                                                              ?
                                                          Text(""):
                                                      Text(
                                                          dataSp[index].replaceAll("{", "").replaceAll("}", "")
                                                              .replaceAll("[", "").replaceAll("]", "").replaceAll("[", "").trim()
                                                      )



                                                  );

                                                }
                                            ));
                                      }
                                      AlertDialog alert = AlertDialog(
                                        title: Text("Daftar Pesanan"),
                                        content:_listView(),

                                        actions: [
                                          okButton,
                                        ],
                                      );

                                      // show the dialog
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return alert;
                                        },
                                      );
                                    }),
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
