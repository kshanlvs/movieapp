import 'package:flutter/material.dart';
import 'package:movieapp/features/movie_details/data/model/movie_detail_model.dart';
import 'package:movieapp/features/movie_details/presentation/state/movie_interaction_state.dart';
import 'package:movieapp/features/movie_details/widgets/movie_content_section.dart';


class MovieContentSectionView extends StatelessWidget {
  final MovieDetails details;
  final MovieInteractionState uiState;

  const MovieContentSectionView({
    super.key,
    required this.details,
    required this.uiState,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: uiState.isBookmarked,
      builder: (_, isBookmarked, __) {
        return MovieContentSection(
          details: details,
          isBookmarked: isBookmarked,
        );
      },
    );
  }
}
