import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';

class DriverManagementService {

  Future<Response> createDriver(
      Map<String, dynamic> data) async {

    return await DioClient.dio.post(
      "/auth/create-user",
      data: data,
    );
  }

  Future<Response> getDrivers() async {

    return await DioClient.dio.get(
      "/drivers",
    );
  }

  Future<Response> updateStatus(
    String driverId,
    bool isActive,
  ) async {

    return await DioClient.dio.put(
      "/drivers/$driverId/status",
      data: {
        "isActive": isActive,
      },
    );
  }
}