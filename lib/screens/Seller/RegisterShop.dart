import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';


import 'package:my_first_app/providers/ShopProvider.dart';
import 'package:provider/provider.dart';
import 'dart:io' as Io;

class RegisterShop extends StatefulWidget {
  const RegisterShop({ Key? key }) : super(key: key);

  @override
  _RegisterShopState createState() => _RegisterShopState();
}

class _RegisterShopState extends State<RegisterShop> {
 final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
 Io.File? image;

  final nameShopController = TextEditingController();
  final addressShopContoroller = TextEditingController();
  final noPhoneController = TextEditingController();
    String errorMessage = '';


  @override
  void dispose(){
    super.dispose();

    nameShopController.dispose();
    addressShopContoroller.dispose();
    noPhoneController.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    
   
    return 
      Scaffold(
        appBar: AppBar(
          title: Text("Daftar Toko"),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      elevation: 8,
                      margin: EdgeInsets.only(left: 16, right: 16),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                keyboardType: TextInputType.name,
                                controller: nameShopController,
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'Masukkan Nama Toko';
                                  }

                                  return null;
                                },
                                onChanged: (text) => setState(() => errorMessage = ''),
                                decoration: InputDecoration(
                                  labelText: 'Nama Toko',
                                ),
                              ),

                              TextFormField(
                                keyboardType: TextInputType.name,
                                controller: addressShopContoroller,
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'Masukkkan Alamt Toko';
                                  }

                                  return null;
                                },
                                onChanged: (text) => setState(() => errorMessage = ''),
                                decoration: InputDecoration(labelText: 'Alamat Toko'),
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                controller: noPhoneController,
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'Masukkan No HP';
                                  }

                                  return null;
                                },
                                onChanged: (text) => setState(() => errorMessage = ''),
                                decoration: InputDecoration(
                                  labelText: 'No Toko',
                                ),
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
                                      child: Text("Pick a Gallery")
                                  )
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () => submit(),
                                child: Text('Register'),
                                style: ElevatedButton.styleFrom(
                                    minimumSize: Size(double.infinity, 36)),
                              ),
                              Text(errorMessage, style: TextStyle(color: Colors.red)),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      );

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
     print('Failed to pick Image $e');
   }



 }


  Future<void> submit() async {
    final form = _formKey.currentState;

    if (!form!.validate()) {
      return;
    }

    final ShopProvider provider = Provider.of<ShopProvider>(context, listen: false);
    Uint8List? imageBytes =  this.image?.readAsBytesSync() ;
    String img64 = base64Encode(imageBytes!);
    try {
      print("asd");
      await provider.register(
          nameShopController.text,
          addressShopContoroller.text,
          noPhoneController.text,
          img64,


      );
  
      Navigator.popAndPushNamed(context , '/homeSeller');
    } catch (Exception) {

      setState(() {
        errorMessage = Exception.toString().replaceAll('Exception: ', '');
      });
    }
    }
  }
/*
  Test Case
  1. Jika nama toko telah ada maka tampil pesan Nama Toko Telah Ada
  2. Jika salah satu field kosong maka harus diisi maka harus tampil pesan yang
      sesuai
  3.


 */
