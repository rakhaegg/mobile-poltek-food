import 'package:flutter/material.dart';
import 'package:my_first_app/providers/AuthProvider.dart';
import 'package:my_first_app/providers/ShopProvider.dart';

import 'package:provider/provider.dart';

import 'home_page_driver.dart';
import 'listPesan.dart';

class HomeDriver extends StatefulWidget {
  @override
  _HomeDriverState createState() => _HomeDriverState();
}

class _HomeDriverState extends State<HomeDriver> {
  int selectedIndex = 0;
  List<Widget> widgetOptions = [
    ListPesan(),
    //Categories(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Selamat Datang!',
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
                backgroundColor: Colors.red,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.logout),
                label: 'Exit',
                backgroundColor: Colors.pink,
              )],
            currentIndex: selectedIndex,
            onTap: onItemTapped,
          ),
        ),
      ),
    );
  }

  Future<void> onItemTapped(int index) async {
    if (index == 1) {
      final AuthProvider provider =
      Provider.of<AuthProvider>(context, listen: false);

      final ShopProvider shop = Provider.of<ShopProvider>(context , listen: false);
      await shop.logOut();
      await provider.logOut();

    } else {
      setState(() {
        selectedIndex = index;
      });
    }
  }
}