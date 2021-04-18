import 'package:connectivity/connectivity.dart';
import '../datamodels/address.dart';
import '../datamodels/directiondetails.dart';
import '../dataprovider/appdata.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../global_variables.dart';
import './request.dart';
import 'package:provider/provider.dart';

class Utils {
  static Future<String> reverseGeocode(Position position, context) async {
    String placeAddress = '';

    var connectivityResult = await Connectivity().checkConnectivity();
    if ((connectivityResult != ConnectivityResult.mobile) &&
        (connectivityResult != ConnectivityResult.wifi)) {
      return placeAddress;
    }

    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey';
    var response = await Request.getRequest(url);
    if (response != 'failed') {
      placeAddress = response['results'][0]['formatted_address'];

      Address destination = new Address();
      destination.longitude = position.longitude;
      destination.latitude = position.latitude;
      destination.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false)
          .updateDestination(destination);
    }

    return placeAddress;
  }

  static Future<DirectionDetails> getDirectionDetails(
      LatLng startPos, LatLng endPos) async {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${startPos.latitude},${startPos.longitude}' +
            '&destination=${endPos.latitude},${endPos.longitude}&mode=driving&key=$mapKey';
    var response = await Request.getRequest(url);

    if (response == 'failed') {
      return null;
    }

    DirectionDetails dd = DirectionDetails();
    dd.durationText = response['routes'][0]['legs'][0]['duration']['text'];
    dd.durationValue = response['routes'][0]['legs'][0]['duration']['value'];
    dd.distanceText = response['routes'][0]['legs'][0]['distance']['text'];
    dd.distanceValue = response['routes'][0]['legs'][0]['distance']['value'];

    dd.encodedPoints = response['routes'][0]['overview_polyline']['points'];
    return dd;
  }

  static int estimatedCredits(DirectionDetails details) {
    double baseCredits = 3;
    double distanceCredits = details.distanceValue / 1000 * 0.3;
    double timeCredits = (details.durationValue / 60) * 0.2;
    double totalCredits = baseCredits + distanceCredits + timeCredits;
    return totalCredits.truncate();
  }
}
