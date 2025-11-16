import 'package:movieapp/features/movies/data/model/movie_model.dart';

abstract class SearchState {
  const SearchState();
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  final String query;

  const SearchLoading({required this.query});
}

class SearchLoaded extends SearchState {
  final List<MovieModel> movies;
  final String query;
  final int totalResults;

  const SearchLoaded({
    required this.movies,
    required this.query,
    required this.totalResults,
  });
}

class SearchError extends SearchState {
  final String message;

  const SearchError({required this.message});
}
