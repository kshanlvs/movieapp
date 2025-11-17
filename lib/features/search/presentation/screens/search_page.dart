import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movieapp/core/constants/app_colors.dart';
import 'package:movieapp/core/constants/app_radius.dart';
import 'package:movieapp/core/constants/size_constants.dart';
import 'package:movieapp/core/constants/string_constants.dart';
import 'package:movieapp/core/constants/text_style_constants.dart';
import 'package:movieapp/core/widget/error_retry_widget.dart';
import 'package:movieapp/features/movies/data/model/movie_model.dart';
import 'package:movieapp/features/movies/presentation/widgets/cached_movie_image.dart';
import 'package:movieapp/features/search/presentation/bloc/search_bloc.dart';
import 'package:movieapp/features/search/presentation/bloc/search_event.dart';
import 'package:movieapp/features/search/presentation/bloc/search_state.dart';
import 'package:shimmer/shimmer.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SearchPageContent();
  }
}

class _SearchPageContent extends StatelessWidget {
  const _SearchPageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppTexts.searchMovies, style: TextStyles.appBarTitle),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Column(
        children: [
          const _SearchBar(),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchInitial) {
                  return _buildInitialState();
                } else if (state is SearchLoading) {
                  return _buildLoadingState();
                } else if (state is SearchLoaded) {
                  return _buildResults(state);
                } else if (state is SearchError) {
                  return _buildErrorState(state.message, context);
                } else {
                  return _buildInitialState();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: AppSizes.s32,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: AppSizes.s16),
          const Text(
            AppTexts.searchForMovies,
            style: TextStyles.searchInitialTitle,
          ),
          SizedBox(height: AppSizes.s8),
          const Text(
            AppTexts.typeToFindMovies,
            style: TextStyles.searchInitialSubtitle,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: EdgeInsets.all(AppSizes.s16),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Container(
          height: AppSizes.hMovieListItem,
          margin: EdgeInsets.only(bottom: AppSizes.s12),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppRadius.r8),
          ),
          child: Shimmer.fromColors(
            baseColor: AppColors.surfaceVariant,
            highlightColor: Colors.grey[700]!,
            child: Row(
              children: [
                Container(
                  width: AppSizes.hMoviePoster,
                  height: double.infinity,
                  color: AppColors.surface,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(AppSizes.s12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: AppSizes.hShimmerTitle,
                          width: AppSizes.wShimmerFull,
                          color: AppColors.surface,
                        ),
                        SizedBox(height: AppSizes.s8),
                        Container(
                          height: AppSizes.hShimmerSubtitle,
                          width: AppSizes.wShimmerSmall,
                          color: AppColors.surface,
                        ),
                        SizedBox(height: AppSizes.s12),
                        Container(
                          height: AppSizes.hShimmerText,
                          width: AppSizes.wShimmerFull,
                          color: AppColors.surface,
                        ),
                        SizedBox(height: AppSizes.s4),
                        Container(
                          height: AppSizes.hShimmerText,
                          width: AppSizes.wShimmerMedium,
                          color: AppColors.surface,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildResults(SearchLoaded state) {
    if (state.movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.movie_filter,
              size: AppSizes.s32,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: AppSizes.s16),
            const Text(
              AppTexts.noMoviesFound,
              style: TextStyles.searchInitialTitle,
            ),
            SizedBox(height: AppSizes.s8),
            const Text(
              AppTexts.trySearchingSomethingElse,
              style: TextStyles.searchInitialSubtitle,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppSizes.s16),
      itemCount: state.movies.length,
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      cacheExtent: 500,
      itemBuilder: (context, index) {
        final movie = state.movies[index];
        return _SearchMovieItem(movie: movie);
      },
    );
  }

  Widget _buildErrorState(String message, BuildContext context) {
      return ErrorRetryWidget(
    title: AppTexts.searchFailed,
    message: message,
    onRetry: () {
      context.read<SearchBloc>().add(const SearchQueryChanged(''));
    },
  );
  }
}

class _SearchBar extends StatefulWidget {
  const _SearchBar();

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(AppSizes.s20),
      height: AppSizes.hButtonL,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.r8),
      ),
      child: Row(
        children: [
          // Search Icon
          Padding(
            padding: EdgeInsets.only(left: AppSizes.s20, right: AppSizes.s12),
            child: Icon(
              Icons.search_rounded,
              color: AppColors.textSecondary,
              size: AppSizes.s24,
            ),
          ),

          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              style: TextStyles.searchBarText,
              decoration: InputDecoration(
                hintText: AppTexts.searchHintText,
                hintStyle: TextStyles.searchBarHintText,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.only(right: AppSizes.s16),
              ),
              onChanged: (value) {
                context.read<SearchBloc>().add(SearchQueryChanged(value));
              },
              textInputAction: TextInputAction.search,
              cursorColor: AppColors.primary,
            ),
          ),

          if (_controller.text.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(right: AppSizes.s16),
              child: GestureDetector(
                onTap: () {
                  _controller.clear();
                  context.read<SearchBloc>().add(const SearchClear());
                  _focusNode.requestFocus();
                },
                child: Container(
                  width: AppSizes.s20,
                  height: AppSizes.s20,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surface,
                  ),
                  child: Icon(
                    Icons.clear_rounded,
                    color: AppColors.textSecondary,
                    size: AppSizes.s16,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }
}

class _SearchMovieItem extends StatelessWidget {
  final MovieModel movie;

  const _SearchMovieItem({required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/movie/${movie.id}');
      },
      child: Container(
        height: AppSizes.hMovieListItem,
        margin: EdgeInsets.only(bottom: AppSizes.s12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.r12),
          border: Border.all(color: AppColors.outline),
        ),
        child: Row(
          children: [
            Container(
              width: AppSizes.hMoviePoster,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.r12),
                  bottomLeft: Radius.circular(AppRadius.r12),
                ),
                color: AppColors.surfaceVariant,
              ),
              child: movie.posterPath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppRadius.r12),
                        bottomLeft: Radius.circular(AppRadius.r12),
                      ),
                      child: CachedMovieImage(
                        imageUrl: movie.posterUrl,
                        width: AppSizes.hMoviePoster,
                        height: double.infinity,
                      ),
                    )
                  : Center(
                      child: Icon(
                        Icons.movie,
                        color: AppColors.textSecondary,
                        size: AppSizes.s28,
                      ),
                    ),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.all(AppSizes.s12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        movie.title ?? AppTexts.unknownTitle,
                        style: TextStyles.movieItemTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(height: AppSizes.s8),
                    SizedBox(
                      height: AppSizes.hMovieRating,
                      child: Row(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: AppSizes.s16,
                              ),
                              SizedBox(width: AppSizes.s4),
                              Text(
                                movie.voteAverage?.toStringAsFixed(1) ??
                                    AppTexts.notAvailable,
                                style: TextStyles.movieItemSubtitle,
                              ),
                            ],
                          ),

                          SizedBox(width: AppSizes.s16),

                          Text(movie.year, style: TextStyles.movieItemSubtitle),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSizes.s8),
                    Expanded(
                      child: Text(
                        movie.overview ?? '',
                        style: TextStyles.movieItemOverview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
