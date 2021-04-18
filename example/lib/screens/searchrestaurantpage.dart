import 'package:flutter/material.dart';
import '../brand_colors.dart';
import '../datamodels/restaurantinfo.dart';
import '../dataprovider/appdata.dart';
import '../global_variables.dart' as globals;
import '../utils/request.dart';
import '../widgets/BrandDivider.dart';
import '../widgets/RestaurantWidget.dart';
import 'package:provider/provider.dart';

class SearchRestaurantPage extends StatefulWidget {
  static const String id = 'searchrestaurantpage';

  @override
  _SearchRestaurantPageState createState() => _SearchRestaurantPageState();
}

class _SearchRestaurantPageState extends State<SearchRestaurantPage> {
  var pickupController = TextEditingController();
  var destinationController = TextEditingController();
  double _currentSliderValue = 2000;

  bool focused = false;

  List<RestaurantInfo> restaurantList = [];

  void searchPlace(String inputPlace) async {
    if (inputPlace.length > 1) {
      String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?' +
          'input=$inputPlace&key=${globals.mapKey}&sessiontoken=1234567890&components=country:us';
      var response = await Request.getRequest(url);
      if (response == 'failed') {
        return;
      }

      if (response['status'] == 'OK') {
        var restaurantJson = response['predictions'];
        var searchList = (restaurantJson as List)
            .map((e) => RestaurantInfo.fromJson(e))
            .toList();
        setState(() {
          restaurantList = searchList;
        });
      }

      // print(response);
    }
  }

  void searchRestaurantByLatLng(double latitude, double longitude) async {
    var restaurantJson = await Request.searchRestaurant(
        latitude, longitude, _currentSliderValue.toInt());

    var results = restaurantJson['results'] as List;

    List<String> tempNameList = [];
    List<RestaurantInfo> searchList = [];
    for (var r in results) {
      print(r);
      String c = r['cuisine'] as String;
      print(c);
      int d = r['distance'].toInt();
      print(d);
      String i = r['id'] as String;
      print(i);
      double lat = r['lat'];
      print(lat);
      double lon = r['lng'];
      print(lon);
      String n = r['name'] as String;
      print(n);
      tempNameList.add(n);
      String p = r['phone'] as String;
      print(p);
      int q = r['quantity'] as int;
      print(q);
      String ra = r['rating'] as String;

      RestaurantInfo ri = RestaurantInfo(
        cuisine: c,
        distance: d,
        id: i,
        lat: lat,
        lng: lon,
        name: n,
        phone: p,
        quantity: q,
        rating: ra,
      );

      searchList.add(ri);
    }
    // var searchList = (restaurantJson['results'] as List)
    //     .map((e) => RestaurantInfo.fromJson(e))
    //     .toList();
    // print('hello');
    setState(() {
      restaurantList = searchList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
          height: 220,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5.0,
                  spreadRadius: 0.5,
                  offset: Offset(
                    0.7,
                    0.7,
                  )),
            ],
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 24, top: 48, right: 24, bottom: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                Stack(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back)),
                    Center(
                      child: Text('Search Nearby',
                          style: TextStyle(
                              fontSize: 20, fontFamily: "Brand-Bold")),
                    ),
                  ],
                ),
                SizedBox(
                  height: 18,
                ),
                Row(
                  children: [
                    Image.asset(
                      'images/pickicon.png',
                      height: 16,
                      width: 16,
                    ),
                    SizedBox(
                      width: 18,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: BrandColors.colorGreen,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: TextField(
                            controller: pickupController,
                            decoration: InputDecoration(
                              hintText: globals.placeName,
                              fillColor: BrandColors.colorLightGrayFair,
                              filled: true,
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.only(left: 10, top: 8, bottom: 8),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        child: FlatButton(
                          onPressed: () {
                            searchRestaurantByLatLng(
                                Provider.of<AppData>(context, listen: false)
                                    .startAddress
                                    .latitude,
                                Provider.of<AppData>(context, listen: false)
                                    .startAddress
                                    .longitude);
                          },
                          child: Text(
                            'Search Restaurant',
                            style:
                                TextStyle(fontSize: 12, color: Colors.purple),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 18,
                    ),
                    Expanded(
                      child: Container(
                        width: 50,
                        height: 10,
                        child: Slider(
                          value: _currentSliderValue,
                          min: 0,
                          max: 10000,
                          divisions: 500,
                          label: _currentSliderValue.round().toString(),
                          onChanged: (double value) {
                            setState(() {
                              _currentSliderValue = value;
                            });
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        (restaurantList.length > 0)
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                child: ListView.separated(
                  padding: EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    print(restaurantList[index]);
                    return RestaurantWidget(
                      restaurantList[index],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      BrandDivider(),
                  itemCount: restaurantList.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                ),
              )
            : Container(),
      ],
    ));
  }
}
