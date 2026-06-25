class LoginResponse {
  final String accessToken;
  final String role;
  final String name;
  final String userId;

  LoginResponse({
    required this.accessToken,
    required this.role,
    required this.name,
    required this.userId,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final data = json["data"] is Map
        ? Map<String, dynamic>.from(json["data"])
        : json;

    final user = data["user"] is Map
        ? Map<String, dynamic>.from(data["user"])
        : <String, dynamic>{};

    final tokens = data["tokens"] is Map
        ? Map<String, dynamic>.from(data["tokens"])
        : <String, dynamic>{};

    return LoginResponse(
      accessToken: tokens["accessToken"] ?? data["accessToken"] ?? "",
      role: user["role"] ?? data["role"] ?? "",
      name: user["name"] ?? data["name"] ?? "",
      userId: user["id"] ?? user["_id"] ?? data["userId"] ?? "",
    );
  }
}
