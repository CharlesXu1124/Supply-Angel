import 'dart:convert';

import '../dataprovider/appdata.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Request {
  static Future<dynamic> getRequest(String url) async {
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);
        return decodedData;
      } else {
        return "failed";
      }
    } catch (e) {
      return "failed";
    }
  }

// function for client registration
  static Future<dynamic> register(
      String name, String email, String phone, String password) async {
    String url = 'http://fooddonationdb.westus2.cloudapp.azure.com:5000/signup';

    try {
      var response = await http.post(
        url,
        body: json.encode({
          'cust_name': name,
          'cust_email': email,
          'cust_phone': phone,
          'credential': password,
        }),
        headers: {"Content-Type": "application/json"},
      );

      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse.body);
      if (jsonResponse.body['success'] == true) {
        return "success";
      } else {
        return 'failed';
      }
    } catch (e) {
      return 'failed';
    }
  }

  static Future<dynamic> login(String email, String password) async {
    String url = 'http://fooddonationdb.westus2.cloudapp.azure.com:5000/login';
    try {
      var response = await http.post(
        url,
        body: json.encode({
          "email": email,
          "password": password,
        }),
        headers: {"Content-Type": "application/json"},
      );
      return jsonDecode(response.body);
    } catch (e) {
      return ['failed'];
    }
  }

  static Future<dynamic> searchRestaurant(
      double latitude, double longitude, int radius) async {
    String url =
        'http://fooddonationdb.westus2.cloudapp.azure.com:5000/searchRestaurantByLatLngv2';
    try {
      var response = await http.post(
        url,
        body: json.encode(
            {"latitude": latitude, "longitude": longitude, "radius": radius}),
        headers: {"Content-Type": "application/json"},
      );

      String data = response.body;
      // print(jsonDecode(response.body));
      return jsonDecode(data);
    } catch (e) {
      return ['failed'];
    }
  }

  static Future<dynamic> placeOrder(int order_qty, String rID, context) async {
    String url =
        'http://fooddonationdb.westus2.cloudapp.azure.com:5000/placeOrderWithTrigger';
    String cust_id = Provider.of<AppData>(context, listen: false).cus_id;
    try {
      var response = await http.post(
        url,
        body: json.encode(
            {"order_quantity": order_qty, "cust_id": cust_id, "rID": rID}),
        headers: {"Content-Type": "application/json"},
      );

      var result = jsonDecode(response.body);
      return result;
    } catch (e) {
      return ['failed'];
    }
  }
}
