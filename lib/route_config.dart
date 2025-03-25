import 'package:flutter/material.dart';
import 'package:mymoviedb/app/edit_movie_screen.dart';
import 'package:mymoviedb/app/home_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:mymoviedb/app/list_locations_screen.dart';
import 'package:mymoviedb/data/database.dart';

class RouteDefs {
  static const String home = '/';
  static const String viewMovie = '/view_movie';
  static const String lookupMovie = '/lookup_movie';
  static const String editMovie = '/edit_movie';
  static const String manageLocations = '/manage_locations';

  static String getPageName(String pageName, {String? parentPage}) {
    return pageName.replaceAll(parentPage ?? '', '');
  }
}

// The route configuration.
GoRouter setupRouter(
    {String? initialLocation,
    Object? initialExtra,
    List<NavigatorObserver>? observers,
    bool testing = false}) {
  return GoRouter(
    initialLocation: initialLocation ?? RouteDefs.home,
    initialExtra: initialExtra,
    observers: observers,
    routes: <RouteBase>[
      GoRoute(
        path: RouteDefs.home,
        name: 'home',
        builder: (_, __) => const HomeScreen(),
        routes: <RouteBase>[
          GoRoute(
              path: RouteDefs.getPageName(RouteDefs.editMovie,
                  parentPage: RouteDefs.home),
              builder: (context, state) {
                Movie? m;
                if (state.extra != null) {
                  m = state.extra! as Movie;
                }

                return EditMovieScreen(movie: m);
              }),
          GoRoute(
              path: RouteDefs.getPageName(RouteDefs.manageLocations,
                  parentPage: RouteDefs.home),
              builder: (_, __) => const ListLocationsScreen()),
        ],
      )
    ],
  );
}
