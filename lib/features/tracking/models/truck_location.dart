class TruckLocation {

  final String truckId;

  final String truckNumber;

  final double latitude;

  final double longitude;

  TruckLocation({
    required this.truckId,
    required this.truckNumber,
    required this.latitude,
    required this.longitude,
  });

  factory TruckLocation.fromJson(
      Map<String, dynamic> json) {

    return TruckLocation(
      truckId:
          json["truckId"],

      truckNumber:
          json["truckNumber"],

      latitude:
          json["latitude"]
              .toDouble(),

      longitude:
          json["longitude"]
              .toDouble(),
    );
  }
}