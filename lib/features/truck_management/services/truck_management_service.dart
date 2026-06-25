import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';

class TruckManagementService {
  Future<Response> getTrucks() async {
    return await DioClient.dio.get(
      "/trucks",
    );
  }

  Future<Response> createTruck(
    Map<String, dynamic> data,
  ) async {
    return await DioClient.dio.post(
      "/trucks",
      data: data,
    );
  }

  Future<Response> getDrivers() async {
    return await DioClient.dio.get(
      "/drivers",
    );
  }

  Future<Response> assignDriver({
    required String truckId,
    required String driverId,
  }) async {
    return await DioClient.dio.post(
      "/trucks/$truckId/assign-driver",
      data: {
        "driverId": driverId,
      },
    );
  }
}
