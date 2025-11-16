import 'package:movieapp/features/movies/data/model/movie_model.dart';

class TrendingMoviesState {
  final List<MovieModel> movies;
  final bool isLoading;
  final String error;

  const TrendingMoviesState({
    this.movies = const [],
    this.isLoading = false,
    this.error = '',
  });

  TrendingMoviesState copyWith({
    List<MovieModel>? movies,
    bool? isLoading,
    String? error,
  }) {
    return TrendingMoviesState(
      movies: movies ?? this.movies,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
