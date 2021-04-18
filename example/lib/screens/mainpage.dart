import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_unity_widget_example/screens/menu_screen.dart';
//import 'menu_screen.dart';
//import 'package:flutter_unity_widget_example/screens/simple_screen.dart';
import '../brand_colors.dart';
import '../datamodels/directiondetails.dart';
import '../dataprovider/appdata.dart';
//import 'deliveryarpage.dart';
import '../screens/searchpage.dart';
import '../screens/searchrestaurantpage.dart';
import '../utils/request.dart';
import '../utils/utils.dart';
import '../widgets/FoodDBButton.dart';
import '../widgets/ProgressDialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../styles/styles.dart';
import '../widgets/BrandDivider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'dart:io';
import '../global_variables.dart' as globals;

import 'dart:io' show Platform;

import 'deliveryunitypage.dart';

class MainPage extends StatefulWidget {
  static const String id = 'mainpage';
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  // polyline variables
  List<LatLng> routingCoords = [];
  Set<Polyline> polylines = {};
  Set<Marker> markers = {};
  Set<Circle> circles = {};

  Color orderStatusColor = BrandColors.colorBlue;
  String orderstatus = 'Place Order';

  bool hasOrderPlaced = false;

  // text to speech variables
  FlutterTts flutterTts = FlutterTts();

  Future _speak(String sentence) async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1.0);

    var _ = await flutterTts.speak(sentence);
  }

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  double searchSheetHeight = (Platform.isIOS) ? 300 : 275;
  double deliveryDetailSheetHeight = 0;

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  double mapBottomPadding = 0;

  String textAddress = "add your home";

  var geoLocator = Geolocator();

  DirectionDetails tripDirectionDetails;

  bool drawCanOpen = true;

  Position currentPosition;

  void setupPositionLocator() async {
    // LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    Position positionMockUp =
        Position(latitude: 47.608013, longitude: -122.335167);
    currentPosition = positionMockUp;

    LatLng pos = LatLng(positionMockUp.latitude, positionMockUp.longitude);

    currentPosition = positionMockUp;
    CameraPosition cp = new CameraPosition(target: pos, zoom: 14);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cp));

    textAddress = await Utils.reverseGeocode(positionMockUp, context);
    // set the global variable
    globals.placeName = textAddress;
    //this.build(context);
    print(textAddress);
  }

  void getCurrentAddress(double lat, double lon) async {
    LatLng pos = LatLng(lat, lon);
    Position tappedPos = new Position(latitude: lat, longitude: lon);
    CameraPosition cp = new CameraPosition(target: pos, zoom: 14);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cp));

    textAddress = await Utils.reverseGeocode(tappedPos, context);
    // set the global variable
    globals.placeName = textAddress;

    // this.build(context);
    print(textAddress);
  }

  void showDeliverySheet() async {
    await getDirection();
    setState(() {
      searchSheetHeight = 0;
      deliveryDetailSheetHeight = (Platform.isAndroid) ? 235 : 260;
      mapBottomPadding = (Platform.isAndroid) ? 240 : 230;
      drawCanOpen = false;
    });
  }

  void requestFood() async {
    String rID = Provider.of<AppData>(context, listen: false).rID;

    Request.placeOrder(1, rID, context).then((var result) {
      var res = result['success'];
      if (res) {
        setState(() {
          orderstatus = 'Order Placed';
          orderStatusColor = BrandColors.colorOrange;
          print(res);
          hasOrderPlaced = true;
          _speak('order placed');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Container(
          width: 250,
          color: Colors.purple,
          child: Drawer(
              child: ListView(
            padding: EdgeInsets.all(0),
            children: <Widget>[
              Container(
                color: Colors.white,
                height: 160,
                child: DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          'images/user_icon.png',
                          height: 60,
                          width: 60,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              Provider.of<AppData>(context, listen: false)
                                  .cus_name,
                              style: TextStyle(
                                  fontSize: 20, fontFamily: 'Brand-Bold'),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text('View Profile'),
                          ],
                        )
                      ],
                    )),
              ),
              BrandDivider(),
              SizedBox(
                height: 10,
              ),
              ListTile(
                leading: Icon(OMIcons.cardGiftcard),
                title: Text('Free Foods', style: standardStyle),
              ),
              ListTile(
                leading: Icon(OMIcons.creditCard),
                title: Text('Credit history', style: standardStyle),
              ),
              ListTile(
                leading: Icon(OMIcons.history),
                title: Text('Ride History', style: standardStyle),
              ),
              TextButton(
                onPressed: () => {
                  Navigator.pushNamedAndRemoveUntil(
                      context, UnityView.pid, (route) => false)
                },
                child: ListTile(
                  leading: Icon(OMIcons.contactSupport),
                  title: Text('Unity', style: standardStyle),
                ),
              ),
              TextButton(
                onPressed: () => {
                  Navigator.pushNamedAndRemoveUntil(
                      context, MenuScreen.id, (route) => false)
                },
                child: ListTile(
                  leading: Icon(OMIcons.info),
                  title: Text('See Delivery', style: standardStyle),
                ),
              ),
            ],
          ))),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            markers: markers,
            circles: circles,
            onLongPress: (ll) {
              //print('${ll.latitude}');
              globals.latitude = ll.latitude;
              globals.longitude = ll.longitude;
              getCurrentAddress(ll.latitude, ll.longitude);
              _speak('location updated');
            },
            polylines: polylines,
            padding: EdgeInsets.only(bottom: mapBottomPadding),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: globals.googlePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);

              mapController = controller;
              setState(() {
                mapBottomPadding = (Platform.isAndroid) ? 280 : 270;
              });

              setupPositionLocator();
              setState(() {
                mapBottomPadding = (Platform.isAndroid) ? 280 : 270;
              });
            },
          ),

          /// Menu button
          Positioned(
            top: 44,
            left: 20,
            child: GestureDetector(
              onTap: () {
                if (drawCanOpen) {
                  scaffoldKey.currentState.openDrawer();
                } else {
                  resetApp();
                }
              },
              child: Container(
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Icon(
                    (drawCanOpen) ? Icons.menu : Icons.arrow_back,
                    color: Colors.black87,
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5.0,
                        spreadRadius: 0.5,
                        offset: Offset(
                          0.7,
                          0.7,
                        ),
                      ),
                    ]),
              ),
            ),
          ),

          /// Search sheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSize(
              vsync: this,
              duration: new Duration(milliseconds: 150),
              curve: Curves.easeIn,
              child: Container(
                height: searchSheetHeight,
                decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 15.0,
                        spreadRadius: 0.5,
                        offset: Offset(
                          0.7,
                          0.7,
                        ),
                      )
                    ]),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Nice to see you!',
                        style: TextStyle(fontSize: 10),
                      ),
                      Text(
                        'Welcome to FoodDonationDB',
                        style:
                            TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () async {
                          var response = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchPage()));
                          if (response == 'routing') {
                            hasOrderPlaced = false;
                            orderStatusColor = Colors.amber;
                            showDeliverySheet();
                          }
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 5.0,
                                      spreadRadius: 0.5,
                                      offset: Offset(
                                        0.7,
                                        0.7,
                                      )),
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.search,
                                    color: Colors.blueAccent,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('Search Destination'),
                                ],
                              ),
                            )),
                      ),
                      SizedBox(height: 5),
                      GestureDetector(
                        onTap: () async {
                          var response = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SearchRestaurantPage()));
                          if (response == 'routing') {
                            showDeliverySheet();
                          }
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 5.0,
                                      spreadRadius: 0.5,
                                      offset: Offset(
                                        0.7,
                                        0.7,
                                      )),
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.search,
                                    color: Colors.blueAccent,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('Search Restaurants'),
                                ],
                              ),
                            )),
                      ),
                      SizedBox(height: 22),
                      Row(
                        children: <Widget>[
                          Icon(OMIcons.home, color: BrandColors.colorDimText),
                          SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(textAddress),
                              SizedBox(height: 3),
                              Text(
                                'Your residential address',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: BrandColors.colorDimText,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      BrandDivider(),
                      Row(
                        children: <Widget>[
                          Icon(OMIcons.workOutline,
                              color: BrandColors.colorDimText),
                          SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Add work'),
                              SizedBox(height: 3),
                              Text(
                                'Your temporary address',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: BrandColors.colorDimText,
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),

          /// Delivery sheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSize(
              vsync: this,
              duration: new Duration(milliseconds: 150),
              curve: Curves.easeIn,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 15.0,
                        color: Colors.black26,
                        spreadRadius: 0.5,
                        offset: Offset(
                          0.7,
                          0.7,
                        ),
                      ),
                    ]),
                height: deliveryDetailSheetHeight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        color: BrandColors.colorAccent1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Image.asset('images/food.png',
                                  height: 70, width: 70),
                              SizedBox(
                                width: 16,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Delivery Pending',
                                    style: TextStyle(
                                        fontSize: 18, fontFamily: 'Brand-Bold'),
                                  ),
                                  Text(
                                    (tripDirectionDetails != null)
                                        ? tripDirectionDetails.distanceText
                                        : '',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Brand-Bold',
                                        color: BrandColors.colorTextLight),
                                  ),
                                ],
                              ),
                              Expanded(child: Container()),
                              Text(
                                '\$${(tripDirectionDetails != null) ? Utils.estimatedCredits(tripDirectionDetails) : ''}',
                                style: TextStyle(
                                    fontSize: 18, fontFamily: 'Brand-Bold'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 22,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [],
                        ),
                      ),
                      SizedBox(
                        height: 22,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: FoodDBButton(
                          title: orderstatus,
                          color: orderStatusColor,
                          onPressed: () {
                            requestFood();
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Visibility(
                          visible: hasOrderPlaced,
                          child: Icon(
                            Icons.check_box,
                            color: Colors.green,
                            size: 30.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> getDirection() async {
    var startAddr = Provider.of<AppData>(context, listen: false).startAddress;
    var endAddr =
        Provider.of<AppData>(context, listen: false).destinationAddress;

    var startLatlng = LatLng(startAddr.latitude, startAddr.longitude);
    var endLatlng = LatLng(endAddr.latitude, endAddr.longitude);

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => ProgressDialog(
              status: 'routing, please wait',
            ));

    var details = await Utils.getDirectionDetails(startLatlng, endLatlng);

    setState(() {
      tripDirectionDetails = details;
    });

    Navigator.pop(context);
    PolylinePoints pp = PolylinePoints();
    List<PointLatLng> res = pp.decodePolyline(details.encodedPoints);

    routingCoords.clear();
    if (res.isNotEmpty) {
      res.forEach((PointLatLng point) {
        routingCoords.add(LatLng(point.latitude, point.longitude));
      });
    }

    polylines.clear();

    setState(() {
      Polyline pl = Polyline(
        polylineId: PolylineId('polyid'),
        color: Color.fromARGB(255, 95, 109, 237),
        points: routingCoords,
        jointType: JointType.round,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polylines.add(pl);
    });

    LatLngBounds bounds;

    var minLat = (startLatlng.latitude > endLatlng.latitude)
        ? endLatlng.latitude
        : startLatlng.latitude;

    var minLon = (startLatlng.longitude > endLatlng.longitude)
        ? endLatlng.longitude
        : startLatlng.longitude;

    var maxLat = (startLatlng.latitude < endLatlng.latitude)
        ? endLatlng.latitude
        : startLatlng.latitude;

    var maxLon = (startLatlng.longitude < endLatlng.longitude)
        ? endLatlng.longitude
        : startLatlng.longitude;

    bounds = LatLngBounds(
        southwest: LatLng(minLat, minLon), northeast: LatLng(maxLat, maxLon));

    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));

    Marker startMarker = Marker(
      markerId: MarkerId('start'),
      position: startLatlng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
      infoWindow:
          InfoWindow(title: startAddr.placeName, snippet: "Your location"),
    );

    Marker endMarker = Marker(
      markerId: MarkerId('end'),
      position: endLatlng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      infoWindow: InfoWindow(title: endAddr.placeName, snippet: "Destination"),
    );

    setState(() {
      markers.add(startMarker);
      markers.add(endMarker);
    });

    Circle startCircle = Circle(
      circleId: CircleId('start'),
      strokeColor: Colors.green,
      strokeWidth: 3,
      radius: 12,
      center: startLatlng,
      fillColor: Colors.green,
    );

    Circle endCircle = Circle(
      circleId: CircleId('destination'),
      strokeColor: BrandColors.colorAccentPurple,
      strokeWidth: 3,
      radius: 12,
      center: endLatlng,
      fillColor: BrandColors.colorGreen,
    );

    setState(() {
      circles.add(startCircle);
      circles.add(endCircle);
    });
  }

  resetApp() {
    setState(() {
      hasOrderPlaced = false;
      orderStatusColor = Colors.green;
      routingCoords.clear();
      polylines.clear();
      markers.clear();
      circles.clear();
      deliveryDetailSheetHeight = 0;
      searchSheetHeight = (Platform.isAndroid) ? 275 : 300;
      mapBottomPadding = (Platform.isAndroid) ? 280 : 270;
      drawCanOpen = true;

      setupPositionLocator();
    });
  }
}
