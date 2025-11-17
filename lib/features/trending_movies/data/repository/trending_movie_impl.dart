import 'package:movieapp/core/constants/api_constants.dart';
import 'package:movieapp/core/database/movie_types.dart';
import 'package:movieapp/core/network/network_client.dart';
import 'package:movieapp/features/movies/data/model/movie_model.dart';
import 'package:movieapp/features/movies/data/repository/movies_cache_repository.dart';
import 'package:movieapp/features/trending_movies/data/repository/trending_movie_repository.dart';

class TrendingMovieImpl implements TrendingMovieRepository {
  final NetworkClient client;
  final MovieCacheRepository cacheRepository;

  TrendingMovieImpl({required this.client, required this.cacheRepository});

  @override
  Future<List<MovieModel>> trendingMovies() async {
    final hasValidCache = cacheRepository.hasCachedMovies(MovieTypes.trending);

    if (hasValidCache) {
      final cachedMovies = cacheRepository.getCachedMovies(MovieTypes.trending);
      _refreshDataInBackground();
      return cachedMovies;
    }

    try {
      final response = await client.get(ApiConstants.trendingMovie);
      final results = response.json['results'] as List;
      final movies = results.map((m) => MovieModel.fromJson(m)).toList();

      await cacheRepository.cacheMovies(MovieTypes.trending, movies);
      return movies;
    } catch (e) {
      final cachedMovies = cacheRepository.getCachedMovies(MovieTypes.trending);
      if (cachedMovies.isNotEmpty) {
        return cachedMovies;
      }
      throw Exception('Failed to load trending movies: $e');
    }
  }

  void _refreshDataInBackground() {
    Future(() async {
      final response = await client.get(ApiConstants.trendingMovie);
      final results = response.json['results'] as List;
      final movies = results.map((m) => MovieModel.fromJson(m)).toList();
      await cacheRepository.cacheMovies(MovieTypes.trending, movies);
    });
  }
}
