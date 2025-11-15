
import 'package:movieapp/features/movie_details/data/model/movie_detail_model.dart';

abstract class MovieDetailsRepository {
  Future<MovieDetails> getMovieDetails(int movieId);
}