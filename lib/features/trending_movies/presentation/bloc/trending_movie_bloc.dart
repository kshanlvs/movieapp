import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/features/trending_movies/data/repository/trending_movie_repository.dart';
import 'package:movieapp/features/trending_movies/presentation/bloc/trending_movie_event.dart';
import 'package:movieapp/features/trending_movies/presentation/bloc/trending_movie_state.dart';


class TrendingMoviesBloc extends Bloc<TrendingMoviesEvent, TrendingMoviesState> {
  final TrendingMovieRepository repository;

  TrendingMoviesBloc({required this.repository}) : super(const TrendingMoviesState()) {
    on<FetchTrendingMovies>(_onFetchTrendingMovies);
  }

Future<void> _onFetchTrendingMovies(
  FetchTrendingMovies event,
  Emitter<TrendingMoviesState> emit,
) async {
  final previousMovies = state.movies;
  
  emit(state.copyWith(isLoading: true, error: '', movies: const []));

  try {
    final movies = await repository.trendingMovies();
    emit(state.copyWith(isLoading: false, movies: movies));
  } catch (e) {

    emit(state.copyWith(
      isLoading: false, 
      error: e.toString(),
      movies: previousMovies,
    ));
  }
}
}