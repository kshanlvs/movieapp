import 'package:flutter/foundation.dart';

class MovieInteractionState {
  final isLiked = ValueNotifier<bool>(false);
  final isInMyList = ValueNotifier<bool>(false);
  final isBookmarked = ValueNotifier<bool>(false);
}
