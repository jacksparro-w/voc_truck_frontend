class CargoTypeModel {
  final String id;
  final String name;

  CargoTypeModel({
    required this.id,
    required this.name,
  });

  factory CargoTypeModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CargoTypeModel(
      id: json["id"] ?? json["_id"] ?? "",
      name: json["name"] ?? "",
    );
  }
}
