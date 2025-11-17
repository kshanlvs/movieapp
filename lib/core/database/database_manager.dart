import 'package:hive_flutter/hive_flutter.dart';
import 'package:movieapp/core/database/movie_types.dart';
import 'package:movieapp/features/movies/data/model/movie_model.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseManager {
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);
    Hive.registerAdapter(MovieModelAdapter());

    await Hive.openBox(MovieTypes.trending);
    await Hive.openBox(MovieTypes.nowPlaying);
    await Hive.openBox(MovieTypes.bookmarked);

    _isInitialized = true;
  }

  Future<void> close() async {
    await Hive.close();
    _isInitialized = false;
  }

  bool get isInitialized => _isInitialized;
}
