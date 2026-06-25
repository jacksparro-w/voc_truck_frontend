class DriverDropdownModel {
  final String id;
  final String name;

  DriverDropdownModel({
    required this.id,
    required this.name,
  });

  factory DriverDropdownModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DriverDropdownModel(
      id: json["id"] ?? json["_id"] ?? "",
      name: json["name"] ?? "",
    );
  }
}
