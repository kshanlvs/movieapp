import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/core/constants/app_colors.dart';
import 'package:movieapp/core/constants/app_radius.dart';
import 'package:movieapp/core/constants/size_constants.dart';
import 'package:movieapp/core/constants/string_constants.dart';
import 'package:movieapp/core/constants/text_style_constants.dart';
import 'package:movieapp/core/deeplink/deep_link_service.dart';
import 'package:movieapp/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:movieapp/features/bookmark/presentation/bloc/bookmark_event.dart';
import 'package:movieapp/features/bookmark/presentation/bloc/bookmark_state.dart';
import 'package:movieapp/features/movie_details/data/model/movie_detail_model.dart';
import 'package:movieapp/features/movie_details/presentation/bloc/movie_detail_bloc.dart';
import 'package:movieapp/features/movie_details/presentation/bloc/movie_detail_event.dart';
import 'package:movieapp/features/movie_details/presentation/bloc/movie_detail_state.dart';
import 'package:movieapp/features/movie_details/presentation/state/movie_interaction_state.dart';
import 'package:movieapp/features/movie_details/utils/movie_model_mapper.dart';
import 'package:movieapp/features/movie_details/widgets/movie_detail_body.dart';
import 'package:movieapp/features/movie_details/widgets/movie_detail_skeletor.dart';
import 'package:movieapp/features/movie_details/widgets/share_dialog.dart';





class MovieDetailPage extends StatefulWidget {
  final int movieId;

  const MovieDetailPage({super.key, required this.movieId});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeInController;
  late final Animation<double> _fadeInAnimation;
  late final MovieInteractionState uiState;

  @override
  void initState() {
    super.initState();
    uiState = MovieInteractionState();
    _initializeAnimations();
    _loadData();
  }

  void _initializeAnimations() {
    _fadeInController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeInAnimation = CurvedAnimation(
      parent: _fadeInController,
      curve: Curves.easeOut,
    );
  }

  void _loadData() {
    context.read<MovieDetailBloc>().add(
          LoadMovieDetail(movieId: widget.movieId),
        );
    context.read<BookmarkBloc>().add(
          CheckBookmarkStatus(movieId: widget.movieId),
        );
  }

  @override
  void dispose() {
    _fadeInController.dispose();
    uiState.isLiked.dispose();
    uiState.isInMyList.dispose();
    uiState.isBookmarked.dispose();
    super.dispose();
  }

  void _onBookmarkPressed(MovieDetails movieDetail) {
    final movieModel = MovieModelMapper.fromDetails(movieDetail);
    context.read<BookmarkBloc>().add(ToggleBookmark(movie: movieModel));
  }

  void _onDownloadPressed() {
    // TODO: wire download flow
  }

  void _onSharePressed(MovieDetails movieDetail) {
    final shareMessage = DeepLinkService.createMovieShareMessage(
      widget.movieId,
      movieDetail.title,
    );

    showShareDialog(context, shareMessage, () {
      _copyToClipboard(shareMessage);
      Navigator.pop(context);
    });
  }

  Future<void> _copyToClipboard(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      _showShareSuccess();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to copy link')),
      );
    }
  }

  void _showShareSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppColors.surface,
        content: Text(
          'Movie link copied to clipboard!',
          style: TextStyles.movieItemOverview,
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showBookmarkSnackbar(bool isBookmarked) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isBookmarked ? Colors.green[800] : Colors.red[800],
        content: Row(
          children: [
            Icon(
              isBookmarked ? Icons.bookmark_added : Icons.bookmark_remove,
              color: AppColors.textPrimary,
            ),
            SizedBox(width: AppSizes.s8),
            Text(
              isBookmarked ? AppTexts.movieSaved : AppTexts.movieRemoved,
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r8),
        ),
      ),
    );
  }

  BlocListener<BookmarkBloc, BookmarkState> _buildBookmarkListener() {
    return BlocListener<BookmarkBloc, BookmarkState>(
      listener: (context, state) {
        if (state is BookmarkUpdated && state.movieId == widget.movieId) {
          setState(() => uiState.isBookmarked.value = state.isBookmarked);
          _showBookmarkSnackbar(state.isBookmarked);
        } else if (state is BookmarkStatusChecked &&
            state.movieId == widget.movieId) {
          setState(() => uiState.isBookmarked.value = state.isBookmarked);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: MultiBlocListener(
        listeners: [_buildBookmarkListener()],
        child: BlocBuilder<MovieDetailBloc, MovieDetailState>(
          builder: (context, state) {
            switch (state) {
              case MovieDetailLoading():
              case MovieDetailInitial():
                return const MovieDetailSkeleton();

              case MovieDetailLoaded(:final movieDetail):
                if (!_fadeInController.isAnimating &&
                    _fadeInController.value == 0.0) {
                  _fadeInController.forward();
                }
                return MovieDetailBody(
                  details: movieDetail,
                  fadeAnimation: _fadeInAnimation,
                  uiState: uiState,
                  onBookmarkPressed: () => _onBookmarkPressed(movieDetail),
                  onDownloadPressed: _onDownloadPressed,
                  onSharePressed: () => _onSharePressed(movieDetail),
                );

              case MovieDetailError(:final message):
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSizes.s20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          message,
                          style: TextStyles.primaryButton,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: AppSizes.s12),
                        OutlinedButton(
                          onPressed: _loadData,
                          child: const Text('Retry'),
                        )
                      ],
                    ),
                  ),
                );

              default:
                return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
