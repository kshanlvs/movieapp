abstract class SearchEvent {
  const SearchEvent();
}

class SearchQueryChanged extends SearchEvent {
  final String query;

  const SearchQueryChanged(this.query);
}

class SearchClear extends SearchEvent {
  const SearchClear();
}