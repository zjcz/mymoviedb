import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mymoviedb/route_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(
    child: MyMovieDbApp(),
  ));
}

class MyMovieDbApp extends StatelessWidget {
  const MyMovieDbApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'My Movie Db',
      color: Colors.white,
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      routerConfig: setupRouter(initialLocation: RouteDefs.home),
      // Use the following when generating screenshots to remove the debug banner
      //debugShowCheckedModeBanner: false,
    );
  }
}
