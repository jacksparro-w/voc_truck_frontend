import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';

class AlertService {

  Future<Response> getAlerts() async {

    return await DioClient.dio.get(
      "/alerts",
    );
  }
}