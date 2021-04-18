class Predictions {
  String placeId;
  String mainText;
  String secondaryText;

  Predictions({this.placeId, this.mainText, this.secondaryText});

  Predictions.fromJson(Map<String, dynamic> json) {
    placeId = json['place_id'];
    mainText = json['structured_formatting']['main_text'];
    secondaryText = json['structured_formatting']['secondary_text'];
    
  }
}
