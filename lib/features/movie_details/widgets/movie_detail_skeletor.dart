import 'package:flutter/material.dart';
import 'package:movieapp/core/constants/app_colors.dart';
import 'package:movieapp/core/constants/app_radius.dart';
import 'package:movieapp/core/constants/size_constants.dart';
import 'package:shimmer/shimmer.dart';

class MovieDetailSkeleton extends StatelessWidget {
  const MovieDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: AppSizes.s380,
          flexibleSpace: Shimmer.fromColors(
            baseColor: Colors.grey.shade900,
            highlightColor: Colors.grey.shade700,
            child: Container(color: AppColors.background),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.s20),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade900,
              highlightColor: Colors.grey.shade700,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildActionButtonsSkeleton(),
                  SizedBox(height: AppSizes.s32),
                  _buildTitleSkeleton(),
                  SizedBox(height: AppSizes.s16),
                  _buildRatingSkeleton(),
                  SizedBox(height: AppSizes.s20),
                  _buildOverviewSkeleton(),
                  SizedBox(height: AppSizes.s20),
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
              width: AppSizes.s40,
              height: AppSizes.s40,
              decoration: const BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(height: AppSizes.s4),
            Container(
              height: AppSizes.hShimmerText,
              width: AppSizes.wShimmerSmall,
              color: AppColors.background,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSkeleton() {
    return Container(
      height: AppSizes.hShimmerTitle,
      width: AppSizes.wShimmerMedium,
      color: AppColors.background,
    );
  }

  Widget _buildRatingSkeleton() {
    return Container(
      height: AppSizes.hShimmerSubtitle,
      width: AppSizes.wShimmerXSmall,
      color: AppColors.background,
    );
  }

  Widget _buildOverviewSkeleton() {
    return Column(
      children: [
        Container(
          height: AppSizes.hShimmerText,
          width: double.infinity,
          color: AppColors.background,
        ),
        SizedBox(height: AppSizes.s12),
        Container(
          height: AppSizes.hShimmerText,
          width: double.infinity,
          color: AppColors.background,
        ),
        SizedBox(height: AppSizes.s12),
        Container(
          height: AppSizes.hShimmerText,
          width: AppSizes.wShimmerMedium,
          color: AppColors.background,
        ),
      ],
    );
  }

  Widget _buildGenresSkeleton() {
    return Wrap(
      spacing: AppSizes.s8,
      children: List.generate(
        3,
        (index) => Container(
          width: AppSizes.wShimmerXSmall,
          height: AppSizes.hButtonXS,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(AppRadius.r20),
          ),
        ),
      ),
    );
  }
}
