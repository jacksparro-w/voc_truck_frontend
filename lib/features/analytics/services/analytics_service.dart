import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';

class AnalyticsService {

  Future<Response>
      getCargoAnalytics() async {

    return DioClient.dio.get(
      "/dashboard/analytics/cargo",
    );
  }

  Future<Response>
      getViolationAnalytics() async {

    return DioClient.dio.get(
      "/dashboard/analytics/violations",
    );
  }

  Future<Response>
      getCongestionAnalytics() async {

    return DioClient.dio.get(
      "/dashboard/analytics/congestion",
    );
  }
}