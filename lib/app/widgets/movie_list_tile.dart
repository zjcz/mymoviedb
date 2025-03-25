import 'package:flutter/material.dart';
import 'package:mymoviedb/data/database.dart';
import 'package:mymoviedb/extensions/material_colors.dart';

class MovieListTile extends StatelessWidget {
  const MovieListTile({
    super.key,
    required this.movie,
    required this.onTap,
  });

  static const int descriptionPreviewLength = 100;
  final Movie movie;
  final Function() onTap;

  String getShortDescription(String? description) {
    if (description == null) {
      return '';
    }
    if (description.length <= descriptionPreviewLength) {
      return description;
    }
    return '${description.substring(0, descriptionPreviewLength)}...';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: context.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(5)),
        child: Container(
          padding: const EdgeInsets.all(10),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title,
                      style: Theme.of(context).textTheme.titleLarge),
                  Text(getShortDescription(movie.description),
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.normal)),
                ]),
          ]),
        ),
      ),
    );
  }
}
