import 'package:flutter/material.dart';
import 'package:movieapp/core/constants/app_colors.dart';
import 'package:movieapp/core/constants/size_constants.dart';
import 'package:movieapp/core/constants/string_constants.dart';
import 'package:movieapp/features/movie_details/data/model/movie_detail_model.dart';

class MovieContentSection extends StatelessWidget {
  final MovieDetails details;
  final bool isBookmarked;

  const MovieContentSection({
    super.key,
    required this.details,
    required this.isBookmarked,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(SizeConstants.spaceXL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: SizeConstants.spaceXL),
            _buildTitleSection(details),
            const SizedBox(height: SizeConstants.spaceM),
            _buildRatingSection(details, isBookmarked),
            const SizedBox(height: SizeConstants.spaceXL),
            _buildOverviewSection(details),
            const SizedBox(height: SizeConstants.spaceXL),
            _buildGenresSection(details),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection(MovieDetails details) {
    return Text(
      details.title,
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        height: 1.2,
      ),
    );
  }

  Widget _buildRatingSection(MovieDetails details, bool isBookmarked) {
    return Row(
      children: [
        Icon(Icons.star, color: Colors.amber, size: SizeConstants.iconSizeM),
        const SizedBox(width: SizeConstants.spaceXS),
        Text(
          details.voteAverage.toStringAsFixed(1),
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 16),
        ),
        const Spacer(),
        if (isBookmarked) _buildBookmarkIndicator(),
      ],
    );
  }

  Widget _buildBookmarkIndicator() {
    return Row(
      children: [
        Icon(
          Icons.bookmark,
          color: AppColors.primary,
          size: SizeConstants.iconSizeS,
        ),
        const SizedBox(width: SizeConstants.spaceXS),
        Text(
          AppTexts.saved,
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewSection(MovieDetails details) {
    return Text(
      details.overview ?? "",
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 16,
        height: 1.4,
      ),
    );
  }

  Widget _buildGenresSection(MovieDetails details) {
    return Wrap(
      spacing: SizeConstants.spaceS,
      runSpacing: SizeConstants.spaceS,
      children: details.genres
          .map(
            (genre) => Chip(
              label: Text(genre.name, style: const TextStyle(fontSize: 13)),
              backgroundColor: Colors.white12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeConstants.radiusCircle),
              ),
            ),
          )
          .toList(),
    );
  }
}
