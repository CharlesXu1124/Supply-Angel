class UserInfo {
  String cusId;
  String cusName;

  UserInfo({this.cusId, this.cusName});

  Map<String, dynamic> _toMap() {
    return {
      'cusId': cusId,
      'cusnName': cusName,
    };
  }

  dynamic get(String propertyName) {
    var _mapRep = _toMap();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('propery not found');
  }
}
