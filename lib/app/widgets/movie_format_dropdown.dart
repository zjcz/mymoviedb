import 'package:flutter/material.dart';
import 'package:mymoviedb/data/tables.dart';

class MovieFormatDropdown extends StatelessWidget {
  final MovieFormat? selectedFormat;
  final ValueChanged<MovieFormat?> onChanged;

  const MovieFormatDropdown({
    super.key,
    required this.selectedFormat,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<MovieFormat>(
      decoration: const InputDecoration(labelText: "Movie Format"),
      value: selectedFormat,
      items: MovieFormat.values.map((format) {
        return DropdownMenuItem<MovieFormat>(
          value: format,
          child: Text(format.niceName),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
