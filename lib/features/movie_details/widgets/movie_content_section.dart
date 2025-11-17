import 'package:flutter/material.dart';
import 'package:movieapp/core/constants/app_colors.dart';
import 'package:movieapp/core/constants/app_radius.dart';
import 'package:movieapp/core/constants/font_size_constants.dart';
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
        padding: EdgeInsets.all(AppSizes.s20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSizes.s20),
            _buildTitleSection(details),
            SizedBox(height: AppSizes.s12),
            _buildRatingSection(details, isBookmarked),
            SizedBox(height: AppSizes.s20),
            _buildOverviewSection(details),
            SizedBox(height: AppSizes.s20),
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
        fontSize: FontSizes.headlineMedium,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        height: 1.2,
      ),
    );
  }

  Widget _buildRatingSection(MovieDetails details, bool isBookmarked) {
    return Row(
      children: [
        Icon(Icons.star, color: Colors.amber, size: AppSizes.s20),
        SizedBox(width: AppSizes.s4),
        Text(
          details.voteAverage.toStringAsFixed(1),
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: FontSizes.bodyLarge,
          ),
        ),
        const Spacer(),
        if (isBookmarked) _buildBookmarkIndicator(),
      ],
    );
  }

  Widget _buildBookmarkIndicator() {
    return Row(
      children: [
        Icon(Icons.bookmark, color: AppColors.primary, size: AppSizes.s16),
        SizedBox(width: AppSizes.s4),
        const Text(
          AppTexts.saved,
          style: TextStyle(
            color: AppColors.primary,
            fontSize: FontSizes.bodyMedium,
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
        fontSize: FontSizes.bodyLarge,
        height: 1.4,
      ),
    );
  }

  Widget _buildGenresSection(MovieDetails details) {
    return Wrap(
      spacing: AppSizes.s8,
      runSpacing: AppSizes.s8,
      children: details.genres
          .map(
            (genre) => Chip(
              label: Text(
                genre.name,
                style: const TextStyle(
                  fontSize: FontSizes.bodySmall,
                  color: AppColors.textPrimary,
                ),
              ),
              backgroundColor: AppColors.surfaceVariant,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.r20),
              ),
            ),
          )
          .toList(),
    );
  }
}
