import 'package:movieapp/features/movies/data/model/movie_model.dart';

abstract class NowPlayingRepository {
  Future<List<MovieModel>> nowPlayingMovies();
}
