import 'package:movieapp/features/movies/data/model/movie_model.dart';

abstract class MovieCacheRepository {
  Future<void> cacheMovies(String type, List<MovieModel> movies);
  List<MovieModel> getCachedMovies(String type);
  bool hasCachedMovies(String type);
  DateTime? getLastUpdateTime(String type);
}
