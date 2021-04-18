class RestaurantInfo {
  String cuisine;
  int distance;
  String id;
  double lat;
  double lng;
  String name;
  String phone;
  int quantity;
  String rating;

  RestaurantInfo({
    this.cuisine,
    this.distance,
    this.id,
    this.lat,
    this.lng,
    this.name,
    this.phone,
    this.quantity,
    this.rating,
  });

  RestaurantInfo.fromJson(Map<String, dynamic> json) {
    cuisine = json['cuisine'];
    distance = json['distance'];
    id = json['id'];
    lat = json['lat'];
    lng = json['lng'];
    name = json['name'];
    phone = json['phone'];
    quantity = json['quantity'];
    rating = json['rating'];
  }
}
