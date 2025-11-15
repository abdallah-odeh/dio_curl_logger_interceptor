import 'package:dio/dio.dart';
import 'package:dio_curl_logger_interceptor/dio_curl_logger_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('adds one to input values', () async {
    final Dio dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );
    dio.interceptors.add(const DioCurlLoggerInterceptor());

    final result = await dio.post(
      'https://example.com',
      options: Options(
        headers: {'content-type': 'application/json'},
      ),
      data: {'key': 'value'},
    );

    print('RESULT: ${result.statusCode}');
  });
}
