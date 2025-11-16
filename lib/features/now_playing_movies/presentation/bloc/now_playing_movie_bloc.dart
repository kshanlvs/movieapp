import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/features/now_playing_movies/data/repository/now_playing_repository.dart';
import 'package:movieapp/features/now_playing_movies/presentation/bloc/now_playing_movie_event.dart';
import 'package:movieapp/features/now_playing_movies/presentation/bloc/now_playing_state.dart';

class NowPlayingMoviesBloc
    extends Bloc<NowPlayingMoviesEvent, NowPlayingMoviesState> {
  final NowPlayingRepository repository;

  NowPlayingMoviesBloc({required this.repository})
    : super(const NowPlayingMoviesState()) {
    on<FetchNowPlayingMovies>(_onFetchNowPlayingMovies);
  }

  Future<void> _onFetchNowPlayingMovies(
    FetchNowPlayingMovies event,
    Emitter<NowPlayingMoviesState> emit,
  ) async {
    final previousMovies = state.movies;
    emit(state.copyWith(isLoading: true, error: '', movies: const []));

    try {
      final movies = await repository.nowPlayingMovies();
      emit(state.copyWith(isLoading: false, movies: movies));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e.toString(),
          movies: previousMovies,
        ),
      );
    }
  }
}
