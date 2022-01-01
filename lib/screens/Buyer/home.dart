import 'package:flutter/material.dart';
import 'package:my_first_app/providers/AuthProvider.dart';
import 'package:my_first_app/providers/ShopProvider.dart';
import 'package:my_first_app/screens/Seller/CreatePage.dart';
import 'package:my_first_app/screens/Seller/home_page.dart';
import 'package:provider/provider.dart';

import 'bayar_page.dart';
import 'home_page.dart';

class HomeBuyer extends StatefulWidget {
  @override
  _HomeBuyerState createState() => _HomeBuyerState();
}

class _HomeBuyerState extends State<HomeBuyer> {
  int selectedIndex = 0;
  List<Widget> widgetOptions = [
    HomeBuyerPage(),
    BayarPage(),
    //Categories(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                icon: Icon(Icons.create),
                label: 'Create',
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
      );
  }

  Future<void> onItemTapped(int index) async {
    if (index == 2) {
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