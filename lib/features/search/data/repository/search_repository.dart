import 'package:movieapp/features/search/data/model/search_response_model.dart';

abstract class SearchRepository {
  Future<SearchResponseModel> searchMovies(String query, {int page = 1});
}