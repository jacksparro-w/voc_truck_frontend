class DriverModel {
  final String id;
  final String name;
  final String mobile;
  final bool isActive;

  DriverModel({
    required this.id,
    required this.name,
    required this.mobile,
    required this.isActive,
  });

  factory DriverModel.fromJson(
      Map<String, dynamic> json) {
    return DriverModel(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      mobile: json["mobile"] ?? "",
      isActive: json["isActive"] ?? false,
    );
  }
}