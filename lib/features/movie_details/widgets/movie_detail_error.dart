import 'package:flutter/material.dart';
import 'package:movieapp/core/constants/app_colors.dart';
import 'package:movieapp/core/constants/size_constants.dart';
import 'package:movieapp/core/constants/string_constants.dart';

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
        padding: const EdgeInsets.all(SizeConstants.spaceXXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline, 
              size: SizeConstants.iconSizeXXL, 
              color: AppColors.primary.withOpacity(0.7)
            ),
            const SizedBox(height: SizeConstants.spaceXXL),
            const Text(
              'Failed to load movie details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: SizeConstants.spaceM),
            Text(
              message,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: SizeConstants.spaceXXL),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: SizeConstants.paddingXXL, 
                  vertical: SizeConstants.paddingM
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