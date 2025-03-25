import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mymoviedb/app/widgets/age_rating_dropdown.dart';
import 'package:mymoviedb/app/widgets/location_dropdown.dart';
import 'package:mymoviedb/app/widgets/movie_format_dropdown.dart';
import 'package:mymoviedb/data/database.dart';
import 'package:mymoviedb/data/tables.dart';
import 'package:mymoviedb/extensions/material_colors.dart';
import 'package:mymoviedb/providers/movie_controller.dart';
import 'package:mymoviedb/route_config.dart';

class EditMovieScreen extends ConsumerStatefulWidget {
  static const titleKey = Key('title');
  static const directorKey = Key('director');
  static const releaseKey = Key('release');
  static const genreKey = Key('genre');
  static const descKey = Key('desc');
  final Movie? movie;

  const EditMovieScreen({super.key, required this.movie});

  @override
  ConsumerState<EditMovieScreen> createState() => _EditMovieScreenState();
}

class _EditMovieScreenState extends ConsumerState<EditMovieScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _unsavedChanges = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _directorController = TextEditingController();
  final TextEditingController _releaseYearController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _coverImagePath;
  MovieFormat _format = MovieFormat.dvd;
  AgeRating _ageRating = AgeRating.universal;
  int? _locationId;

  @override
  void initState() {
    super.initState();

    if (widget.movie != null) {
      _titleController.text = widget.movie!.title;
      _directorController.text = widget.movie!.director;
      _releaseYearController.text = widget.movie!.releaseYear.toString();
      _genreController.text = widget.movie!.genre;
      _descriptionController.text = widget.movie!.description ?? "";
      _coverImagePath = widget.movie!.coverImagePath;
      _format = widget.movie!.format;
      _ageRating = widget.movie!.ageRating;
      _locationId = widget.movie!.locationId;
    }
  }

  void _onChanged() {
    if (_unsavedChanges) {
      return;
    }
    setState(() {
      _unsavedChanges = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(widget.movie == null ? 'Add Movie' : 'Edit Movie'),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: context.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                child: Text('Save',
                    style: TextStyle(
                      backgroundColor: context.primary,
                      color: context.onPrimary,
                    )),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (!await _saveData()) {
                      // an error occurred and we cannot save?
                      return;
                    }

                    if (!context.mounted) return;
                    context.pop();
                  }
                },
              ),
            ]),
        body: SafeArea(
          minimum: const EdgeInsets.all(10.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Form(
              canPop: !_unsavedChanges,
              onPopInvokedWithResult: (bool didPop, _) async {
                if (didPop) {
                  return;
                }
                await _showSaveChangesDialog();
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 20,
                  children: [
                    TextFormField(
                      key: EditMovieScreen.titleKey,
                      autofocus: true,
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: "Title"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter some text";
                        }
                        return null;
                      },
                      onChanged: (val) {
                        _onChanged();
                      },
                    ),
                    TextFormField(
                      key: EditMovieScreen.directorKey,
                      controller: _directorController,
                      decoration: const InputDecoration(labelText: "Director"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter some text";
                        }
                        return null;
                      },
                      onChanged: (val) {
                        _onChanged();
                      },
                    ),
                    TextFormField(
                      key: EditMovieScreen.releaseKey,
                      controller: _releaseYearController,
                      decoration:
                          const InputDecoration(labelText: "Release Year"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter some text";
                        }
                        return null;
                      },
                      onChanged: (val) {
                        _onChanged();
                      },
                    ),
                    TextFormField(
                      key: EditMovieScreen.genreKey,
                      controller: _genreController,
                      decoration: const InputDecoration(labelText: "Genre"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter some text";
                        }
                        return null;
                      },
                      onChanged: (val) {
                        _onChanged();
                      },
                    ),
                    TextFormField(
                      key: EditMovieScreen.descKey,
                      keyboardType: TextInputType.multiline,
                      minLines: 3,
                      maxLines: 10,
                      controller: _descriptionController,
                      decoration:
                          const InputDecoration(labelText: "Description"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter some text";
                        }
                        return null;
                      },
                      onChanged: (val) {
                        _onChanged();
                      },
                    ),
                    LocationDropdown(
                      locationId: _locationId,
                      onChanged: (value) {
                        _locationId = value?.id;
                        _unsavedChanges = true;
                      },
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue,
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text('Manage Locations',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            )),
                        onPressed: () async {
                          context.push(RouteDefs.manageLocations);
                        },
                      ),
                    ),
                    MovieFormatDropdown(
                        selectedFormat: _format,
                        onChanged: (value) {
                          _format = value ?? MovieFormat.dvd;
                          _onChanged();
                        }),
                    AgeRatingDropdown(
                        value: _ageRating,
                        onChanged: (value) {
                          _ageRating = value ?? AgeRating.parentalGuidance;
                          _onChanged();
                        }),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future<void> _showSaveChangesDialog() async {
    final bool? shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Any unsaved changes will be lost!'),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes, discard my changes'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            TextButton(
              child: const Text('No, continue editing'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );

    if (shouldDiscard ?? false) {
      if (!mounted) return;
      context.pop();
    }
  }

  Future<bool> _saveData() async {
    final provider = ref.read(movieControllerProvider.notifier);

    if (widget.movie == null) {
      provider.addMovie(
        _titleController.text,
        _directorController.text,
        int.tryParse(_releaseYearController.text) ?? 0,
        _genreController.text,
        _descriptionController.text,
        _coverImagePath,
        _format,
        _ageRating,
        _locationId,
      );
    } else {
      provider.updateMovie(
        widget.movie!.copyWith(
          title: _titleController.text,
          director: _directorController.text,
          releaseYear: int.tryParse(_releaseYearController.text) ?? 0,
          genre: _genreController.text,
          description: drift.Value(_descriptionController.text),
          coverImagePath: drift.Value(_coverImagePath),
          format: _format,
          ageRating: _ageRating,
          locationId: drift.Value(_locationId),
        ),
      );
    }

    return true;
  }
}
