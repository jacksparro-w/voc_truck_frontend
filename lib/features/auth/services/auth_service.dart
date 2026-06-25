import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';

class AuthService {
  Future<Response> login(String mobile, String password) async {
    return await DioClient.dio.post(
      "auth/login",
      data: {"mobile": mobile, "password": password},
    );
  }

  Future<Response> getProfile() async {
    return await DioClient.dio.get("auth/me");
  }
}
