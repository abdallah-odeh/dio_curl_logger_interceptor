library dio_curl_logger_interceptor;

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

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

    components.addAll(_getData(options));

    return components.join(' \\\n\t');
  }

  List<String> _getData(RequestOptions options) {
    if (options.data == null) return const <String>[];

    final contentType = _getContentType(options);

    switch(contentType.toLowerCase()) {
      case 'application/json': //raw json
        return ['--data \'${options.data}\''];
      case 'application/x-www-form-urlencoded': // x-www-form-urlencoded
        return _getBody('data-urlencode', options.data);
      case 'multipart/form-data': //form-data
        return _getBody('form', options.data);
      default:
        debugPrint('Could not parse body of type $contentType');
    }
    return const <String>[];
  }

  List<String> _getBody(final String prefix, final dynamic data) {
    if (data == null) return const <String>[];
    final components = <String>[];
    if (data is FormData) {
      for (final field in data.fields) {
        components.add('--$prefix \'${field.key}="${field.value}"\'');
      }
      if (kDebugMode && data.files.isNotEmpty) {
        debugPrint('Form data files cannot be added to cURL');
      }
    } else if (data is Map) {
      for (final field in data.entries) {
        components.add('--$prefix \'${field.key}="${field.value}"\'');
      }
    } else if (kDebugMode) {
      debugPrint('Could not parse body of type ${data.runtimeType}');
    }
    return components;
  }

  String _getContentType(RequestOptions options) {
    final headers = options.headers;
    const key = 'content-type';
    for (final header in headers.entries) {
      if (header.key.toLowerCase() == key) {
        return header.value;
      }
    }
    return 'application/json';
  }
}
