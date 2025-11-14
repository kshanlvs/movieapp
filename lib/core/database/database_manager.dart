import 'package:hive_flutter/hive_flutter.dart';
import 'package:movieapp/core/database/movie_types.dart';
import 'package:movieapp/features/movies/data/model/movie_model.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseManager {
  static Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    Hive.registerAdapter(MovieModelAdapter());

    await Hive.openBox(MovieTypes.trending);
    await Hive.openBox(MovieTypes.nowPlaying);
    await Hive.openBox('bookmarks');
  }
}
