import 'package:hive_flutter/hive_flutter.dart';
import 'package:movieapp/features/movies/data/model/image_generator.dart';
part 'movie_model.g.dart';

@HiveType(typeId: 0)
class MovieModel {
  @HiveField(0)
  bool? adult;

  @HiveField(1)
  String? backdropPath;

  @HiveField(2)
  int? id;

  @HiveField(3)
  String? title;

  @HiveField(4)
  String? originalTitle;

  @HiveField(5)
  String? overview;

  @HiveField(6)
  String? posterPath;

  @HiveField(7)
  String? mediaType;

  @HiveField(8)
  String? originalLanguage;

  @HiveField(9)
  List<int>? genreIds;

  @HiveField(10)
  double? popularity;

  @HiveField(11)
  String? releaseDate;

  @HiveField(12)
  bool? video;

  @HiveField(13)
  double? voteAverage;

  @HiveField(14)
  int? voteCount;

  final ImageUrlGenerator _imageUrlGenerator;

  MovieModel({
    this.adult,
    this.backdropPath,
    this.id,
    this.title,
    this.originalTitle,
    this.overview,
    this.posterPath,
    this.mediaType,
    this.originalLanguage,
    this.genreIds,
    this.popularity,
    this.releaseDate,
    this.video,
    this.voteAverage,
    this.voteCount,
    ImageUrlGenerator? imageUrlGenerator,
  }) : _imageUrlGenerator = imageUrlGenerator ?? const TmdbImageUrlGenerator();

  MovieModel.fromJson(
    Map<String, dynamic> json, {
    ImageUrlGenerator? imageUrlGenerator,
  }) : _imageUrlGenerator = imageUrlGenerator ?? const TmdbImageUrlGenerator() {
    adult = json['adult'];
    backdropPath = json['backdrop_path'];
    id = json['id'];
    title = json['title'];
    originalTitle = json['original_title'];
    overview = json['overview'];
    posterPath = json['poster_path'];
    mediaType = json['media_type'];
    originalLanguage = json['original_language'];
    genreIds = json['genre_ids']?.cast<int>();
    popularity = json['popularity']?.toDouble();
    releaseDate = json['release_date'];
    video = json['video'];
    voteAverage = json['vote_average']?.toDouble();
    voteCount = json['vote_count'];
  }

  String get posterUrlSmall =>
      _imageUrlGenerator.generatePosterUrl(posterPath, ImageSize.w185);
  String get posterUrlMedium =>
      _imageUrlGenerator.generatePosterUrl(posterPath, ImageSize.w342);
  String get posterUrlLarge =>
      _imageUrlGenerator.generatePosterUrl(posterPath, ImageSize.w500);
  String get posterUrlOriginal =>
      _imageUrlGenerator.generatePosterUrl(posterPath, ImageSize.original);

  String get backdropUrlSmall =>
      _imageUrlGenerator.generateBackdropUrl(backdropPath, ImageSize.w300);
  String get backdropUrlMedium =>
      _imageUrlGenerator.generateBackdropUrl(backdropPath, ImageSize.w780);
  String get backdropUrlLarge =>
      _imageUrlGenerator.generateBackdropUrl(backdropPath, ImageSize.w1280);
  String get backdropUrlOriginal =>
      _imageUrlGenerator.generateBackdropUrl(backdropPath, ImageSize.original);

  String get posterUrl => posterUrlLarge;
  String get backdropUrl => backdropUrlMedium;

  String get year => releaseDate != null && releaseDate!.isNotEmpty
      ? releaseDate!.substring(0, 4)
      : 'TBA';

  bool get hasPoster => posterPath != null && posterPath!.isNotEmpty;
  bool get hasBackdrop => backdropPath != null && backdropPath!.isNotEmpty;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['adult'] = adult;
    data['backdrop_path'] = backdropPath;
    data['id'] = id;
    data['title'] = title;
    data['original_title'] = originalTitle;
    data['overview'] = overview;
    data['poster_path'] = posterPath;
    data['media_type'] = mediaType;
    data['original_language'] = originalLanguage;
    data['genre_ids'] = genreIds;
    data['popularity'] = popularity;
    data['release_date'] = releaseDate;
    data['video'] = video;
    data['vote_average'] = voteAverage;
    data['vote_count'] = voteCount;
    return data;
  }
}
