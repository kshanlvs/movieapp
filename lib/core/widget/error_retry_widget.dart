import 'package:flutter/material.dart';
import 'package:movieapp/core/constants/app_colors.dart';
import 'package:movieapp/core/constants/size_constants.dart';
import 'package:movieapp/core/constants/string_constants.dart';
import 'package:movieapp/core/constants/text_style_constants.dart';

class ErrorRetryWidget extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onRetry;
  final String buttonText;
  final IconData? icon;
  final double? iconSize;

  const ErrorRetryWidget({
    super.key,
    required this.title,
    required this.message,
    required this.onRetry,
    this.buttonText = AppTexts.retry,
    this.icon = Icons.error_outline,
    this.iconSize,
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
              icon,
              size: iconSize,
              color: AppColors.primary,
            ),
            SizedBox(height: AppSizes.s16),
            Text(
              title,
              style: TextStyles.searchErrorTitle,
            ),
            SizedBox(height: AppSizes.s8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.s32),
              child: Text(
                message,
                style: TextStyles.searchErrorMessage,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: AppSizes.s16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textPrimary,
              ),
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}