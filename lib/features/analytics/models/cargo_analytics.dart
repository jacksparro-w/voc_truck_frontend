class CargoAnalytics {

  final String cargoType;

  final int tripCount;

  CargoAnalytics({
    required this.cargoType,
    required this.tripCount,
  });

  factory CargoAnalytics.fromJson(
    Map<String, dynamic> json,
  ) {

    return CargoAnalytics(
      cargoType:
          json["cargoType"] ?? "",

      tripCount:
          json["tripCount"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {

    return {
      "cargoType": cargoType,
      "tripCount": tripCount,
    };
  }
}