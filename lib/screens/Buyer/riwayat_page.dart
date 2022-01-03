import 'package:flutter/material.dart';
import 'package:my_first_app/data/models/pesanForBuyer.dart';
import 'package:my_first_app/data/models/shop.dart';
import 'package:my_first_app/providers/AuthProvider.dart';
import 'package:my_first_app/providers/PesanProvider.dart';
import 'package:provider/provider.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({Key? key}) : super(key: key);

  @override
  _RiwayatPageState createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  @override
  Widget build(BuildContext context) {
    final pesanProve = Provider.of<PesanProvider>(context);
    final authProve = Provider.of<AuthProvider>(context, listen: false);

    Future<String> getID() async {
      return await authProve.getUserID();
    }

    Future<PesanForBuyer> fetchRiwaya() async {
      PesanForBuyer list = await pesanProve.fetchRiwayatPesan(await getID());
      return list;
    }


    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Pesanan"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FutureBuilder<PesanForBuyer>(
                future: fetchRiwaya(),
                builder: (context, AsyncSnapshot<PesanForBuyer> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Text('Loading....');
                    case ConnectionState.done:
                      if (snapshot.data?.data.user.length != 0) {
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data?.data.user.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                  title: Text(snapshot.data?.data.user[index].id
                                      as String),
                                subtitle:Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text(snapshot.data?.data.user[index].namaToko
                                    as String),

                                    Container(
                                        child: snapshot.data?.data.user[index].statusBuyer
                                        as String == ""  ?
                                            snapshot.data?.data.user[index].driverId
                                    as String == ""  ?  Text("Menunggu Driver") : Text('Driver menuju Lokasi')
                                            : Text("Selesai")
                                    ),

                                    Container(
                                      child:  snapshot.data?.data.user[index].statusBuyer
                                      as String == ""  ?
                                          snapshot.data?.data.user[index].statusShop
                                          as String == ""  ?  Text("Toko Menungggu Driver") :
                                          snapshot.data?.data.user[index].statusShop
                                          as String == "Sedang Memasak" ?
                                          Text('Sedang Memasak') : Text("Makakan Dibawa Driver")

                                          :Text("Selesai")
                                      ),

                                    Container(
                                      child:
                                          snapshot.data?.data.user[index].statusBuyer
                                          as String == ""  ?
                                          TextButton(
                                              style: TextButton.styleFrom(
                                                primary: Colors.red,
                                              ),
                                              onPressed: () {
                                                setState(() {

                                                  Provider.of<PesanProvider>(context , listen: false).updateDataBuyer(snapshot.data?.data.user[index].id as String

                                                    , "Terima");
                                                });

                                              }, child: Text("Terima")

                                      )
                                              : Text("Selesai")
                                    )

                                  ],
                                )

                              );
                            });
                      } else if (snapshot.hasError) {
                        print(snapshot.toString());
                      } else if (snapshot.data?.data.user.length == 0) {
                        return Container(
                            child: Text("Toko Belum Memiliki Menu"));
                      }
                      return CircularProgressIndicator();

                    default:
                      if (snapshot.hasError)
                        return Text('Error: ${snapshot.error}');
                      else
                        return Text('Result: ${snapshot.data}');
                  }
                })
          ],
        ),
      ),
    );
  }
}
