class TripHistoryModel {
  final String id;
  final String destination;
  final String cargo;
  final String status;
  final String startedAt;
  final String completedAt;

  TripHistoryModel({
    required this.id,
    required this.destination,
    required this.cargo,
    required this.status,
    required this.startedAt,
    required this.completedAt,
  });

  factory TripHistoryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final destination = json["destination"];
    final cargoType = json["cargoType"];

    return TripHistoryModel(
      id: json["id"] ?? json["_id"] ?? "",
      destination: destination is Map
          ? destination["name"] ?? ""
          : json["destinationName"] ?? "",
      cargo: cargoType is Map ? cargoType["name"] ?? "N/A" : "N/A",
      status: json["status"] ?? "",
      startedAt: json["startedAt"] ?? "",
      completedAt: json["completedAt"] ?? "",
    );
  }
}
