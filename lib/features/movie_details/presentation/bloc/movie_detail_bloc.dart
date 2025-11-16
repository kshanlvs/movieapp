import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/features/movie_details/data/repository/movie_detail_repository.dart';
import 'package:movieapp/features/movie_details/presentation/bloc/movie_detail_event.dart';
import 'package:movieapp/features/movie_details/presentation/bloc/movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final MovieDetailsRepository repository;
  MovieDetailBloc({required this.repository}) : super(MovieDetailInitial()) {
    on<LoadMovieDetail>(_onLoadMovieDetail);
  }

  Future<void> _onLoadMovieDetail(
    LoadMovieDetail event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(MovieDetailLoading());
    try {
      final movieDetail = await repository.getMovieDetails(event.movieId);
      emit(MovieDetailLoaded(movieDetail: movieDetail));
    } catch (e) {
      emit(MovieDetailError(message: e.toString()));
    }
  }
}
