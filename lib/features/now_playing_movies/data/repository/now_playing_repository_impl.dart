import 'package:movieapp/core/constants/api_constants.dart';
import 'package:movieapp/core/database/movie_types.dart';
import 'package:movieapp/core/network/network_client.dart';
import 'package:movieapp/features/movies/data/model/movie_model.dart';
import 'package:movieapp/features/movies/data/repository/movies_cache_repository.dart';
import 'package:movieapp/features/now_playing_movies/data/repository/now_playing_repository.dart';

class NowPlayingImpl implements NowPlayingRepository {
  final NetworkClient client;
  final MovieCacheRepository cacheRepository;

  NowPlayingImpl({required this.client, required this.cacheRepository});

  @override
  Future<List<MovieModel>> nowPlayingMovies() async {
    final hasValidCache = cacheRepository.hasCachedMovies(
      MovieTypes.nowPlaying,
    );

    if (hasValidCache) {
      final cachedMovies = cacheRepository.getCachedMovies(
        MovieTypes.nowPlaying,
      );

      _refreshDataInBackground();
      return cachedMovies;
    }

    try {
      final response = await client.get(ApiConstants.nowPlayingMovies);
      final results = response.json['results'] as List;
      final movies = results
          .map((movieData) => MovieModel.fromJson(movieData))
          .toList();

      await cacheRepository.cacheMovies(MovieTypes.nowPlaying, movies);
      return movies;
    } catch (e) {
      final cachedMovies = cacheRepository.getCachedMovies(
        MovieTypes.nowPlaying,
      );
      if (cachedMovies.isNotEmpty) {
        return cachedMovies;
      }
      throw Exception('Failed to load now playing movies: $e');
    }
  }

  void _refreshDataInBackground() {
    Future(() async {
      final response = await client.get(ApiConstants.nowPlayingMovies);
      final results = response.json['results'] as List;
      final movies = results
          .map((movieData) => MovieModel.fromJson(movieData))
          .toList();
      await cacheRepository.cacheMovies(MovieTypes.nowPlaying, movies);
    });
  }
}
