import 'package:hive_flutter/hive_flutter.dart';
import 'package:movieapp/features/movies/data/model/movie_model.dart';
import 'package:movieapp/features/movies/data/repository/movies_cache_repository.dart';

class MovieCacheRepositoryImpl implements MovieCacheRepository {
  @override
  Future<void> cacheMovies(String type, List<MovieModel> movies) async {
    final box = Hive.box(type);
    await box.clear();

    for (final movie in movies) {
      await box.put(movie.id.toString(), movie);
    }

    await box.put('last_updated', DateTime.now().millisecondsSinceEpoch);
  }

  @override
  List<MovieModel> getCachedMovies(String type) {
    final box = Hive.box(type);
    final movies = <MovieModel>[];

    for (final key in box.keys) {
      final value = box.get(key);
      if (value is MovieModel) {
        movies.add(value);
      }
    }

    return movies;
  }

  @override
  bool hasCachedMovies(String type) {
    final box = Hive.box(type);
    return box.keys.any((key) => key != 'last_updated');
  }

  @override
  DateTime? getLastUpdateTime(String type) {
    final box = Hive.box(type);
    final lastUpdated = box.get('last_updated');
    return lastUpdated != null
        ? DateTime.fromMillisecondsSinceEpoch(lastUpdated as int)
        : null;
  }
}
