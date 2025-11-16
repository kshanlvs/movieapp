import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/features/bookmark/data/repository/bookmark_repository.dart';
import 'package:movieapp/features/bookmark/presentation/bloc/bookmark_event.dart';
import 'package:movieapp/features/bookmark/presentation/bloc/bookmark_state.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  final BookmarkRepository repository;

  BookmarkBloc({required this.repository}) : super(BookmarkInitial()) {
    on<ToggleBookmark>(_onToggleBookmark);
    on<LoadBookmarks>(_onLoadBookmarks);
    on<CheckBookmarkStatus>(_onCheckBookmarkStatus);
  }

  Future<void> _onToggleBookmark(
    ToggleBookmark event,
    Emitter<BookmarkState> emit,
  ) async {
    try {
      final isBookmarked = await repository.isBookmarked(event.movie.id);

      if (isBookmarked) {
        await repository.removeBookmark(event.movie.id);
      } else {
        await repository.bookmarkMovie(event.movie);
      }

      final updatedBookmarks = await repository.getBookmarkedMovies();

      emit(
        BookmarkUpdated(
          movieId: event.movie.id ?? 0,
          isBookmarked: !isBookmarked,
          bookmarks: updatedBookmarks,
        ),
      );
    } catch (e) {
      emit(BookmarkError(message: e.toString()));
    }
  }

  Future<void> _onLoadBookmarks(
    LoadBookmarks event,
    Emitter<BookmarkState> emit,
  ) async {
    emit(BookmarkLoading());
    try {
      final bookmarks = await repository.getBookmarkedMovies();
      emit(BookmarkLoaded(bookmarks: bookmarks));
    } catch (e) {
      emit(BookmarkError(message: e.toString()));
    }
  }

  Future<void> _onCheckBookmarkStatus(
    CheckBookmarkStatus event,
    Emitter<BookmarkState> emit,
  ) async {
    try {
      final isBookmarked = await repository.isBookmarked(event.movieId);
      emit(
        BookmarkStatusChecked(
          movieId: event.movieId,
          isBookmarked: isBookmarked,
        ),
      );
      final bookmarks = await repository.getBookmarkedMovies();
      emit(BookmarkLoaded(bookmarks: bookmarks));
    } catch (e) {
      //Todo: handle catch
    }
  }
}
