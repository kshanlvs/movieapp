import 'package:movieapp/features/movies/data/model/movie_model.dart';

class MovieState {
  final List<MovieModel> movies;
  final bool isLoading;
  final String error;

  MovieState({this.movies = const [], this.isLoading = false, this.error = ''});

  MovieState copyWith({
    List<MovieModel>? movies,
    bool? isLoading,
    String? error,
  }) {
    return MovieState(
      movies: movies ?? this.movies,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
