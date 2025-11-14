// // lib/features/movies/data/repository/now_playing_repository_impl.dart
// import 'package:movieapp/core/constants/api_constants.dart';
// import 'package:movieapp/core/network/network_client.dart';
// import 'package:movieapp/features/movies/data/model/movie_model.dart';
// import 'package:movieapp/features/movies/data/repository/now_playing_repository.dart';

// class NowPlayingImpl implements NowPlayingRepository {
//   final NetworkClient client;

//   NowPlayingImpl({required this.client});

//   @override
//   Future<List<MovieModel>> nowPlayingMovies() async {
//     try {
//       final response = await client.get(ApiConstants.nowPlayingMovies);
//       final results = response.json['results'] as List;
//       final movies = results
//           .map((movieData) => MovieModel.fromJson(movieData))
//           .toList();
//       await HiveDatabase.cacheNowPlayingMovies(movies);
//       return movies;
//     } catch (e) {
//       if (HiveDatabase.hasCachedNowPlayingMovies()) {
//         final cachedMovies = HiveDatabase.getCachedNowPlayingMovies();
//         return cachedMovies;
//       }
//       throw Exception('Failed to load now playing movies: $e');
//     }
//   }
// }
