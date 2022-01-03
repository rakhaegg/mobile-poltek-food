import 'package:flutter/material.dart';
import 'package:my_first_app/providers/AuthProvider.dart';
import 'package:my_first_app/providers/ShopProvider.dart';
import 'package:my_first_app/screens/Seller/CreatePage.dart';
import 'package:my_first_app/screens/Seller/home_page.dart';
import 'package:provider/provider.dart';

import 'daftar_pesan.dart';

class HomeSeller extends StatefulWidget {
  @override
  _HomeSellerState createState() => _HomeSellerState();
}

class _HomeSellerState extends State<HomeSeller> {
  int selectedIndex = 0;
  List<Widget> widgetOptions = [
    HomePage(),
    CreatePage(),
    DaftarPesan(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        body: widgetOptions.elementAt(selectedIndex),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 4,
          child: BottomNavigationBar(
            backgroundColor: Theme.of(context).primaryColor.withAlpha(0),
            elevation: 0,
            items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.create),
            label: 'Create',
            backgroundColor: Colors.blue,
          ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'List',
                backgroundColor: Colors.blue,
              ),

              BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Exit',
            backgroundColor: Colors.blue,
          )],
            currentIndex: selectedIndex,
            onTap: onItemTapped,
          ),
        ),
      ),
    );
  }

  Future<void> onItemTapped(int index) async {
    if (index == 3) {
      print("EXIT");
      final AuthProvider provider = Provider.of<AuthProvider>(context, listen: false);

      final ShopProvider shop = Provider.of<ShopProvider>(context , listen: false);
      await shop.logOut();
      await provider.logOut();
      Navigator.popAndPushNamed(context , '/');
    } else {
      setState(() {
        selectedIndex = index;
      });
    }
  }
}