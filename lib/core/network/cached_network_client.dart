import 'package:movieapp/core/network/network_client.dart';

class CachedNetworkClient implements NetworkClient {
  final NetworkClient _decoratedClient;
  final Map<String, _CachedResponse> _cache = {};
  static const Duration _defaultCacheDuration = Duration(minutes: 10);

  CachedNetworkClient(this._decoratedClient);

  @override
  Future<NetworkResponse> get(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    final cacheKey = _generateCacheKey(url, queryParameters);
    
  
    if (_isCacheValid(cacheKey)) {
      return _cache[cacheKey]!.response;
    }

    try {
      final response = await _decoratedClient.get(
        url,
        headers: headers,
        queryParameters: queryParameters,
      );
      
      _cache[cacheKey] = _CachedResponse(
        response: response,
        timestamp: DateTime.now(),
      );
      
      return response;
    } catch (e) {
      if (_cache.containsKey(cacheKey)) {
        return _cache[cacheKey]!.response;
      }
      rethrow;
    }
  }
  @override
  Future<NetworkResponse> post(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    return _decoratedClient.post(url, headers: headers, body: body);
  }

  @override
  Future<NetworkResponse> put(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    return _decoratedClient.put(url, headers: headers, body: body);
  }

  @override
  Future<NetworkResponse> delete(
    String url, {
    Map<String, String>? headers,
  }) async {
    return _decoratedClient.delete(url, headers: headers);
  }

  @override
  void setBaseHeaders(Map<String, String> headers) {
    _decoratedClient.setBaseHeaders(headers);
  }

  @override
  void setBaseUrl(String baseUrl) {
    _decoratedClient.setBaseUrl(baseUrl);
  }

  @override
  void setTimeout(Duration timeout) {
    _decoratedClient.setTimeout(timeout);
  }
  String _generateCacheKey(String url, Map<String, dynamic>? queryParameters) {
    final params = queryParameters?.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&') ?? '';
    return '$url?$params';
  }

  bool _isCacheValid(String cacheKey) {
    if (!_cache.containsKey(cacheKey)) return false;
    final cached = _cache[cacheKey]!;
    return DateTime.now().difference(cached.timestamp) < _defaultCacheDuration;
  }

  void clearCache() {
    _cache.clear();
  }

  void clearCacheForUrl(String url) {
    final keysToRemove = _cache.keys
        .where((key) => key.startsWith(url))
        .toList();
    for (final key in keysToRemove) {
      _cache.remove(key);
    }
  }
}

class _CachedResponse {
  final NetworkResponse response;
  final DateTime timestamp;

  _CachedResponse({required this.response, required this.timestamp});
}