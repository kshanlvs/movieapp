import 'package:flutter/material.dart';
import 'package:movieapp/features/movie_details/data/model/movie_detail_model.dart';
import 'package:movieapp/features/movie_details/presentation/state/movie_interaction_state.dart';
import 'package:movieapp/features/movie_details/widgets/action_button_row.dart';
import 'package:movieapp/features/movie_details/widgets/value_listeneable_builder_3.dart';

class ActionButtonsRowView extends StatelessWidget {
  final MovieDetails details;
  final MovieInteractionState uiState;
  final VoidCallback onBookmarkPressed;
  final VoidCallback onDownloadPressed;
  final VoidCallback onSharePressed;

  const ActionButtonsRowView({
    super.key,
    required this.details,
    required this.uiState,
    required this.onBookmarkPressed,
    required this.onDownloadPressed,
    required this.onSharePressed,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder3<bool, bool, bool>(
      first: uiState.isLiked,
      second: uiState.isInMyList,
      third: uiState.isBookmarked,
      builder: (isLiked, isInMyList, isBookmarked, _) {
        return ActionButtonsRow(
          isLiked: isLiked,
          isInMyList: isInMyList,
          isBookmarked: isBookmarked,
          onLikePressed: () => uiState.isLiked.value = !isLiked,
          onMyListPressed: () => uiState.isInMyList.value = !isInMyList,
          onBookmarkPressed: onBookmarkPressed,
          onDownloadPressed: onDownloadPressed,
          onPressedShare: onSharePressed,
        );
      },
    );
  }
}
