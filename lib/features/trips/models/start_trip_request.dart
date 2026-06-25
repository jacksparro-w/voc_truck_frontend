class StartTripRequest {
  final String truckId;
  final String cargoStatus;
  final String cargoTypeId;
  final String destinationId;

  StartTripRequest({
    required this.truckId,
    required this.cargoStatus,
    required this.cargoTypeId,
    required this.destinationId,
  });

  Map<String, dynamic> toJson() {
    return {
      "truckId": truckId,
      "cargoStatus": cargoStatus,
      "cargoTypeId": cargoTypeId,
      "destinationId": destinationId,
    };
  }
}
