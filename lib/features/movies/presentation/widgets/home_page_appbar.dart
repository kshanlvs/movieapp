import 'package:flutter/material.dart';
import 'package:movieapp/core/constants/app_colors.dart';
import 'package:movieapp/core/constants/font_size_constants.dart';
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
  Size get preferredSize => Size.fromHeight(AppSizes.hAppBar);

  @override
  State<AnimatedAppBar> createState() => _AnimatedAppBarState();
}

class _AnimatedAppBarState extends State<AnimatedAppBar> {
  double _opacity = 0.0;
  bool _isControllerAttached = false;

  @override
  void initState() {
    super.initState();
    _attachScrollListener();
  }

  void _attachScrollListener() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isControllerAttached) {
        widget.scrollController.addListener(_onScroll);
        _isControllerAttached = true;
      }
    });
  }

  void _onScroll() {
    if (widget.scrollController.hasClients) {
      final newOpacity = (widget.scrollController.offset / 100).clamp(0.0, 1.0);
      if (_opacity != newOpacity) {
        setState(() {
          _opacity = newOpacity;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background.withOpacity(_opacity),
      elevation: _opacity > 0.1 ? 4 : 0,
      title: Row(
        children: [
          const Text(
            AppTexts.appName,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: FontSizes.headlineSmall,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              Icons.bookmark,
              color: AppColors.textPrimary,
              size: AppSizes.s20,
            ),
            onPressed: widget.onBookmarkPressed,
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: AppColors.textPrimary,
              size: AppSizes.s20,
            ),
            onPressed: widget.onSearchPressed,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    if (_isControllerAttached) {
      widget.scrollController.removeListener(_onScroll);
    }
    super.dispose();
  }
}
