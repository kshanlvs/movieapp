import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class MovieCacheManager extends CacheManager {
  static const key = "movieCache";

  MovieCacheManager._()
    : super(
        Config(
          key,
          stalePeriod: const Duration(days: 7),
          maxNrOfCacheObjects: 200,
      
        ),
      );

  static final MovieCacheManager _instance = MovieCacheManager._();
  
  factory MovieCacheManager() => _instance;
}