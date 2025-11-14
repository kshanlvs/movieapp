import 'package:movieapp/core/di/service_locator.dart';
import 'package:movieapp/features/movies/data/repository/movie_cache_repository_impl.dart';
import 'package:movieapp/features/movies/data/repository/movies_cache_repository.dart';
import 'package:movieapp/features/movies/data/repository/trending_movie_impl.dart';
import 'package:movieapp/features/movies/data/repository/trending_movie_repository.dart';
import 'package:movieapp/features/movies/presentation/bloc/movie_bloc.dart';

class MovieServiceLocator {
  static Future<void> init() async {
    sl.registerLazySingleton<MovieCacheRepository>(
      () => MovieCacheRepositoryImpl(),
    );
    sl.registerLazySingleton<TrendingMovieRepository>(
      () => TrendingMovieImpl(client: sl(), cacheRepository: sl()),
    );

    sl.registerFactory<MovieBloc>(
      () => MovieBloc(repository: sl<TrendingMovieRepository>()),
    );
  }
}
