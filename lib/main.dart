import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movieapp/core/config/environment.dart';
import 'package:movieapp/core/config/environment_detector.dart';
import 'package:movieapp/core/router/router_config.dart';

void main()  async{
  WidgetsFlutterBinding.ensureInitialized();

  
  try {
    await dotenv.load(fileName: '.env');
    final environment =  EnvironmentDetector.detectEnvironment();
    AppEnvironment.setEnvironment(environment);
    EnvironmentDetector.printEnvironmentInfo();
    
    runApp(const MovieApp());
  } catch (error, stackTrace) {
    if (kDebugMode) {
      print('Error initializing app: $error');
    }
    if (kDebugMode) {
      print('Stack trace: $stackTrace');
    }
    
    runApp(const MovieApp());
  }
  }

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: routerConfig,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.redAccent,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}


