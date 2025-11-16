

import 'package:movieapp/features/movies/data/model/movie_model.dart';

abstract class BookmarkState {
  const BookmarkState();
}

class BookmarkInitial extends BookmarkState {}

class BookmarkLoading extends BookmarkState {}

class BookmarkLoaded extends BookmarkState {
  final List<MovieModel> bookmarks;
  const BookmarkLoaded({required this.bookmarks});
}

class BookmarkUpdated extends BookmarkState {
  final int movieId;
  final bool isBookmarked;
  final List<MovieModel> bookmarks;
  const BookmarkUpdated({
    required this.movieId, 
    required this.isBookmarked,
    required this.bookmarks, 
  });
}

class BookmarkStatusChecked extends BookmarkState {
  final int movieId;
  final bool isBookmarked;
  const BookmarkStatusChecked({required this.movieId, required this.isBookmarked});
}

class BookmarkError extends BookmarkState {
  final String message;
  const BookmarkError({required this.message});
}