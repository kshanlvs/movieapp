import 'package:movieapp/core/constants/api_constants.dart';
import 'package:movieapp/core/network/network_client.dart';
import 'package:movieapp/features/movie_details/data/model/movie_detail_model.dart';
import 'package:movieapp/features/movie_details/data/repository/movie_detail_repository.dart';

class MovieDetailsRepositoryImpl implements MovieDetailsRepository {
  final NetworkClient client;

  MovieDetailsRepositoryImpl({required this.client});

  @override
  Future<MovieDetails> getMovieDetails(int movieId) async {
    try {
      final response = await client.get(ApiConstants.movieDetails(movieId));
      return MovieDetails.fromJson(response.json);
    } catch (e) {
      throw Exception('Failed to load movie details: $e');
    }
  }
}