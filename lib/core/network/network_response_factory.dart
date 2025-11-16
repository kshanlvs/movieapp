import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:movieapp/core/network/network_client.dart';

abstract class NetworkResponseFactory {
  NetworkResponse createFromDioResponse(Response response);
}

class DefaultNetworkResponseFactory implements NetworkResponseFactory {
  @override
  NetworkResponse createFromDioResponse(Response response) {
    return NetworkResponse(
      statusCode: response.statusCode!,
      body: response.data is String
          ? response.data
          : json.encode(response.data),
      headers: response.headers.map.map(
        (key, list) => MapEntry(key, list.first),
      ),
    );
  }
}
