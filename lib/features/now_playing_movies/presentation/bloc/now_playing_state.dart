import 'package:movieapp/features/movies/data/model/movie_model.dart';

class NowPlayingMoviesState {
  final List<MovieModel> movies;
  final bool isLoading;
  final String error;

  const NowPlayingMoviesState({
    this.movies = const [],
    this.isLoading = false,
    this.error = '',
  });

  NowPlayingMoviesState copyWith({
    List<MovieModel>? movies,
    bool? isLoading,
    String? error,
  }) {
    return NowPlayingMoviesState(
      movies: movies ?? this.movies,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
