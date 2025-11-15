import 'package:movieapp/core/di/service_locator.dart';
import 'package:movieapp/features/movies/data/repository/movie_cache_repository_impl.dart';
import 'package:movieapp/features/movies/data/repository/movies_cache_repository.dart';
import 'package:movieapp/features/movies/data/repository/now_playing_repository.dart';
import 'package:movieapp/features/movies/data/repository/now_playing_repository_impl.dart';
import 'package:movieapp/features/movies/data/repository/trending_movie_impl.dart';
import 'package:movieapp/features/movies/data/repository/trending_movie_repository.dart';
import 'package:movieapp/features/now_playing_movies/presentation/bloc/now_playing_movie_bloc.dart';
import 'package:movieapp/features/trending_movies/presentation/bloc/trending_movie_bloc.dart';


class MovieServiceLocator {
  static Future<void> init() async {
    sl.registerLazySingleton<MovieCacheRepository>(
      () => MovieCacheRepositoryImpl(),
    );
    
    sl.registerLazySingleton<TrendingMovieRepository>(
      () => TrendingMovieImpl(client: sl(), cacheRepository: sl()),
    );
    
    sl.registerLazySingleton<NowPlayingRepository>(
      () => NowPlayingImpl(client: sl(), cacheRepository: sl()),
    );

    sl.registerFactory<TrendingMoviesBloc>(
      () => TrendingMoviesBloc(repository: sl<TrendingMovieRepository>()),
    );
    
    sl.registerFactory<NowPlayingMoviesBloc>(
      () => NowPlayingMoviesBloc(repository: sl<NowPlayingRepository>()),
    );
  }
}