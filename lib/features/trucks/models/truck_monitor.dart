class TruckMonitor {

  final String truckNumber;

  final String driverName;

  final String status;

  final String cargo;

  final String destination;

  final String tripStatus;

  TruckMonitor({
    required this.truckNumber,
    required this.driverName,
    required this.status,
    required this.cargo,
    required this.destination,
    required this.tripStatus,
  });

  factory TruckMonitor.fromJson(
      Map<String, dynamic> json) {

    return TruckMonitor(
      truckNumber:
          json["truckNumber"] ?? "",

      driverName:
          json["driverName"] ?? "",

      status:
          json["status"] ?? "",

      cargo:
          json["cargo"] ?? "",

      destination:
          json["destination"] ?? "",

      tripStatus:
          json["tripStatus"] ?? "",
    );
  }
}