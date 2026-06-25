import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';

class DashboardService {

  Future<Response> getSummary() async {

    return await DioClient.dio.get(
      "/dashboard/summary",
    );
  }
}