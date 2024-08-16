library dio_curl_logger_interceptor;

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

class DioCurlLoggerInterceptor extends Interceptor {
  const DioCurlLoggerInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _renderCurlRepresentation(options);

    super.onRequest(options, handler);
  }

  void _renderCurlRepresentation(RequestOptions requestOptions) {
    // add a breakpoint here so all errors can break
    try {
      log(_cURLRepresentation(requestOptions));
    } catch (err) {
      log('unable to create a CURL representation of the requestOptions');
    }
  }

  String _cURLRepresentation(RequestOptions options) {
    List<String> components = [
      'curl --location --request ${options.method} \'${options.uri.toString()}\''
    ];

    options.headers.forEach((k, v) {
      if (k != 'Cookie') {
        components.add('--header \'$k: $v\'');
      }
    });

    if (options.data != null) {
      // FormData can't be JSON-serialized, so keep only their fields attributes
      if (options.data is FormData) {
        for (final field in options.data.fields) {
          components.add('--form \'${field.key}="${field.value}"\'');
        }
      } else {
        final data = json.encode(options.data).replaceAll('"', '\\"');
        components.add('-d "$data"');
      }
    }

    return components.join(' \\\n\t');
  }
}
