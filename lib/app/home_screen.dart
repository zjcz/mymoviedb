import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mymoviedb/app/widgets/movie_list.dart';
import 'package:mymoviedb/data/database.dart';
import 'package:mymoviedb/providers/movie_controller.dart';
import 'package:mymoviedb/route_config.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final movies = ref.watch(movieControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Movies'),
      ),
      body: Center(
        child: movies.when(
          data: (List<Movie> movies) {
            return MovieList(
              moviesList: movies,
              onEditMovie: (id) {
                context.go(RouteDefs.editMovie,
                    extra: movies.where((m) => m.id == id).first);
              },
            );
          },
          loading: () => buildLoadingWidget(),
          error: (error, _) => buildErrorWidget(error),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go(RouteDefs.editMovie);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildLoadingWidget() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget buildErrorWidget(Object error) {
    return Center(child: Text('Error loading data: $error'));
  }
}
