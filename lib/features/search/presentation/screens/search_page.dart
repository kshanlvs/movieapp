import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movieapp/core/constants/app_colors.dart';
import 'package:movieapp/core/constants/size_constants.dart';
import 'package:movieapp/core/constants/string_constants.dart';
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
        title: const Text(
          AppTexts.searchMovies,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: SizeConstants.appBarElevation,
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
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: SizeConstants.iconSizeXXL,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: SizeConstants.spaceL),
          Text(
            AppTexts.searchForMovies,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
          SizedBox(height: SizeConstants.spaceS),
          Text(
            AppTexts.typeToFindMovies,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(SizeConstants.pagePadding),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Container(
          height: 140,
          margin: const EdgeInsets.only(bottom: SizeConstants.spaceM),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(SizeConstants.radiusS),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[800]!,
            highlightColor: Colors.grey[700]!,
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: double.infinity,
                  color: Colors.grey[600],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(SizeConstants.paddingM),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 16,
                          width: double.infinity,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(height: SizeConstants.spaceS),
                        Container(
                          height: 14,
                          width: 100,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(height: SizeConstants.spaceM),
                        Container(
                          height: 12,
                          width: double.infinity,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(height: SizeConstants.spaceXS),
                        Container(
                          height: 12,
                          width: 200,
                          color: Colors.grey[600],
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
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.movie_filter,
              size: SizeConstants.iconSizeXXL,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: SizeConstants.spaceL),
            Text(
              AppTexts.noMoviesFound,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
            SizedBox(height: SizeConstants.spaceS),
            Text(
              AppTexts.trySearchingSomethingElse,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(SizeConstants.pagePadding),
      itemCount: state.movies.length,
      itemBuilder: (context, index) {
        final movie = state.movies[index];
        return _SearchMovieItem(movie: movie);
      },
    );
  }

  Widget _buildErrorState(String message, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: SizeConstants.iconSizeXXL,
            color: AppColors.primary,
          ),
          const SizedBox(height: SizeConstants.spaceL),
          const Text(
            AppTexts.searchFailed,
            style: TextStyle(color: AppColors.textPrimary, fontSize: 18),
          ),
          const SizedBox(height: SizeConstants.spaceS),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: SizeConstants.spaceXXXL,
            ),
            child: Text(
              message,
              style: const TextStyle(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: SizeConstants.spaceL),
          ElevatedButton(
            onPressed: () {
              context.read<SearchBloc>().add(const SearchClear());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textPrimary,
            ),
            child: const Text("Try Again"),
          ),
        ],
      ),
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
      margin: const EdgeInsets.all(SizeConstants.spaceXL),
      height: SizeConstants.buttonHeightL,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(SizeConstants.radiusS),
      ),
      child: Row(
        children: [
          // Search Icon
          Padding(
            padding: const EdgeInsets.only(
              left: SizeConstants.spaceXL,
              right: SizeConstants.spaceM,
            ),
            child: Icon(
              Icons.search_rounded,
              color: Colors.grey[200],
              size: SizeConstants.iconSizeL,
            ),
          ),

          // Search Field
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.2,
              ),
              decoration: InputDecoration(
                hintText: AppTexts.searchHintText,
                hintStyle: TextStyle(
                  color: Colors.grey[200],
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                contentPadding: const EdgeInsets.only(
                  right: SizeConstants.spaceL,
                ),
              ),
              onChanged: (value) {
                context.read<SearchBloc>().add(SearchQueryChanged(value));
              },
              textInputAction: TextInputAction.search,
              cursorColor: AppColors.primary,
              cursorWidth: SizeConstants.borderWidthM,
            ),
          ),

          // Clear Button
          if (_controller.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: SizeConstants.spaceL),
              child: GestureDetector(
                onTap: () {
                  _controller.clear();
                  context.read<SearchBloc>().add(const SearchClear());
                  _focusNode.requestFocus();
                },
                child: Container(
                  width: SizeConstants.iconSizeM,
                  height: SizeConstants.iconSizeM,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[800],
                  ),
                  child: Icon(
                    Icons.clear_rounded,
                    color: Colors.grey[400],
                    size: SizeConstants.iconSizeS,
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
        height: 140,
        margin: const EdgeInsets.only(bottom: SizeConstants.spaceM),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(SizeConstants.radiusM),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            // Movie Poster - Fixed width
            Container(
              width: 100,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(SizeConstants.radiusM),
                  bottomLeft: Radius.circular(SizeConstants.radiusM),
                ),
                color: Colors.grey[800],
              ),
              child: movie.posterPath != null
                  ? ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(SizeConstants.radiusM),
                        bottomLeft: Radius.circular(SizeConstants.radiusM),
                      ),
                      child: CachedMovieImage(
                        imageUrl: movie.posterUrl,
                        width: 100,
                        height: double.infinity,
                      ),
                    )
                  : const Center(
                      child: Icon(
                        Icons.movie,
                        color: AppColors.textSecondary,
                        size: SizeConstants.iconSizeXL,
                      ),
                    ),
            ),

            // Movie Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(SizeConstants.paddingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    SizedBox(
                      height: 40,
                      child: Text(
                        movie.title ?? AppTexts.unknownTitle,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(height: SizeConstants.spaceS),

                    // Rating and Year
                    SizedBox(
                      height: 20,
                      child: Row(
                        children: [
                          // Rating
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: SizeConstants.iconSizeS,
                              ),
                              const SizedBox(width: SizeConstants.spaceXS),
                              Text(
                                movie.voteAverage?.toStringAsFixed(1) ??
                                    AppTexts.notAvailable,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(width: SizeConstants.spaceL),

                          // Release Year
                          Text(
                            movie.year,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: SizeConstants.spaceS),

                    // Overview
                    Expanded(
                      child: Text(
                        movie.overview ?? '',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                        maxLines: 3,
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
