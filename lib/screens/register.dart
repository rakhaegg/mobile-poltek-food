import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:my_first_app/providers/AuthProvider.dart';
import 'package:provider/provider.dart';
import 'package:device_info/device_info.dart';

class Register extends StatefulWidget {
  Register();

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final fullnameController = TextEditingController();

  String errorMessage = '';
  late String deviceName;
  String dropdownValue = "Driver";
  @override
  void initState() {
    super.initState();
    getDeviceName();
  }
  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
    fullnameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: SingleChildScrollView(
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
                          items: <String>['Driver', 'Seller' , "Buyer"]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.name,
                          controller: usernameController,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Enter name';
                            }

                            return null;
                          },
                          onChanged: (text) => setState(() => errorMessage = ''),
                          decoration: InputDecoration(
                            labelText: 'Name',
                          ),
                        ),

                        TextFormField(
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          controller: passwordController,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Enter password';
                            }

                            return null;
                          },
                          onChanged: (text) => setState(() => errorMessage = ''),
                          decoration: InputDecoration(labelText: 'Password'),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.name,
                          controller: fullnameController,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Enter Full Name';
                            }

                            return null;
                          },
                          onChanged: (text) => setState(() => errorMessage = ''),
                          decoration: InputDecoration(
                            labelText: 'Fullname',
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => submit(),
                          child: Text('Register'),
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 36)),
                        ),
                        Text(errorMessage, style: TextStyle(color: Colors.red)),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text('<- Back to Login',
                                style: TextStyle(fontSize: 14)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
      ),
    );
  }

  Future<void> submit() async {
    final form = _formKey.currentState;

    if (!form!.validate()) {
      return;
    }

    final AuthProvider provider = Provider.of<AuthProvider>(context, listen: false);
    try {
      if (dropdownValue == "Driver"){
        await provider.register(
            usernameController.text,
            passwordController.text,
            fullnameController.text,
            "Driver"
        );

      }else if (dropdownValue  == "Seller"){
        print("asd");
        await provider.register(
            usernameController.text,
            passwordController.text,
            fullnameController.text,
            "Seller"
        );

      }else if (dropdownValue == "Buyer"){
        print("register buyer");
        await provider.register(
            usernameController.text,
            passwordController.text,
            fullnameController.text,
            "Buyer"
        );

      }


      Navigator.pop(context);
    } catch (Exception) {
      setState(() {
        errorMessage = Exception.toString().replaceAll('Exception: ', '');
      });
    }
  }

  Future<void> getDeviceName() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        setState(() {
          deviceName = build.model;
        });
      } else if (Platform.isIOS) {
        var build = await deviceInfoPlugin.iosInfo;
        setState(() {
          deviceName = build.model;
        });
      }
    } on PlatformException {
      setState(() {
        deviceName = 'Failed to get platform version';
      });
    }
  }
}
/*
      Test Case
      1. Jika user telah terdafar maka akan output sebuah pesan sudah terdaftar
      2. Jika username tidak diisi maka tampil pesan
      3. Jika password tidak diisi maka tampil pesan enter password
      4. Jika fullname tidak diisi maka tampil pesan enter fullname
   */