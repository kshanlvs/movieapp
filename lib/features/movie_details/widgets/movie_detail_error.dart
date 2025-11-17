import 'package:flutter/material.dart';
import 'package:movieapp/core/constants/app_colors.dart';
import 'package:movieapp/core/constants/size_constants.dart';
import 'package:movieapp/core/constants/string_constants.dart';
import 'package:movieapp/core/constants/text_style_constants.dart';

class MovieDetailErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const MovieDetailErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.s24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: AppSizes.s32,
              color: AppColors.primary.withOpacity(0.7),
            ),
            SizedBox(height: AppSizes.s24),
            const Text(
              AppTexts.failedToLoadMovieDetails,
              style: TextStyles.searchErrorTitle,
            ),
            SizedBox(height: AppSizes.s12),
            Text(
              message,
              style: TextStyles.searchErrorMessage,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSizes.s24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textPrimary,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.s24,
                  vertical: AppSizes.s12,
                ),
              ),
              child: const Text(AppTexts.retry),
            ),
          ],
        ),
      ),
    );
  }
}
