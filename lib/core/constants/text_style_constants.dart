import 'package:flutter/material.dart';
import 'package:movieapp/core/constants/app_colors.dart';
import 'package:movieapp/core/constants/font_size_constants.dart';

class TextStyles {
  static const TextStyle appBarTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: FontSizes.titleLarge,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle searchInitialTitle = TextStyle(
    color: AppColors.textSecondary,
    fontSize: FontSizes.bodyLarge,
  );

  static const TextStyle searchInitialSubtitle = TextStyle(
    color: AppColors.textSecondary,
    fontSize: FontSizes.bodyMedium,
  );

  static const TextStyle errorTitle = TextStyle(
    color: AppColors.primary,
    fontSize: FontSizes.titleLarge,
  );

  static const TextStyle searchErrorTitle = TextStyle(
    color: AppColors.textSecondary,
    fontSize: FontSizes.titleLarge,
  );

  static const TextStyle searchErrorMessage = TextStyle(
    color: AppColors.textSecondary,
    fontSize: FontSizes.bodyMedium,
  );

  static const TextStyle searchBarText = TextStyle(
    color: AppColors.textPrimary,
    fontSize: FontSizes.bodyLarge,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
  );

  static const TextStyle searchBarHintText = TextStyle(
    color: AppColors.textSecondary,
    fontSize: FontSizes.bodyLarge,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle movieItemTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: FontSizes.bodyLarge,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle movieItemSubtitle = TextStyle(
    color: AppColors.textSecondary,
    fontSize: FontSizes.bodyMedium,
  );

  static const TextStyle movieItemOverview = TextStyle(
    color: AppColors.textSecondary,
    fontSize: FontSizes.bodySmall,
  );

  static const TextStyle primaryButton = TextStyle(
    color: AppColors.textPrimary,
    fontSize: FontSizes.bodyMedium,
    fontWeight: FontWeight.w600,
  );
}

extension TextStylesExtension on BuildContext {
  TextStyles get textStyles => TextStyles();
}
