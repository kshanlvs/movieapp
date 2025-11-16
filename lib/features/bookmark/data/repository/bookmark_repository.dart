import 'package:movieapp/features/movies/data/model/movie_model.dart';

abstract class BookmarkRepository {
  Future<void> bookmarkMovie(MovieModel movie);
  Future<void> removeBookmark(int? movieId);
  Future<bool> isBookmarked(int? movieId);
  Future<List<MovieModel>> getBookmarkedMovies();
}
