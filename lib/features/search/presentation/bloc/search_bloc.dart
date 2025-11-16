import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/features/search/data/repository/search_repository.dart';
import 'package:movieapp/features/search/presentation/bloc/search_event.dart';
import 'package:movieapp/features/search/presentation/bloc/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository searchRepository;
  Timer? _debounceTimer;

  SearchBloc({required this.searchRepository}) : super(SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<SearchClear>(_onSearchClear);
    on<_PerformSearchEvent>(_onPerformSearch);
  }

  void _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) {

    _debounceTimer?.cancel();

    if (event.query.isEmpty) {
      emit(SearchInitial());
      return;
    }


    if (state is! SearchLoaded || (state as SearchLoaded).query != event.query) {
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      add(_PerformSearchEvent(query: event.query));
    });
  }

  Future<void> _onPerformSearch(
    _PerformSearchEvent event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading(query: event.query));

    try {
      final result = await searchRepository.searchMovies(event.query);
      
      emit(SearchLoaded(
        movies: result.results,
        query: event.query,
        totalResults: result.totalResults,
      ));
    } catch (e) {
      emit(SearchError(message: 'Failed to search: ${e.toString()}'));
    }
  }

  void _onSearchClear(
    SearchClear event,
    Emitter<SearchState> emit,
  ) {
    _debounceTimer?.cancel();
    emit(SearchInitial());
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}

class _PerformSearchEvent extends SearchEvent {
  final String query;

  const _PerformSearchEvent({required this.query});
}