import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';

class DestinationService {
  Future<Response> getDestinations({
    String? type,
  }) async {
    return await DioClient.dio.get(
      "/destinations",
      queryParameters: type == null
          ? null
          : {
              "type": type,
            },
    );
  }

  Future<Response> createDestination(
    Map<String, dynamic> data,
  ) async {
    return await DioClient.dio.post(
      "/destinations",
      data: data,
    );
  }
}
