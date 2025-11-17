import 'package:flutter/material.dart';
import 'package:movieapp/core/constants/app_colors.dart';
import 'package:movieapp/core/constants/font_size_constants.dart';
import 'package:movieapp/core/constants/size_constants.dart';
import 'package:movieapp/core/constants/string_constants.dart';

class ActionButtonsRow extends StatelessWidget {
  final bool isLiked;
  final bool isInMyList;
  final bool isBookmarked;
  final VoidCallback onLikePressed;
  final VoidCallback onMyListPressed;
  final VoidCallback onBookmarkPressed;
  final VoidCallback onDownloadPressed;
  final VoidCallback onPressedShare;

  const ActionButtonsRow({
    super.key,
    required this.isLiked,
    required this.isInMyList,
    required this.isBookmarked,
    required this.onLikePressed,
    required this.onMyListPressed,
    required this.onBookmarkPressed,
    required this.onDownloadPressed,
    required this.onPressedShare,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          icon: isInMyList ? Icons.check : Icons.add,
          label: AppTexts.myList,
          active: isInMyList,
          onTap: onMyListPressed,
        ),
        _buildActionButton(
          icon: isLiked ? Icons.favorite : Icons.favorite_border,
          label: AppTexts.like,
          active: isLiked,
          onTap: onLikePressed,
        ),
        _buildActionButton(
          icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
          label: AppTexts.save,
          active: isBookmarked,
          onTap: onBookmarkPressed,
        ),
        _buildActionButton(
          icon: Icons.share,
          label: AppTexts.share,
          onTap: onPressedShare,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool active = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: active ? 1.08 : 1.0,
        curve: Curves.easeOut,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.s20,
            vertical: AppSizes.s2,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: active ? AppColors.primary : AppColors.textPrimary,
                size: AppSizes.s24,
              ),
              SizedBox(height: AppSizes.s4),
              Text(
                label,
                style: TextStyle(
                  color: active ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                  fontSize: FontSizes.labelSmall,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
