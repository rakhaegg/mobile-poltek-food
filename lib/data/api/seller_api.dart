import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:my_first_app/data/models/toko.dart';

class SellerApiService {
  late String token;

  SellerApiService(String token) {
    this.token = token;
  }

  final String baseUrl = "http://10.0.2.2:5000/";

  

  Future<String> fetchFood(String userID , String token) async{
    http.Response response = await http.get(
      Uri.parse(baseUrl + 'seller/shops/food/$userID'),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );

    if (response.statusCode == 404 ) {
      Map<String, dynamic> body = jsonDecode(response.body);
      String errorMessage = "Makanan Kosong Silahkan Daftar Makanan";
      throw Exception(errorMessage);
    }

    return response.body;
  }
  Future<String> fetchDrink(String userID , String token) async{
    http.Response response = await http.get(
      Uri.parse(baseUrl + 'seller/shops/drink/$userID'),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );
    if (response.statusCode == 404 ) {
      Map<String, dynamic> body = jsonDecode(response.body);
      String errorMessage = "Minuman Kosong Silahkan Daftar Minuman";
      throw Exception(errorMessage);
    }
    return response.body;
  }


  Future<String> register(String username,  String password, String fullname) async {
    String uri = baseUrl + 'seller';
    print(password);

    http.Response response = await http.post(Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          
        },
        body: jsonEncode({
          'username': username,
          'password': password,
          'fullname': fullname,
        
        }));

    if (response.statusCode == 400) {
      Map<String, dynamic> body = jsonDecode(response.body);
      String errors = body['message'];
      String errorMessage = errors;
      throw Exception(errorMessage);
    }
    // return token
    return response.body;
  }

  Future<String> login(String email, String password, String deviceName) async {
    String uri = baseUrl + 'seller/authentications';

    http.Response response = await http.post(Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        
        },
        body: jsonEncode({
          'username': email,
          'password': password,
        }));

    if (response.statusCode == 401) {
      Map<String, dynamic> body = jsonDecode(response.body);
      String errors = body['message'];
      String errorMessage = errors;

      throw Exception(errorMessage);
    }

    // return token
    return response.body;
  }

  Future<String> registerShop(String nameShop , String addressShop , String noShop , String image , String token) async {
    String uri = baseUrl + 'seller/shops';


    http.Response response = await http.post(Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader :"Bearer $token"
        },
        body: jsonEncode({
          'name': nameShop,
          'address': addressShop,
          'no_phone': noShop,
          'image' : image
        
        }));

    if (response.statusCode == 400) {
      Map<String, dynamic> body = jsonDecode(response.body);
      String errors = body['message'];
      String errorMessage = errors;

      throw Exception(errorMessage);
    }
    // return token
    return response.body;
  }
  Future<String> check( String token) async {
    String uri = baseUrl + 'seller/shops/check';

    http.Response response = await http.get(Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader :"Bearer $token"
        },
    );
    
    if (response.statusCode == 422) {
      Map<String, dynamic> body = jsonDecode(response.body);
      Map<String, dynamic> errors = body['errors'];
      String errorMessage = '';
      errors.forEach((key, value) {
        value.forEach((element) {
          errorMessage += element + '\n';
        });
      });
      throw Exception(errorMessage);
    }
    // return token
    print(token);
    return response.body;
  }
Future<String> getShop(String id , String token) async {
    String uri = baseUrl + 'seller/shops/$id';

    http.Response response = await http.get(Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader :"Bearer $token"
        },
    );
    
    if (response.statusCode == 422) {
      Map<String, dynamic> body = jsonDecode(response.body);
      Map<String, dynamic> errors = body['errors'];
      String errorMessage = '';
      errors.forEach((key, value) {
        value.forEach((element) {
          errorMessage += element + '\n';
        });
      });
      throw Exception(errorMessage);
    }
    // return token
    print(response.body);
    return response.body;
  }
  Future<String> addFood(String name , int price , String image ,String id , String token) async {
    String uri = baseUrl + 'seller/shops/food/$id';

    http.Response response = await http.post(Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader :"Bearer $token"
        },
        
        body: jsonEncode({
          'name': name,
          'price': price,
          'image' : image
        
        }));
    
    
    if (response.statusCode == 422) {
      Map<String, dynamic> body = jsonDecode(response.body);
      Map<String, dynamic> errors = body['errors'];
      String errorMessage = '';
      errors.forEach((key, value) {
        value.forEach((element) {
          errorMessage += element + '\n';
        });
      });
      throw Exception(errorMessage);
    }
    // return token
    return response.body;
  }
  Future<String> addDrink(String name , int price , String image , String id , String token) async {
    String uri = baseUrl + 'seller/shops/drink/$id';

    http.Response response = await http.post(Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader :"Bearer $token"
        },
        
        body: jsonEncode({
          'name': name,
          'price': price,
          'image' : image
        
        }));
    
    
    if (response.statusCode == 422) {
      Map<String, dynamic> body = jsonDecode(response.body);
      Map<String, dynamic> errors = body['errors'];
      String errorMessage = '';
      errors.forEach((key, value) {
        value.forEach((element) {
          errorMessage += element + '\n';
        });
      });
      throw Exception(errorMessage);
    }
    // return token
    return response.body;
  }
  Future<String> deleteFood(String idFood , String idShop ,  String token) async {
    String uri = baseUrl + 'seller/shops/food/$idFood';

    http.Response response = await http.delete(Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader :"Bearer $token"
        },
        
        body: jsonEncode({
          'id_shop': idShop,
          
        
        }));
    
    
    if (response.statusCode == 422) {
      Map<String, dynamic> body = jsonDecode(response.body);
      Map<String, dynamic> errors = body['errors'];
      String errorMessage = '';
      errors.forEach((key, value) {
        value.forEach((element) {
          errorMessage += element + '\n';
        });
      });
      throw Exception(errorMessage);
    }
    // return token
    return response.body;
  }
  Future<String> deleteDrink(String idDrink , String idShop ,  String token) async {
    String uri = baseUrl + 'seller/shops/drink/$idDrink';

    http.Response response = await http.delete(Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader :"Bearer $token"
        },
        
        body: jsonEncode({
          'id_shop': idShop,
          
        }));
    
    
    if (response.statusCode == 422) {
      Map<String, dynamic> body = jsonDecode(response.body);
      Map<String, dynamic> errors = body['errors'];
      String errorMessage = '';
      errors.forEach((key, value) {
        value.forEach((element) {
          errorMessage += element + '\n';
        });
      });
      throw Exception(errorMessage);
    }
    // return token
    return response.body;
  }
  Future<String> updateDrink(String name , int price , String idDrink, String idShop  ,  String token) async {
    String uri = baseUrl + 'seller/shops/drink/$idDrink';
    http.Response response = await http.put(Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader :"Bearer $token"
        },
        
        body: jsonEncode({
          "id_shop" : idShop,
          "name" : name,
          "price" : price,
          
        }));
    
    
    if (response.statusCode == 422) {
      Map<String, dynamic> body = jsonDecode(response.body);
      Map<String, dynamic> errors = body['errors'];
      String errorMessage = '';
      errors.forEach((key, value) {
        value.forEach((element) {
          errorMessage += element + '\n';
        });
      });
      throw Exception(errorMessage);
    }
    // return token
    return response.body;
  }
  Future<String> updateFood(String name , int price , String idFood,String image , String idShop  ,  String token) async {
    String uri = baseUrl + 'seller/shops/food/$idFood';

    http.Response response = await http.put(Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader :"Bearer $token"
        },
        
        body: jsonEncode({
          "id_shop" : idShop,
          "name" : name,
          "price" : price,
          "image" :image
          
        }));
    

    if (response.statusCode == 422) {
      Map<String, dynamic> body = jsonDecode(response.body);
      Map<String, dynamic> errors = body['errors'];
      String errorMessage = '';
      errors.forEach((key, value) {
        value.forEach((element) {
          errorMessage += element + '\n';
        });
      });
      throw Exception(errorMessage);
    }
    // return token
    return response.body;


  }
  Future<String> getDafterPesan(String shopId) async {
    String uri = baseUrl + 'order/seller/$shopId';

    http.Response response = await http.get(Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader :"Bearer $token"
        },

        );


    if (response.statusCode == 422) {
      Map<String, dynamic> body = jsonDecode(response.body);
      Map<String, dynamic> errors = body['errors'];
      String errorMessage = '';
      errors.forEach((key, value) {
        value.forEach((element) {
          errorMessage += element + '\n';
        });
      });
      throw Exception(errorMessage);
    }
    // return token
    return response.body;


  }
  Future<String> getName(String shopId) async {
    String uri = baseUrl + 'buyer/$shopId';

    http.Response response = await http.get(Uri.parse(uri),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader :"Bearer $token"
      },

    );


    if (response.statusCode == 422) {
      Map<String, dynamic> body = jsonDecode(response.body);
      Map<String, dynamic> errors = body['errors'];
      String errorMessage = '';
      errors.forEach((key, value) {
        value.forEach((element) {
          errorMessage += element + '\n';
        });
      });
      throw Exception(errorMessage);
    }
    // return token
    return response.body;


  }
  Future<String> updateMessage(String id , String message) async {
    String uri = baseUrl + 'seller/orders/$id';

    http.Response response = await http.put(Uri.parse(uri),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader :"Bearer $token"
      },
      body: jsonEncode({
        "data" : message
      })

    );


    if (response.statusCode == 422) {
      Map<String, dynamic> body = jsonDecode(response.body);
      Map<String, dynamic> errors = body['errors'];
      String errorMessage = '';
      errors.forEach((key, value) {
        value.forEach((element) {
          errorMessage += element + '\n';
        });
      });
      throw Exception(errorMessage);
    }
    // return token
    return response.body;


  }
}
