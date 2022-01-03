import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_first_app/providers/AuthProvider.dart';
import 'package:my_first_app/providers/DrinkProvider.dart';
import 'package:my_first_app/providers/FoodProvider.dart';
import 'package:my_first_app/providers/ShopProvider.dart';
import 'package:provider/provider.dart';
import 'dart:io' as Io;
class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Io.File? image;

  final nameController = TextEditingController();
  final priceController = TextEditingController();

  String dropdownValue = 'Makanan';
  String errorMessage = "";
  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    priceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Halaman Create"),
        ),
        body: Column(
          children: [
            DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: <String>['Makanan', 'Minuman']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Text(dropdownValue),
            Column(
              children: <Widget>[
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[

                          TextFormField(
                            keyboardType: TextInputType.name,
                            controller: nameController,
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return "Masukkan Nama $dropdownValue";
                              }
                              return null;
                            },
                            onChanged: (text) =>
                                setState(() => errorMessage = ""),
                            decoration: InputDecoration(labelText: "Nama $dropdownValue"),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: priceController,
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return "Masukkan Harga $dropdownValue";
                              }
                              return null;
                            },
                            onChanged: (text) =>
                                setState(() => errorMessage = ""),
                            decoration: InputDecoration(labelText: "Harga $dropdownValue"),
                          ),
                          SizedBox(height :20 ),
                          Row(
                            children: <Widget>[
                              image != null ? Image.file(
                                image!,
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ) : FlutterLogo(size:50),
                              SizedBox(width :20 ),

                              ElevatedButton(
                                  onPressed: () => pickImage(),
                                  child: Text("Pilih Gallery")
                              )
                            ],
                          ),

                          ElevatedButton(
                            onPressed: () => submit(dropdownValue),
                            child: Text("Buat Data"),
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size(double.infinity, 36)),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ));
  }
  Future pickImage() async{
    try{
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);


      if (image == null)return ;

      final imageTemporary = Io.File(image.path);
      setState(()  {
        this.image = imageTemporary;

      });


    }on PlatformException catch(e){
      print('Gagal memilih gambar $e');
    }



  }
  Future<void> submit(String value) async {
    final form = _formKey.currentState;

    if (!form!.validate()) {
      return;
    }

    final AuthProvider provider =
        Provider.of<AuthProvider>(context, listen: false);
    final ShopProvider shopProvider =
        Provider.of<ShopProvider>(context, listen: false);
    final FoodProvider foodProvider =
        Provider.of<FoodProvider>(context, listen: false);
      final DrinkProvider drinkProvider =
        Provider.of<DrinkProvider>(context, listen: false);


    try {
      Uint8List? imageBytes =  this.image?.readAsBytesSync() ;
      String img64 = base64Encode(imageBytes!);
      if (value == "Makanan") {


        await foodProvider.addFood(
          nameController.text,
          int.parse(priceController.text),
          img64,
          await shopProvider.getShopID(),
          await provider.getToken(),
        );


      } else 
      {
        await drinkProvider.addDrink(
           nameController.text,
            int.parse(priceController.text),
            img64,
          await shopProvider.getShopID(),
          await provider.getToken()
        );
      }

      print(await provider.getUserID());
    } catch (Exception) {
      setState(() {
        errorMessage = Exception.toString();
      });
    }
  }
}