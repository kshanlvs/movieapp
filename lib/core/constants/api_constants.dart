// ignore: avoid_classes_with_only_static_members
class ApiConstants {
  static String get popularMovies => '/movie/popular';
  static String get topRatedMovies => '/movie/top_rated';
  static String get nowPlayingMovies => '/movie/now_playing';
  static String get upcomingMovies => '/movie/upcoming';
  static String get searchMovies => '/search/movie';
  static String get trendingMovie => '/trending/movie/week';
  static String movieDetails(int movieId) => '/movie/$movieId';
  static String imageBaseUrl = 'https://image.tmdb.org/t/p/';
}
