import 'package:flutter/material.dart';
import 'package:my_first_app/providers/AuthProvider.dart';
import 'package:my_first_app/providers/DrinkProvider.dart';
import 'package:my_first_app/providers/FoodProvider.dart';
import 'package:my_first_app/providers/ShopProvider.dart';
import 'package:my_first_app/screens/Buyer/food_page.dart';
import 'package:my_first_app/screens/Buyer/home.dart';

import 'package:my_first_app/screens/Seller/home.dart';
import 'package:my_first_app/screens/Driver/home_driver.dart';
import 'package:my_first_app/screens/Seller/home_page.dart';
import 'package:my_first_app/screens/Seller/RegisterShop.dart';
import 'package:my_first_app/screens/login.dart';
import 'package:my_first_app/screens/register.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AuthProvider(),
        child: Consumer<AuthProvider>(builder: (context, authProvider, child) {
          return MultiProvider(
              providers: [
                ChangeNotifierProvider<FoodProvider>(
                    create: (context) => FoodProvider(authProvider)),
                ChangeNotifierProvider<DrinkProvider>(
                    create: (context) => DrinkProvider(authProvider)),
                ChangeNotifierProvider<ShopProvider>(
                    create: (context) => ShopProvider(authProvider))
              ],
              child: MaterialApp(title: 'Pesan Antar', routes: {
                '/': (context) {
                  final authProvider = Provider.of<AuthProvider>(context);

                  if (authProvider.isAuthenticated){


                      if (authProvider.type == "Driver"){
                        print("Ini Halaman Driver");
                        return HomeDriver();
                      }else if (authProvider.type == "Seller"){
                        print("Ini Halaman Seller");

                        if(authProvider.isExists == false){
                          return RegisterShop();
                        }else{
                          return HomeSeller();
                        }
                        return CircularProgressIndicator();
                      }else if (authProvider.type == "Buyer"){
                        print("Ini Halaman Buyer");

                        return HomeBuyer();
                      }else{
                        return CircularProgressIndicator();
                      }
                  } else {
                    print(authProvider.isAuthenticated  );

                    return Login();
                  }
                },
                '/login': (context) => Login(),
                '/register': (context) => Register(),
                '/homeSeller': (context) => HomeSeller(),
                '/homePage': (context) => HomePage(),
                '/homeDriver': (context) => HomeDriver(),

              }));
        }));
  }
}
