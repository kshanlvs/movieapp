class DeepLinkService {
  static const String scheme = 'movieapp';
  static const String host = 'fakehost.com';

  static Uri createMovieDeepLink(int movieId) {
    return Uri(scheme: scheme, host: host, path: '/movie/$movieId');
  }

  static String createMovieShareMessage(int movieId, String movieTitle) {
    final deepLink = createMovieDeepLink(movieId);
    return 'Check out "$movieTitle" on MovieApp! $deepLink';
  }

  static int? parseMovieIdFromUri(Uri uri) {
    if (uri.scheme == scheme && uri.host == host) {
      final segments = uri.pathSegments;
      if (segments.length == 2 && segments[0] == 'movie') {
        return int.tryParse(segments[1]);
      }
    }
    return null;
  }

  static bool isMovieDeepLink(Uri uri) {
    return uri.scheme == scheme &&
        uri.host == host &&
        uri.pathSegments.firstOrNull == 'movie';
  }
}
