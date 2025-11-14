import 'package:hive_flutter/hive_flutter.dart';
import 'package:movieapp/features/movies/data/model/movie_model.dart';

class MovieCacheService {
  static Future<void> cacheMovies(
    String boxName,
    List<MovieModel> movies,
  ) async {
    final box = Hive.box(boxName);
    await box.clear();

    for (final movie in movies) {
      await box.put(movie.id.toString(), movie);
    }

    await box.put('last_updated', DateTime.now().millisecondsSinceEpoch);
  }

  static List<MovieModel> getCachedMovies(String boxName) {
    final box = Hive.box(boxName);
    final movies = <MovieModel>[];

    for (final key in box.keys) {
      final value = box.get(key);
      if (value is MovieModel) {
        movies.add(value);
      }
    }

    return movies;
  }

  static bool hasCachedMovies(String boxName) {
    final box = Hive.box(boxName);
    return box.keys.any((key) => key != 'last_updated');
  }

  static DateTime? getLastUpdateTime(String boxName) {
    final box = Hive.box(boxName);
    final lastUpdated = box.get('last_updated');
    return lastUpdated != null
        ? DateTime.fromMillisecondsSinceEpoch(lastUpdated as int)
        : null;
  }
}
