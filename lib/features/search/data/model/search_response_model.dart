import 'package:movieapp/features/movies/data/model/movie_model.dart';

class SearchResponseModel {
  final int page;
  final List<MovieModel> results;
  final int totalPages;
  final int totalResults;

  SearchResponseModel({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) {
    return SearchResponseModel(
      page: json['page'] ?? 1,
      results: (json['results'] as List<dynamic>?)
          ?.map((item) => MovieModel.fromJson(item))
          .toList() ?? [],
      totalPages: json['total_pages'] ?? 1,
      totalResults: json['total_results'] ?? 0,
    );
  }
}