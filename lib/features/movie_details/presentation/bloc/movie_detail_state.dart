import 'package:movieapp/features/movie_details/data/model/movie_detail_model.dart';

abstract class MovieDetailState {}

class MovieDetailInitial extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailLoaded extends MovieDetailState {
  final MovieDetails movieDetail;
  MovieDetailLoaded({required this.movieDetail});
}

class MovieDetailError extends MovieDetailState {
  final String message;
  MovieDetailError({required this.message});
}
