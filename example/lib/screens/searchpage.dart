import 'package:flutter/material.dart';
import '../brand_colors.dart';
import '../datamodels/predictions.dart';
import '../global_variables.dart' as globals;
import '../utils/request.dart';
import '../utils/utils.dart';
import '../widgets/BrandDivider.dart';
import '../widgets/PredictionWidget.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var pickupController = TextEditingController();
  var destinationController = TextEditingController();

  bool focused = false;

  List<Predictions> destinationPredictionList = [];

  void searchPlace(String inputPlace) async {
    if (inputPlace.length > 1) {
      String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?' +
          'input=$inputPlace&key=${globals.mapKey}&sessiontoken=1234567890&components=country:us';
      var response = await Request.getRequest(url);
      if (response == 'failed') {
        return;
      }

      if (response['status'] == 'OK') {
        var predictionJson = response['predictions'];
        var predictionList = (predictionJson as List)
            .map((e) => Predictions.fromJson(e))
            .toList();
        setState(() {
          destinationPredictionList = predictionList;
        });
      }

      // print(response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
          height: 210,
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
                      child: Text('Set Destination',
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
                          color: BrandColors.colorOrange,
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
                    Image.asset(
                      'images/desticon.png',
                      height: 16,
                      width: 16,
                    ),
                    SizedBox(
                      width: 18,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: BrandColors.colorOrange,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: TextField(
                            onChanged: (val) {
                              searchPlace(val);
                            },
                            controller: destinationController,
                            decoration: InputDecoration(
                              hintText: 'Where to',
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
              ],
            ),
          ),
        ),
        (destinationPredictionList.length > 0)
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                child: ListView.separated(
                  padding: EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    return PredictionWidget(
                      destinationPredictionList[index],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      BrandDivider(),
                  itemCount: destinationPredictionList.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                ),
              )
            : Container(),
      ],
    ));
  }
}
