import 'package:movieapp/features/movies/data/model/movie_model.dart';

abstract class TrendingMovieRepository {
  Future<List<MovieModel>> trendingMovies();
}
