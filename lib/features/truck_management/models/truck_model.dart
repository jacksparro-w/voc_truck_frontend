class TruckModel {
  final String id;
  final String truckNumber;
  final String truckType;
  final String status;
  final String? driverName;

  TruckModel({
    required this.id,
    required this.truckNumber,
    required this.truckType,
    required this.status,
    this.driverName,
  });

  factory TruckModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final driver = json["driver"];

    return TruckModel(
      id: json["id"] ?? json["_id"] ?? "",
      truckNumber: json["truckNumber"] ?? "",
      truckType: json["truckType"] ?? "",
      status: json["status"] ?? "",
      driverName: driver is Map
          ? driver["name"]
          : json["driverName"] ?? json["assignedDriverName"],
    );
  }
}
