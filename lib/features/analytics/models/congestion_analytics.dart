class CongestionAnalytics {

  final String hotspot;

  final int truckCount;

  final double latitude;

  final double longitude;

  CongestionAnalytics({
    required this.hotspot,
    required this.truckCount,
    required this.latitude,
    required this.longitude,
  });

  factory CongestionAnalytics.fromJson(
    Map<String, dynamic> json,
  ) {

    return CongestionAnalytics(
      hotspot:
          json["hotspot"] ?? "",

      truckCount:
          json["truckCount"] ?? 0,

      latitude:
          (json["latitude"] ?? 0)
              .toDouble(),

      longitude:
          (json["longitude"] ?? 0)
              .toDouble(),
    );
  }

  Map<String, dynamic> toJson() {

    return {
      "hotspot": hotspot,
      "truckCount": truckCount,
      "latitude": latitude,
      "longitude": longitude,
    };
  }
}