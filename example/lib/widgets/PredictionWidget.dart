import 'package:flutter/material.dart';
import '../datamodels/address.dart';
import '../datamodels/predictions.dart';
import '../dataprovider/appdata.dart';
import '../utils/request.dart';
import '../widgets/ProgressDialog.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import '../global_variables.dart' as globals;
import 'package:provider/provider.dart';
import '../brand_colors.dart';

// widget for displaying the predicted results
class PredictionWidget extends StatelessWidget {
  final Predictions predictions;

  PredictionWidget(this.predictions);

  void getPlaceDetails(String placeID, context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => ProgressDialog(status: 'Loading'));

    String url = 'https://maps.googleapis.com/maps/api/place/details/json?' +
        'place_id=$placeID' +
        '&' +
        'key=${globals.mapKey}';
    var response = await Request.getRequest(url);

    Navigator.pop(context);

    if (response == 'failed') {
      return;
    }

    //print(response);
    Address addr = Address();
    addr.placeName = response['result']['name'];
    addr.placeId = placeID;
    addr.latitude = response['result']['geometry']['location']['lat'];
    addr.longitude = response['result']['geometry']['location']['lng'];
    Provider.of<AppData>(context, listen: false).updateDestinationAddress(addr);
    //print(addr.placeName);

    Navigator.pop(context, 'routing');
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        getPlaceDetails(predictions.placeId, context);
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    predictions.mainText,
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    predictions.secondaryText,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.deepOrange,
                    ),
                  ),
                ],
              )
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
