import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';

class DriverService {

  Future<Response>
      getActiveTrip() async {

    return await DioClient.dio.get(
      "/trips/active",
    );
  }
}