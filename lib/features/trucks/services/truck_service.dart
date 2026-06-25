import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';

class TruckService {

  Future<Response>
      getTruckMonitoring() async {

    return await DioClient.dio.get(
      "/dashboard/truck-monitoring",
    );
  }
}