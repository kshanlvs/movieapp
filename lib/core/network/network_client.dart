import 'dart:convert';

abstract class ReadNetworkClient {
  Future<NetworkResponse> get(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  });
}

abstract class WriteNetworkClient {
  Future<NetworkResponse> post(
    String url, {
    Map<String, String>? headers,
    Object? body,
  });

  Future<NetworkResponse> put(
    String url, {
    Map<String, String>? headers,
    Object? body,
  });

  Future<NetworkResponse> delete(String url, {Map<String, String>? headers});
}

abstract class NetworkConfigClient {
  void setBaseHeaders(Map<String, String> headers);
  void setBaseUrl(String baseUrl);
  void setTimeout(Duration timeout);
}

abstract class NetworkClient
    implements ReadNetworkClient, WriteNetworkClient, NetworkConfigClient {}

class NetworkResponse {
  final int statusCode;
  final String body;
  final Map<String, String> headers;
  final bool isSuccess;

  NetworkResponse({
    required this.statusCode,
    required this.body,
    required this.headers,
  }) : isSuccess = statusCode >= 200 && statusCode < 300;

  Map<String, dynamic> get json => _decodeJson(body, statusCode);

  static Map<String, dynamic> _decodeJson(String jsonString, int statusCode) {
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      throw NetworkException(
        'Failed to parse JSON response: $e',
        statusCode: statusCode,
      );
    }
  }
}

class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  final String? url;

  NetworkException(this.message, {this.statusCode, this.url});

  @override
  String toString() {
    final statusPart = statusCode != null ? ' (Status: $statusCode)' : '';
    final urlPart = url != null ? ' - $url' : '';
    return 'NetworkException: $message$statusPart$urlPart';
  }
}

class TimeoutNetworkException extends NetworkException {
  TimeoutNetworkException(super.message, {super.url});
}

class UnauthorizedNetworkException extends NetworkException {
  UnauthorizedNetworkException({String? url})
    : super('Unauthorized access', statusCode: 401, url: url);
}
