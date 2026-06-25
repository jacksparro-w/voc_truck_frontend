import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';

class TrackingService {

  Future<Response>
      getLiveLocations() async {

    return await DioClient.dio.get(
      "/dashboard/live-map",
    );
  }
}