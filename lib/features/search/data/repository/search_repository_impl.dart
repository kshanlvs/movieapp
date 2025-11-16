import 'package:movieapp/core/network/network_client.dart';
import 'package:movieapp/features/search/data/model/search_response_model.dart';
import 'package:movieapp/features/search/data/repository/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final NetworkClient networkClient;

  SearchRepositoryImpl({required this.networkClient});

  @override
  Future<SearchResponseModel> searchMovies(String query, {int page = 1}) async {
    if (query.isEmpty) {
      return SearchResponseModel(
        page: 1,
        results: [],
        totalPages: 1,
        totalResults: 0,
      );
    }

    final response = await networkClient.get(
      '/search/movie',
      queryParameters: {'query': query, 'page': page, 'include_adult': false},
    );

    return SearchResponseModel.fromJson(response.json);
  }
}
