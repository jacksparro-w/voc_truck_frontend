class DestinationModel {
  final String id;
  final String name;
  final String type;
  final double latitude;
  final double longitude;
  final int radius;

  DestinationModel({
    required this.id,
    required this.name,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.radius,
  });

  factory DestinationModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DestinationModel(
      id: json["id"] ?? json["_id"] ?? "",
      name: json["name"] ?? "",
      type: json["type"] ?? "",
      latitude: _toDouble(
        json["latitude"],
      ),
      longitude: _toDouble(
        json["longitude"],
      ),
      radius: _toInt(
        json["radius"],
      ),
    );
  }

  static double _toDouble(
    dynamic value,
  ) {
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

  static int _toInt(
    dynamic value,
  ) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value) ?? 0;
    }

    return 0;
  }
}
