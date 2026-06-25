class LocationModel {
  final double latitude;
  final double longitude;
  final double speed;
  final double heading;

  LocationModel({
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.heading,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: _toDouble(json["latitude"]),
      longitude: _toDouble(json["longitude"]),
      speed: _toDouble(json["speed"]),
      heading: _toDouble(json["heading"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "latitude": latitude,
      "longitude": longitude,
      "speed": speed,
      "heading": heading,
    };
  }

  static double _toDouble(dynamic value) {
    if (value is double) {
      return value;
    }

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value) ?? 0;
    }

    return 0;
  }
}
