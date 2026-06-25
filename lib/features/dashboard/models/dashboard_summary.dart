class DashboardSummary {

  final int totalTrucks;
  final int activeTrips;
  final int alerts;
  final int congestionEvents;

  DashboardSummary({
    required this.totalTrucks,
    required this.activeTrips,
    required this.alerts,
    required this.congestionEvents,
  });

  factory DashboardSummary.fromJson(
      Map<String, dynamic> json) {

    return DashboardSummary(
      totalTrucks:
          _toInt(
        json["totalTrucks"],
      ),

      activeTrips:
          _toInt(
        json["activeTrips"],
      ),

      alerts:
          _toInt(
        json["alerts"],
      ),

      congestionEvents:
          _toInt(
        json["congestionEvents"],
      ),
    );
  }

  static int _toInt(dynamic value) {
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
