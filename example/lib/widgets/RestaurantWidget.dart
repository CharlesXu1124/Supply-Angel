import 'package:flutter/material.dart';
import '../datamodels/address.dart';
import '../datamodels/predictions.dart';
import '../datamodels/restaurantinfo.dart';
import '../dataprovider/appdata.dart';
import '../utils/request.dart';
import '../widgets/ProgressDialog.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import '../global_variables.dart' as globals;
import 'package:provider/provider.dart';
import '../brand_colors.dart';

// widget for displaying the predicted results
class RestaurantWidget extends StatelessWidget {
  final RestaurantInfo restaurantInfo;

  RestaurantWidget(this.restaurantInfo);

  Color getColor(String rating) {
    double ra = double.parse(rating);
    if (ra > 4.2) {
      return Colors.red;
    } else if (ra > 4.0) {
      return Colors.orange;
    } else if (ra > 3.0) {
      return Colors.green;
    } else {
      return Colors.indigo;
    }
  }

  void getPlaceDetails(context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => ProgressDialog(status: 'Loading'));

    Navigator.pop(context);

    Address addr = Address();
    addr.placeName = restaurantInfo.name;
    addr.placeId = restaurantInfo.id;
    addr.latitude = restaurantInfo.lat;
    addr.longitude = restaurantInfo.lng;
    Provider.of<AppData>(context, listen: false).updateDestinationAddress(addr);
    Provider.of<AppData>(context, listen: false)
        .updateRestaurantID(restaurantInfo.id);

    //print(addr.placeName);

    Navigator.pop(context, 'routing');
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        getPlaceDetails(context);
      },
      padding: EdgeInsets.all(0),
      child: Container(
        child: Column(children: [
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Icon(
                OMIcons.locationOn,
                color: BrandColors.colorGreen,
              ),
              SizedBox(
                width: 12,
              ),
              Container(
                width: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurantInfo.name,
                      overflow: TextOverflow.clip,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      restaurantInfo.cuisine,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.favorite,
                color: getColor(restaurantInfo.rating),
                size: 24.0,
                semanticLabel: 'Text to announce in accessibility modes',
              ),
              SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        '${restaurantInfo.rating}',
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontSize: 10,
                          color: getColor(restaurantInfo.rating),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 32,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        '${restaurantInfo.distance.toString()} meters away',
                        overflow: TextOverflow.clip,
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
        ]),
      ),
    );
  }
}
