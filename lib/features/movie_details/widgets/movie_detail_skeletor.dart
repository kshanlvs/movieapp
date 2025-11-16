// features/movie_details/presentation/widgets/movie_detail_skeleton.dart
import 'package:flutter/material.dart';
import 'package:movieapp/core/constants/app_colors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:movieapp/core/constants/size_constants.dart';

class MovieDetailSkeleton extends StatelessWidget {
  const MovieDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 380,
          flexibleSpace: Shimmer.fromColors(
            baseColor: Colors.grey.shade900,
            highlightColor: Colors.grey.shade700,
            child: Container(color: AppColors.background),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(SizeConstants.spaceXL),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade900,
              highlightColor: Colors.grey.shade700,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildActionButtonsSkeleton(),
                  const SizedBox(height: SizeConstants.spaceXXXL),
                  _buildTitleSkeleton(),
                  const SizedBox(height: SizeConstants.spaceL),
                  _buildRatingSkeleton(),
                  const SizedBox(height: SizeConstants.spaceXL),
                  _buildOverviewSkeleton(),
                  const SizedBox(height: SizeConstants.spaceXL),
                  _buildGenresSkeleton(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtonsSkeleton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        4,
        (index) => Column(
          children: [
            Container(
              width: SizeConstants.iconSizeXXXL,
              height: SizeConstants.iconSizeXXXL,
              decoration: const BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: SizeConstants.spaceXS),
            Container(height: 12, width: 40, color: AppColors.background),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSkeleton() {
    return Container(height: 28, width: 220, color: AppColors.background);
  }

  Widget _buildRatingSkeleton() {
    return Container(height: 20, width: 80, color: AppColors.background);
  }

  Widget _buildOverviewSkeleton() {
    return Column(
      children: [
        Container(
          height: 16,
          width: double.infinity,
          color: AppColors.background,
        ),
        const SizedBox(height: SizeConstants.spaceM),
        Container(
          height: 16,
          width: double.infinity,
          color: AppColors.background,
        ),
        const SizedBox(height: SizeConstants.spaceM),
        Container(height: 16, width: 200, color: AppColors.background),
      ],
    );
  }

  Widget _buildGenresSkeleton() {
    return Wrap(
      spacing: SizeConstants.spaceS,
      children: List.generate(
        3,
        (index) => Container(
          width: 70,
          height: SizeConstants.buttonHeightXS,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(SizeConstants.radiusCircle),
          ),
        ),
      ),
    );
  }
}
