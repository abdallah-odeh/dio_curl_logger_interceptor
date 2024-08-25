This package helps in debugging API requests using dio HTTP networking package

[![pub version](https://img.shields.io/pub/v/dio_curl_logger_interceptor?logo=dart&labelColor=1B2C7A&color=BABAB2)](https://pub.dev/packages/dio_curl_logger_interceptor)
[![pub likes](https://img.shields.io/pub/likes/dio_curl_logger_interceptor?logo=dart&labelColor=1B2C7A&color=BABAB2)](https://pub.dev/packages/dio_curl_logger_interceptor)
[![GitHub Issues or Pull Requests](https://img.shields.io/github/issues/abdallah-odeh/dio_curl_logger_interceptor?logo=github&labelColor=1B2C7A&color=BABAB2)](https://github.com/abdallah-odeh/dio_curl_logger_interceptor/issues?q=is%3Aissue+is%3Aopen+)
[![GitHub Issues or Pull Requests](https://img.shields.io/github/issues-closed/abdallah-odeh/dio_curl_logger_interceptor?logo=github&labelColor=1B2C7A&color=BABAB2)](https://github.com/abdallah-odeh/dio_curl_logger_interceptor/issues?q=is%3Aissue+is%3Aclosed+)

## Features

- Works with app requests types (GET, POST, DELETE, PUT, OPTIONS, ...)
- Works with app body types (Form data, Form URL encoded, Raw JSON, Raw text, ...)
- Compatibility with Postman

<br>

If you would like to support me, buy me a coffee 🙃<br>
<b>HALF OF THE DONATIONS WILL GO TO GAZA, Free Palestine 🇵🇸</b><br>
<a href="https://www.buymeacoffee.com/abdallahodeh" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" height="60" width="217"></a>

## Getting started

attach the interceptor to a dio instance as follows,
remember to keep the logging interceptor at last to log all headers & fields added from other interceptors

```dart
final dio = Dio();

dio.interceptors.add(DioCurlLoggerInterceptor());
```

## Usage

You can also have some customization as you want, you can:
- Customize how to print the curl (by default using `log` from `dart:developer`)
- You can determine whether to print the cURL `onRequest` or `onResponse` & `onError`
see the following examples for more

```dart
// Customize how to print the curl
final dio = Dio();

// Write to a file for example:
final Directory directory = await getApplicationDocumentsDirectory();
final File file = File('${directory.path}/app_log.txt');

dio.interceptors.add(DioCurlLoggerInterceptor(onPrint: (final cURL) async {
  print('cURL is: $cURL');
  await file.writeAsString(cURL);
}));
```

```dart
// Determine when to print the cURL
final dio = Dio();

// [DEFAULT] this will print the cURL right before sending the the request to the server
dio.interceptors.add(DioCurlLoggerInterceptor(sendOnRequest: true));

// this will print the cURL once response arrive, either succeed or when exception happens
dio.interceptors.add(DioCurlLoggerInterceptor(sendOnRequest: false));
```

## Contribution

All contributions are welcome!

If you like this project then please click on the 🌟 it'll be appreciated or if you wanna add more epic stuff you can submit your pull request and it'll be gladly accepted 🙆‍♂️

or if you found any bug or issue do not hesitate opening an issue on github
