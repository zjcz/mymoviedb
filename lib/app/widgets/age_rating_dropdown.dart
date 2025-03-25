import 'package:flutter/material.dart';
import 'package:mymoviedb/data/tables.dart';

class AgeRatingDropdown extends StatelessWidget {
  final AgeRating? value;
  final void Function(AgeRating?) onChanged;

  const AgeRatingDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<AgeRating>(
      decoration: const InputDecoration(labelText: "Age Rating"),
      value: value,
      items: AgeRating.values.map((rating) {
        return DropdownMenuItem(
          value: rating,
          child: Text(rating.niceName),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
