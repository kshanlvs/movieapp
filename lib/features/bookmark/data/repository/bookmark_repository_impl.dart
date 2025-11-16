import 'package:movieapp/core/database/movie_types.dart';
import 'package:movieapp/features/bookmark/data/repository/bookmark_repository.dart';
import 'package:movieapp/features/movies/data/model/movie_model.dart';
import 'package:movieapp/features/movies/data/repository/movies_cache_repository.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  final MovieCacheRepository cacheRepository;

  BookmarkRepositoryImpl({required this.cacheRepository});

  @override
  Future<void> bookmarkMovie(MovieModel movie) async {
    try {
      final currentBookmarks = await getBookmarkedMovies();
      final alreadyBookmarked = currentBookmarks.any((m) => m.id == movie.id);
      if (alreadyBookmarked) {
        return;
      }
      final updatedBookmarks = [...currentBookmarks, movie];
      await cacheRepository.cacheMovies(
        MovieTypes.bookmarked,
        updatedBookmarks,
      );
    } catch (e) {
      throw BookmarkException(
        message: 'Failed to save movie to bookmarks',
        underlyingError: e,
      );
    }
  }

  @override
  Future<void> removeBookmark(int? movieId) async {
    try {
      if (movieId == null) return;

      final bookmarks = await getBookmarkedMovies();
      final updatedBookmarks = bookmarks.where((m) => m.id != movieId).toList();
      await cacheRepository.cacheMovies(
        MovieTypes.bookmarked,
        updatedBookmarks,
      );
    } catch (e) {
      throw BookmarkException(
        message: 'Failed to remove movie from bookmarks',
        underlyingError: e,
      );
    }
  }

  @override
  Future<bool> isBookmarked(int? movieId) async {
    try {
      if (movieId == null) return false;

      final bookmarks = await getBookmarkedMovies();
      return bookmarks.any((movie) => movie.id == movieId);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<MovieModel>> getBookmarkedMovies() async {
    try {
      return cacheRepository.getCachedMovies(MovieTypes.bookmarked);
    } catch (e) {
      return [];
    }
  }
}

class BookmarkException implements Exception {
  final String message;
  final Object? underlyingError;

  const BookmarkException({required this.message, this.underlyingError});

  @override
  String toString() =>
      'BookmarkException: $message${underlyingError != null ? 
      ' (Caused by: $underlyingError)' : ''}';
}
