import 'package:flutter/material.dart';
import 'package:movieapp/core/constants/app_colors.dart';
import 'package:movieapp/core/constants/app_radius.dart';
import 'package:movieapp/core/constants/font_size_constants.dart';
import 'package:movieapp/core/constants/size_constants.dart';
import 'package:movieapp/core/constants/text_style_constants.dart';
import 'package:movieapp/core/constants/string_constants.dart';

void showShareDialog(
  BuildContext context,
  String message,
  VoidCallback onCopy,
) {
  showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r20),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.s24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppSizes.s12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadius.r12),
                  ),
                  child: const Icon(
                    Icons.share_rounded,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: AppSizes.s12),
                const Expanded(
                  child: Text(
                    'Share Movie',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: FontSizes.titleLarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: AppSizes.s20),
            const Text(
              'Copy the link below to share this movie:',
              style: TextStyles.movieItemOverview,
            ),
            SizedBox(height: AppSizes.s16),

            Container(
              padding: EdgeInsets.all(AppSizes.s16),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.r12),
                border: Border.all(color: AppColors.outline.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SelectableText(
                      message,
                      style: TextStyles.movieItemOverview.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSizes.s12),
                  GestureDetector(
                    onTap: onCopy,
                    child: Container(
                      padding: EdgeInsets.all(AppSizes.s12),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppRadius.r8),
                      ),
                      child: const Icon(
                        Icons.copy_rounded,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSizes.s24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(AppTexts.cancel),
                  ),
                ),
                SizedBox(width: AppSizes.s12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onCopy,
                    child: const Text('Copy Link'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
