import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:my_first_app/data/models/toko.dart';

class DriverApiService {
  late String token;

  DriverApiService(String token) {
    this.token = token;
  }

  final String baseUrl = "http://10.0.2.2:5000/";


  Future<String> fetchFood(String userID , String token) async{
    http.Response response = await http.get(
      Uri.parse(baseUrl + 'shops/food/$userID'),
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
      Uri.parse(baseUrl + 'shops/drink/$userID'),
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
    String uri = baseUrl + 'drivers';
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
    String uri = baseUrl + 'driver/authentications';

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

  Future<String> registerShop(String nameShop , String addressShop , String noShop , String token) async {
    String uri = baseUrl + 'users/shops';


    http.Response response = await http.post(Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader :"Bearer $token"
        },
        body: jsonEncode({
          'name': nameShop,
          'address': addressShop,
          'no_phone': noShop,

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
  Future<int> check(String id , String token) async {
    String uri = baseUrl + 'users/shops/$id';

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
    return response.statusCode;
  }
  Future<String> getShop(String id , String token) async {
    String uri = baseUrl + 'users/shops/$id';

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
  Future<String> getOrder() async {
    String uri = baseUrl + 'order/drivers';

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
  Future<String> updateOrdersDriver(String id_Driver , String id_order) async {
    String uri = baseUrl + 'order/drivers/$id_order';

    http.Response response = await http.put(Uri.parse(uri),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader :"Bearer $token"
      },
      body: jsonEncode({
        "id_driver" : id_Driver
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
    print(response.body);
    return response.body;
  }

}
