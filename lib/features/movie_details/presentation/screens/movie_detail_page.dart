import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/core/constants/app_colors.dart';
import 'package:movieapp/core/constants/size_constants.dart';
import 'package:movieapp/core/constants/string_constants.dart';
import 'package:movieapp/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:movieapp/features/bookmark/presentation/bloc/bookmark_event.dart';
import 'package:movieapp/features/bookmark/presentation/bloc/bookmark_state.dart';
import 'package:movieapp/features/movie_details/data/model/movie_detail_model.dart';
import 'package:movieapp/features/movie_details/presentation/bloc/movie_detail_bloc.dart';
import 'package:movieapp/features/movie_details/presentation/bloc/movie_detail_event.dart';
import 'package:movieapp/features/movie_details/presentation/bloc/movie_detail_state.dart';
import 'package:movieapp/features/movie_details/utils/movie_model_mapper.dart';
import 'package:movieapp/features/movie_details/widgets/action_button_row.dart';
import 'package:movieapp/features/movie_details/widgets/movie_content_section.dart';
import 'package:movieapp/features/movie_details/widgets/movie_detail_error.dart';
import 'package:movieapp/features/movie_details/widgets/movie_detail_skeletor.dart';
import 'package:movieapp/features/movie_details/widgets/movie_hero_section.dart';

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
    _initializeAnimations();
    _loadData();
    uiState = MovieInteractionState();
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
    super.dispose();
  }

  void _onBookmarkPressed(MovieDetails movieDetail) {
    final movieModel = MovieModelMapper.fromDetails(movieDetail);
    context.read<BookmarkBloc>().add(ToggleBookmark(movie: movieModel));
  }

  void _onDownloadPressed() {}

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
            const SizedBox(width: SizeConstants.spaceS),
            Text(
              isBookmarked ? AppTexts.movieSaved : AppTexts.movieRemoved,
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeConstants.radiusS),
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
                _fadeInController.forward();
                return MovieDetailBody(
                  details: movieDetail,
                  fadeAnimation: _fadeInAnimation,
                  uiState: uiState,
                  onBookmarkPressed: () => _onBookmarkPressed(movieDetail),
                  onDownloadPressed: _onDownloadPressed,
                );

              case MovieDetailError(:final message):
                return MovieDetailErrorWidget(
                  message: message,
                  onRetry: () => _loadData(),
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

class MovieDetailBody extends StatelessWidget {
  final MovieDetails details;
  final Animation<double> fadeAnimation;
  final MovieInteractionState uiState;
  final VoidCallback onBookmarkPressed;
  final VoidCallback onDownloadPressed;

  const MovieDetailBody({
    super.key,
    required this.details,
    required this.fadeAnimation,
    required this.uiState,
    required this.onBookmarkPressed,
    required this.onDownloadPressed,
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
              padding: const EdgeInsets.all(SizeConstants.spaceXL),
              child: ActionButtonsRowView(
                details: details,
                uiState: uiState,
                onBookmarkPressed: onBookmarkPressed,
                onDownloadPressed: onDownloadPressed,
              ),
            ),
          ),

          MovieContentSectionView(details: details, uiState: uiState),
        ],
      ),
    );
  }
}

class ActionButtonsRowView extends StatelessWidget {
  final MovieDetails details;
  final MovieInteractionState uiState;
  final VoidCallback onBookmarkPressed;
  final VoidCallback onDownloadPressed;

  const ActionButtonsRowView({
    super.key,
    required this.details,
    required this.uiState,
    required this.onBookmarkPressed,
    required this.onDownloadPressed,
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
        );
      },
    );
  }
}

class ValueListenableBuilder3<A, B, C> extends StatelessWidget {
  final ValueListenable<A> first;
  final ValueListenable<B> second;
  final ValueListenable<C> third;
  final Widget Function(A, B, C, Widget?) builder;
  final Widget? child;

  const ValueListenableBuilder3({
    super.key,
    required this.first,
    required this.second,
    required this.third,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: first,
      builder: (_, a, firstBuilder) {
        return ValueListenableBuilder<B>(
          valueListenable: second,
          builder: (_, b, secondBuilder) {
            return ValueListenableBuilder<C>(
              valueListenable: third,
              builder: (_, c, thirdBuilder) => builder(a, b, c, child),
            );
          },
        );
      },
    );
  }
}

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
      builder: (context, isBookmarked, _) {
        return MovieContentSection(
          details: details,
          isBookmarked: isBookmarked,
        );
      },
    );
  }
}

class MovieInteractionState {
  var isLiked = ValueNotifier<bool>(false);
  var isInMyList = ValueNotifier<bool>(false);
  var isBookmarked = ValueNotifier<bool>(false);
}
