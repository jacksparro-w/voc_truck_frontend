import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../storage/secure_storage.dart';

class DioClient {

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl:
          ApiConstants.baseUrl,
    ),
  )
    ..interceptors.add(
      InterceptorsWrapper(

        onRequest:
            (options, handler)
                async {

          final token =
              await SecureStorage
                  .getToken();

          if (token != null) {

            options.headers[
                    "Authorization"] =
                "Bearer $token";
          }

          handler.next(
              options);
        },
      ),
    );
}