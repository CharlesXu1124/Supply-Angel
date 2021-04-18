library fooddonationdb.globals;

import 'package:google_maps_flutter/google_maps_flutter.dart';

String mapKey = 'AIzaSyDv1FvrAo0oig-UNBHBPOdpxeCYCc5-gCc';
double latitude = 0.0;
double longitude = 0.0;
String placeName = 'Add your location';

final CameraPosition googlePlex = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);
