import 'package:flutter/material.dart';
import 'package:movieapp/core/constants/size_constants.dart';
import 'package:movieapp/features/movie_details/data/model/movie_detail_model.dart';
import 'package:movieapp/features/movie_details/presentation/state/movie_interaction_state.dart';
import 'package:movieapp/features/movie_details/widgets/action_button_row_view.dart';
import 'package:movieapp/features/movie_details/widgets/movie_context_section_view.dart';
import 'package:movieapp/features/movie_details/widgets/movie_hero_section.dart';

class MovieDetailBody extends StatelessWidget {
  final MovieDetails details;
  final Animation<double> fadeAnimation;
  final MovieInteractionState uiState;
  final VoidCallback onBookmarkPressed;
  final VoidCallback onDownloadPressed;
  final VoidCallback onSharePressed;

  const MovieDetailBody({
    super.key,
    required this.details,
    required this.fadeAnimation,
    required this.uiState,
    required this.onBookmarkPressed,
    required this.onDownloadPressed,
    required this.onSharePressed,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: CustomScrollView(
        slivers: [
          MovieHeroSection(details: details),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppSizes.s20),
              child: ActionButtonsRowView(
                details: details,
                uiState: uiState,
                onBookmarkPressed: onBookmarkPressed,
                onDownloadPressed: onDownloadPressed,
                onSharePressed: onSharePressed,
              ),
            ),
          ),

          MovieContentSectionView(details: details, uiState: uiState),
        ],
      ),
    );
  }
}
