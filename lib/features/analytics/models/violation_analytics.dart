class ViolationAnalytics {

  final String truckNumber;

  final int violationCount;

  ViolationAnalytics({
    required this.truckNumber,
    required this.violationCount,
  });

  factory ViolationAnalytics.fromJson(
    Map<String, dynamic> json,
  ) {

    return ViolationAnalytics(
      truckNumber:
          json["truckNumber"] ?? "",

      violationCount:
          json["violationCount"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {

    return {
      "truckNumber": truckNumber,
      "violationCount": violationCount,
    };
  }
}