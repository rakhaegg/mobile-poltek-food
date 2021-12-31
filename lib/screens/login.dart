
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:my_first_app/providers/AuthProvider.dart';
import 'package:my_first_app/providers/ShopProvider.dart';

import 'package:provider/provider.dart';
import 'package:device_info/device_info.dart';

class Login extends StatefulWidget {
  Login();

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late String deviceName;
  String errorMessage = '';
  String dropdownValue = "Driver";

  @override
  void initState() {
    super.initState();
    getDeviceName();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        color: Theme.of(context).primaryColorDark,
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
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                            ),
                            validator: (String? value) {
                              // Validation condition
                              if (value!.trim().isEmpty) {
                                return 'Please enter email';
                              }

                              return null;
                            },
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: passwordController,
                            obscureText: true,
                            autocorrect: false,
                            enableSuggestions: false,
                            decoration: InputDecoration(labelText: 'Password'),
                            validator: (String? value) {
                              // Validation condition
                              if (value!.isEmpty) {
                                return 'Please enter password';
                              }

                              return null;
                            },
                          ),
                          ElevatedButton(
                            onPressed: () => submit(),
                            child: Text('Login'),
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size(double.infinity, 36)),
                          ),
                          Text(errorMessage, style: TextStyle(color: Colors.red)),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/register');
                              },
                              child: Text('Register New User',
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
      ),
    );
  }

  Future<void> submit() async {
    final form = _formKey.currentState;

    if (!form!.validate()) {
      return;
    }

    final AuthProvider provider = Provider.of<AuthProvider>(context, listen: false);
    final ShopProvider shopProvider = Provider.of<ShopProvider>(context, listen: false);

    try {
      if (dropdownValue == "Driver"){
        await provider.login(
            emailController.text,
            passwordController.text,
            deviceName,
            "Driver"
        );

      }else if (dropdownValue  == "Seller"){
        await provider.login(
            emailController.text,
            passwordController.text,
            deviceName,
            "Seller"
        );
        //final number = await shopProvider.checkShop(await provider.getUserID());

      }else if (dropdownValue == "Buyer"){
        await provider.login(
            emailController.text,
            passwordController.text,
            deviceName,
            "Buyer"
        );

      }


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
  1. Jika user belum terdaftar maka tampil pesan
  2. Jika dipassword yang diberikan salah maka tampil sebuah pesan
  3. Jika username belum terisi maka tampil pesan
  4. Jika password belum terisi maka tampil pesan
 */
