import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/features/movies/data/repository/trending_movie_repository.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final TrendingMovieRepository repository;

  MovieBloc({required this.repository}) : super(MovieState()) {
    on<FetchTrendingMovies>(_onFetchTrendingMovies);
  }

  Future<void> _onFetchTrendingMovies(
    FetchTrendingMovies event,
    Emitter<MovieState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: ''));

    try {
      final movies = await repository.trendingMovies();
      emit(state.copyWith(isLoading: false, movies: movies));
    } catch (e) {
      // The repository already handles cache fallback, so if we get here
      // it means both network and cache failed
      emit(
        state.copyWith(
          isLoading: false,
          error: e.toString(),
          movies: [], // Clear movies on complete failure
        ),
      );
    }
  }
}
