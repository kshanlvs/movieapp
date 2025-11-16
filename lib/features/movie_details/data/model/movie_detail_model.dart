import 'package:movieapp/features/movies/data/model/image_generator.dart';

class MovieDetails {
  final bool adult;
  final String? backdropPath;
  final BelongsToCollection? belongsToCollection;
  final int budget;
  final List<Genres> genres;
  final String? homepage;
  final int id;
  final String? imdbId;
  final List<String> originCountry;
  final String originalLanguage;
  final String originalTitle;
  final String? overview;
  final double popularity;
  final String? posterPath;
  final List<ProductionCompanies> productionCompanies;
  final List<ProductionCountries> productionCountries;
  final String? releaseDate;
  final int revenue;
  final int? runtime;
  final List<SpokenLanguages> spokenLanguages;
  final String status;
  final String? tagline;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;

  final ImageUrlGenerator _imageUrlGenerator;

  MovieDetails({
    this.adult = false,
    this.backdropPath,
    this.belongsToCollection,
    this.budget = 0,
    this.genres = const [],
    this.homepage,
    required this.id,
    this.imdbId,
    this.originCountry = const [],
    required this.originalLanguage,
    required this.originalTitle,
    this.overview,
    this.popularity = 0.0,
    this.posterPath,
    this.productionCompanies = const [],
    this.productionCountries = const [],
    this.releaseDate,
    this.revenue = 0,
    this.runtime,
    this.spokenLanguages = const [],
    required this.status,
    this.tagline,
    required this.title,
    this.video = false,
    this.voteAverage = 0.0,
    this.voteCount = 0,
    ImageUrlGenerator? imageUrlGenerator,
  }) : _imageUrlGenerator = imageUrlGenerator ?? const TmdbImageUrlGenerator();

  factory MovieDetails.fromJson(Map<String, dynamic> json) {
    return MovieDetails(
      adult: json['adult'] as bool? ?? false,
      backdropPath: json['backdrop_path'] as String?,
      belongsToCollection: json['belongs_to_collection'] != null
          ? BelongsToCollection.fromJson(json['belongs_to_collection'])
          : null,
      budget: json['budget'] as int? ?? 0,
      genres:
          (json['genres'] as List<dynamic>?)
              ?.map((v) => Genres.fromJson(v as Map<String, dynamic>))
              .toList() ??
          [],
      homepage: json['homepage'] as String?,
      id: json['id'] as int,
      imdbId: json['imdb_id'] as String?,
      originCountry:
          (json['origin_country'] as List<dynamic>?)
              ?.map((v) => v.toString())
              .toList() ??
          [],
      originalLanguage: json['original_language'] as String? ?? '',
      originalTitle: json['original_title'] as String? ?? '',
      overview: json['overview'] as String?,
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      posterPath: json['poster_path'] as String?,
      productionCompanies:
          (json['production_companies'] as List<dynamic>?)
              ?.map(
                (v) => ProductionCompanies.fromJson(v as Map<String, dynamic>),
              )
              .toList() ??
          [],
      productionCountries:
          (json['production_countries'] as List<dynamic>?)
              ?.map(
                (v) => ProductionCountries.fromJson(v as Map<String, dynamic>),
              )
              .toList() ??
          [],
      releaseDate: json['release_date'] as String?,
      revenue: json['revenue'] as int? ?? 0,
      runtime: json['runtime'] as int?,
      spokenLanguages:
          (json['spoken_languages'] as List<dynamic>?)
              ?.map((v) => SpokenLanguages.fromJson(v as Map<String, dynamic>))
              .toList() ??
          [],
      status: json['status'] as String? ?? '',
      tagline: json['tagline'] as String?,
      title: json['title'] as String? ?? '',
      video: json['video'] as bool? ?? false,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: json['vote_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['adult'] = adult;
    data['backdrop_path'] = backdropPath;
    data['belongs_to_collection'] = belongsToCollection?.toJson();
    data['budget'] = budget;
    data['genres'] = genres.map((v) => v.toJson()).toList();
    data['homepage'] = homepage;
    data['id'] = id;
    data['imdb_id'] = imdbId;
    data['origin_country'] = originCountry;
    data['original_language'] = originalLanguage;
    data['original_title'] = originalTitle;
    data['overview'] = overview;
    data['popularity'] = popularity;
    data['poster_path'] = posterPath;
    data['production_companies'] = productionCompanies
        .map((v) => v.toJson())
        .toList();
    data['production_countries'] = productionCountries
        .map((v) => v.toJson())
        .toList();
    data['release_date'] = releaseDate;
    data['revenue'] = revenue;
    data['runtime'] = runtime;
    data['spoken_languages'] = spokenLanguages.map((v) => v.toJson()).toList();
    data['status'] = status;
    data['tagline'] = tagline;
    data['title'] = title;
    data['video'] = video;
    data['vote_average'] = voteAverage;
    data['vote_count'] = voteCount;
    return data;
  }

  String get posterUrlLarge =>
      _imageUrlGenerator.generatePosterUrl(posterPath, ImageSize.w500);
}

class BelongsToCollection {
  final int id;
  final String name;
  final String? posterPath;
  final String? backdropPath;

  BelongsToCollection({
    required this.id,
    required this.name,
    this.posterPath,
    this.backdropPath,
  });

  factory BelongsToCollection.fromJson(Map<String, dynamic> json) {
    return BelongsToCollection(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
    };
  }
}

class Genres {
  final int id;
  final String name;

  Genres({required this.id, required this.name});

  factory Genres.fromJson(Map<String, dynamic> json) {
    return Genres(id: json['id'] as int, name: json['name'] as String? ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class ProductionCompanies {
  final int id;
  final String? logoPath;
  final String name;
  final String originCountry;

  ProductionCompanies({
    required this.id,
    this.logoPath,
    required this.name,
    required this.originCountry,
  });

  factory ProductionCompanies.fromJson(Map<String, dynamic> json) {
    return ProductionCompanies(
      id: json['id'] as int,
      logoPath: json['logo_path'] as String?,
      name: json['name'] as String? ?? '',
      originCountry: json['origin_country'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'logo_path': logoPath,
      'name': name,
      'origin_country': originCountry,
    };
  }
}

class ProductionCountries {
  final String iso31661;
  final String name;

  ProductionCountries({required this.iso31661, required this.name});

  factory ProductionCountries.fromJson(Map<String, dynamic> json) {
    return ProductionCountries(
      iso31661: json['iso_3166_1'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'iso_3166_1': iso31661, 'name': name};
  }
}

class SpokenLanguages {
  final String englishName;
  final String iso6391;
  final String name;

  SpokenLanguages({
    required this.englishName,
    required this.iso6391,
    required this.name,
  });

  factory SpokenLanguages.fromJson(Map<String, dynamic> json) {
    return SpokenLanguages(
      englishName: json['english_name'] as String? ?? '',
      iso6391: json['iso_639_1'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'english_name': englishName, 'iso_639_1': iso6391, 'name': name};
  }
}
