import 'package:flutter/material.dart';
import 'package:my_first_app/providers/DrinkProvider.dart';
import 'package:my_first_app/providers/FoodProvider.dart';
import 'package:provider/provider.dart';

class HomeBuyerPage extends StatefulWidget {
  const HomeBuyerPage({ Key? key }) : super(key: key);

  @override
  _HomeBuyerPage createState() => _HomeBuyerPage();
}

class _HomeBuyerPage extends State<HomeBuyerPage> {

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TokoProvider>(context);
    final drinkProv = Provider.of<DrinkProvider>(context);
    final foodProv = Provider.of<FoodProvider>(context);
    List<Toko> toko = provider.toko;
    List<Drink> drink = drinkProv.toko;
    List<Food> food = foodProv.toko;
    return Scaffold(
        appBar: AppBar(
            title : Text("Home")
        ),
        body : SingleChildScrollView(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: toko.length,
              itemBuilder: (context , index){
                return Column(
                  children: [
                    ListTile(
                      leading: Image.network(toko[index].pictureId),
                      subtitle: Row(
                        children: [
                          Container(child: Icon(Icons.star,
                            color: Colors.yellow,
                          )),
                          SizedBox(width: 2,),
                          Text(toko[index].rating.toString()),
                        ],
                      ),
                      title: Text(toko[index].name , style: TextStyle(fontWeight: FontWeight.bold),),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => FoodPage(id :toko[index].restaurantId , drinks:drink , food: food ,)  ));
                      },

                    ),
                    SizedBox(height: 5,)
                  ],
                );
              }),
        )
    );
  }
}