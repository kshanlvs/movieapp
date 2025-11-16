import 'package:flutter/material.dart';
import 'package:movieapp/core/constants/app_colors.dart';
import 'package:movieapp/core/constants/size_constants.dart';
import 'package:movieapp/core/constants/string_constants.dart';

class AnimatedAppBar extends StatefulWidget implements PreferredSizeWidget {
  final ScrollController scrollController;
  final VoidCallback onBookmarkPressed;
  final VoidCallback onSearchPressed;

  const AnimatedAppBar({
    super.key,
    required this.scrollController,
    required this.onBookmarkPressed,
    required this.onSearchPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(SizeConstants.appBarHeight);

  @override
  State<AnimatedAppBar> createState() => _AnimatedAppBarState();
}

class _AnimatedAppBarState extends State<AnimatedAppBar> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final newOpacity = (widget.scrollController.offset / 100).clamp(0.0, 1.0);

    if (_opacity != newOpacity) {
      setState(() {
        _opacity = newOpacity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background.withOpacity(_opacity),
      elevation: _opacity > 0.1 ? SizeConstants.appBarElevation : 0,
      title: Row(
        children: [
          const Text(
            AppTexts.appName,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(
              Icons.bookmark,
              color: AppColors.textPrimary,
              size: SizeConstants.iconSizeM,
            ),
            onPressed: widget.onBookmarkPressed,
          ),
          IconButton(
            icon: const Icon(
              Icons.search,
              color: AppColors.textPrimary,
              size: SizeConstants.iconSizeM,
            ),
            onPressed: widget.onSearchPressed,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }
}
