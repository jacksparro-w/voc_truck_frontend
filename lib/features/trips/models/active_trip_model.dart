class ActiveTripModel {
  final String tripId;
  final String truckNumber;
  final String destination;
  final String cargoType;
  final String cargoStatus;
  final String tripStatus;

  ActiveTripModel({
    required this.tripId,
    required this.truckNumber,
    required this.destination,
    required this.cargoType,
    required this.cargoStatus,
    required this.tripStatus,
  });

  factory ActiveTripModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final truck = json["truck"];
    final destination = json["destination"];
    final cargoType = json["cargoType"];

    return ActiveTripModel(
      tripId: json["id"] ?? json["_id"] ?? "",
      truckNumber: truck is Map
          ? truck["truckNumber"] ?? ""
          : json["truckNumber"] ?? "",
      destination: destination is Map
          ? destination["name"] ?? ""
          : json["destinationName"] ?? "",
      cargoType: cargoType is Map
          ? cargoType["name"] ?? "N/A"
          : json["cargoTypeName"] ?? "N/A",
      cargoStatus: json["cargoStatus"] ?? "",
      tripStatus: json["status"] ?? "",
    );
  }
}
