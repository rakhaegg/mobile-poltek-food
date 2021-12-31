import 'package:flutter/material.dart';
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
              TextField(
                controller: alamatRumah,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: Provider.of<PesanProvider>(context).food.length,
                  itemBuilder: (context, index) {
                    var food = bayar.food[index];
                    return ListTile(
                      title: Text(food.name),
                      subtitle: Text(food.harga),
                    );
                  }),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: Provider.of<PesanProvider>(context).drink.length,
                  itemBuilder: (context, index) {
                    var drink = bayar.drink[index];
                    return ListTile(
                      title: Text(drink.name),
                      subtitle: Text(drink.harga),
                    );
                  }),

              Text(Provider.of<PesanProvider>(context).total().toString())
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
                            Text("Alamat Rumah"),
                            Text(alamatRumah.text),
                            SizedBox(
                              height: 5,
                            ),
                            Text("Daftar Pemesanan"),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: Provider.of<PesanProvider>(context,
                                    listen: false)
                                    .food
                                    .length,
                                itemBuilder: (context, index) {
                                  var food = Provider.of<PesanProvider>(context)
                                      .food[index];
                                  return ListTile(
                                    title: Text(food.name),
                                    subtitle: Text(food.harga),
                                  );
                                }),
                          ],
                        ),
                      ),
                    )));
          }
        },
        label: const Text('Pesan'),
        icon: const Icon(Icons.check),
        backgroundColor: Colors.red,
      ),
    );
  }
}