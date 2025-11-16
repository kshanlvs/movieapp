import 'package:movieapp/features/movie_details/data/model/movie_detail_model.dart';
import 'package:movieapp/features/movies/data/model/movie_model.dart';

class MovieModelMapper {
  static MovieModel fromDetails(MovieDetails details) {
    return MovieModel(
      id: details.id,
      title: details.title,
      posterPath: details.posterPath,
      backdropPath: details.backdropPath,
      overview: details.overview,
      releaseDate: details.releaseDate,
      voteAverage: details.voteAverage,
      voteCount: details.voteCount,
      popularity: details.popularity,
      originalLanguage: details.originalLanguage,
      originalTitle: details.originalTitle,
      genreIds: details.genres.map((e) => e.id).toList(),
      adult: details.adult,
      video: details.video,
    );
  }
}