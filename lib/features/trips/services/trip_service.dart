import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';

class TripService {
  Future<Response> getActiveTrip() async {
    return await DioClient.dio.get(
      "/trips/active",
    );
  }

  Future<Response> startTrip(
    Map<String, dynamic> data,
  ) async {
    return await DioClient.dio.post(
      "/trips/start",
      data: data,
    );
  }

  Future<Response> endTrip(
    String tripId,
  ) async {
    return await DioClient.dio.post(
      "/trips/$tripId/end",
    );
  }

  Future<Response> getHistory() async {
    return await DioClient.dio.get(
      "/trips/history",
    );
  }

  Future<Response> getCargoTypes() async {
    return await DioClient.dio.get(
      "/cargo",
    );
  }
}
