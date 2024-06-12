import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class NetworkClient {
  final Dio dio = Dio();

  NetworkClient() {
    dio.interceptors.add(LogInterceptor(
      logPrint: (log) => debugPrint(log.toString()),
      responseBody: true,
      requestBody: true,
    ));
  }
}
