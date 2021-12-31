import 'package:my_first_app/data/models/token.dart';
import 'package:sqflite/sqflite.dart';

//Kelas dibawah untuk fitur favourite dengna database SQLite

//Helper

//Inisiasi objek DatabaseHelper dengan pola Singleton

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tblName = 'authentications';


  //Kode dibawah untuk inisialisasi database
  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/sial28.db',
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tblName (
             token TEXT
           )     
        ''');
       
      },
      version: 1,
    );

    return db;
  }

  //Kode dibawah untuk inisialisasi database
  Future<Database?> get database async {
    if (_database == null) {
      _database = await _initializeDb();
    }

    return _database;
  }

  //Kode dibawah untuk menyimpan data ke dalam database
  Future<void> insertToken(Data token) async {
    final db = await database;

    // var value = {
    //   "t": restaurant.id,
    // };

    // await db!.insert(_tblName, value);
    
  }

  // //Kode dibawah untuk mengambil data dari database
  // Future<List<RestaurantDetail>> getFavourite() async {
  //   final db = await database;
  //   //Perintah query untuk mengambil data

  //   List<Map<String, dynamic>> results = await db!.query(_tblfavourite);
  //   List<Map<String, dynamic>> newUser = [];
   

  //   for (var i = 0; i < results.length; i++) {
  //     final map = Map.of(results[i]);

  //     List<Map<String, dynamic>> cat = await db.query(
  //       _category,
  //       columns: ['name'],
  //       where: 'id_restaurant = ?',
  //       whereArgs: [map["id"]],
  //     );

  //     map["categories"] = cat;
  //     newUser.add(map);
  //     // print(newUser);
  //     // results[i].update("categories", (value) => getCat(results[i]["id"]));
  //   }

  //   for (var i = 0; i < newUser.length; i++) {
  //     List<Map<String, dynamic>> cat = await db.query(
  //       _customerReview,
  //       columns: ['name', 'review', 'date'],
  //       where: 'id_restaurant = ?',
  //       whereArgs: [newUser[i]["id"]],
  //     );
  //     newUser[i]["customerReviews"] = cat;
  //     // print(newUser[i]);
  //   }

  //   for (var i = 0; i < newUser.length; i++) {
  //     List<Map<String, dynamic>> food = await db.query(
  //       _food,
  //       columns: ['name'],
  //       where: 'id_restaurant = ?',
  //       whereArgs: [newUser[i]["id"]],
  //     );
  //     List<Map<String, dynamic>> drink = await db.query(
  //       _drink,
  //       columns: ['name'],
  //       where: 'id_restaurant = ?',
  //       whereArgs: [newUser[i]["id"]],
  //     );
  //     var map = {"foods": food, "drinks": drink};
  //     newUser[i]["menus"] = map;

  //   }

  //   return newUser.map((res) => RestaurantDetail.fromJson(res)).toList();
  // }

  // //Kode dibawah untuk mengambil data dengan kriteria
  // Future<Map> getFavouritebyID(String id) async {
  //   final db = await database;

  //   List<Map<String, dynamic>> results = await db!.query(
  //     _tblfavourite,
  //     where: 'id = ?',
  //     whereArgs: [id],
  //   );
    

  //   if (results.isNotEmpty) {
  //     return results.first;
  //   } else {
  //     return {};
  //   }
  // }

  // //Kode dibawah untuk menghapus data dari database
  // Future<void> removeFavourite(String id) async {
  //   final db = await database;

  //   await db!.delete(
  //     _tblfavourite,
  //     where: 'id = ?',
  //     whereArgs: [id],
  //   );
  //   await db.delete(
  //     _category,
  //     where: 'id_restaurant = ?',
  //     whereArgs: [id],

  //   );
  //   await db.delete(
  //     _customerReview,
  //     where: 'id_restaurant = ?',
  //     whereArgs: [id],

  //   );
  //   await db.delete(
  //     _customerReview,
  //     where: 'id_restaurant = ?',
  //     whereArgs: [id],

  //   );
  //   await db.delete(
  //     _food,
  //     where: 'id_restaurant = ?',
  //     whereArgs: [id],

  //   );
  //   await db.delete(
  //     _drink,
  //     where: 'id_restaurant = ?',
  //     whereArgs: [id],

  //   );
    
    
    
  
}
