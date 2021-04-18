import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../datamodels/address.dart';
import '../datamodels/directiondetails.dart';

class AppData extends ChangeNotifier {
  Address startAddress;

  Address destinationAddress;

  String cus_id;
  String cus_name;

  String rID;

  void updateDestination(Address pickup) {
    startAddress = pickup;
    notifyListeners();
  }

  void updateDestinationAddress(Address destination) {
    destinationAddress = destination;
    notifyListeners();
  }

  void updateCustomerID(String id) {
    cus_id = id;
    notifyListeners();
  }

  void updateRestaurantID(String id) {
    rID = id;
    notifyListeners();
  }

  void updateCustomerName(String name) {
    cus_name = name;
    notifyListeners();
  }
}
