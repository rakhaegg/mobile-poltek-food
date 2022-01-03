
import 'package:flutter/material.dart';


class HomePageDriver extends StatefulWidget {
  const HomePageDriver({Key? key}) : super(key: key);

  @override
  _HomePageDriverState createState() => _HomePageDriverState();
}

class _HomePageDriverState extends State<HomePageDriver> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text("Driver"),
        ),
        body: Container(

        )
    );
  }
}

