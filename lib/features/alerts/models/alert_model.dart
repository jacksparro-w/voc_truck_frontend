class AlertModel {

  final String id;

  final String title;

  final String message;

  final String type;

  final String severity;

  final bool isResolved;

  final String createdAt;

  AlertModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.severity,
    required this.isResolved,
    required this.createdAt,
  });

  factory AlertModel.fromJson(
      Map<String, dynamic> json) {

    return AlertModel(
      id: json["id"] ?? "",

      title: json["title"] ?? "",

      message: json["message"] ?? "",

      type: json["type"] ?? "",

      severity: json["severity"] ?? "",

      isResolved:
          json["isResolved"] ?? false,

      createdAt:
          json["createdAt"] ?? "",
    );
  }
}