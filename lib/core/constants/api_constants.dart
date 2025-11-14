class ApiConstants {
  static String get popularMovies => '/movie/popular';
  static String get topRatedMovies => '/movie/top_rated';
  static String get nowPlayingMovies => '/movie/now_playing';
  static String get upcomingMovies => '/movie/upcoming';
  static String get searchMovies => '/search/movie';
  static String get movieDetails => '/movie';
  static String get trendingMovie => '/trending/movie/week';

  static String imageBaseUrl = 'https://image.tmdb.org/t/p/';
  static String posterUrl(String path) => '${imageBaseUrl}w500$path';
  static String backdropUrl(String path) => '${imageBaseUrl}w780$path';
}
