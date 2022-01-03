import 'package:flutter/material.dart';
import 'package:my_first_app/providers/AuthProvider.dart';
import 'package:my_first_app/providers/PesanProvider.dart';
import 'package:my_first_app/providers/ShopProvider.dart';
import 'package:my_first_app/screens/Buyer/riwayat_page.dart';
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
    RiwayatPage()
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
                icon: const Icon(Icons.home),
                label: 'Home',
                backgroundColor: Colors.lightBlue,
              ),

              BottomNavigationBarItem(
                icon: const Icon(Icons.message),
                label: 'Pesan',
                backgroundColor: Colors.lightBlue,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.my_library_books),
                label: 'Riwayat',
                backgroundColor: Colors.lightBlue,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.logout),
                label: 'Exit',
                backgroundColor: Colors.lightBlue,
              )],
            currentIndex: selectedIndex,
            onTap: onItemTapped,
          ),
        ),
      );
  }

  Future<void> onItemTapped(int index) async {
    if (index == 3) {
      final AuthProvider provider =
      Provider.of<AuthProvider>(context, listen: false);

      final ShopProvider shop = Provider.of<ShopProvider>(context , listen: false);
      final PesanProvider pesan = Provider.of<PesanProvider>(context , listen:false);
      await shop.logOut();
      await provider.logOut();
      await pesan.logOut();
    } else {
      setState(() {
        selectedIndex = index;
      });
    }
  }
}