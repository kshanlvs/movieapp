abstract class MovieDetailEvent {}

class LoadMovieDetail extends MovieDetailEvent {
  final int movieId;
  LoadMovieDetail({required this.movieId});
}
