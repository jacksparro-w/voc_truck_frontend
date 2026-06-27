import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';

class CargoTypeService {
  Future<Response> getCargoTypes() async {
    return await DioClient.dio.get(
      "/cargo",
    );
  }

  Future<Response> createCargoType(
    Map<String, dynamic> data,
  ) async {
    return await DioClient.dio.post(
      "/cargo",
      data: data,
    );
  }
}
