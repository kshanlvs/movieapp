

import 'package:movieapp/features/movies/data/model/movie_model.dart';

abstract class BookmarkEvent {
  const BookmarkEvent();
}

class ToggleBookmark extends BookmarkEvent {
  final MovieModel movie;
  const ToggleBookmark({required this.movie});
}

class LoadBookmarks extends BookmarkEvent {}

class CheckBookmarkStatus extends BookmarkEvent {
  final int movieId;
  const CheckBookmarkStatus({required this.movieId});
}