import 'package:drift/drift.dart';

enum MovieFormat {
  dvd,
  bluray,
  online
}

enum AgeRating {
  universal,    // U in UK, G in US
  parentalGuidance,  // PG
  teen,    // 12/12A in UK, PG-13 in US
  mature,  // 15 in UK, R in US
  adult    // 18 in UK, NC-17 in US
}

class MovieFormats extends TypeConverter<MovieFormat, String> {
  const MovieFormats();

  @override
  MovieFormat fromSql(String fromDb) {
    return MovieFormat.values.firstWhere(
      (format) => format.name == fromDb,
      orElse: () => MovieFormat.dvd,
    );
  }

  @override
  String toSql(MovieFormat value) {
    return value.name;
  }
}

class AgeRatings extends TypeConverter<AgeRating, String> {
  const AgeRatings();

  @override
  AgeRating fromSql(String fromDb) {
    return AgeRating.values.firstWhere(
      (rating) => rating.name == fromDb,
      orElse: () => AgeRating.parentalGuidance,
    );
  }

  @override
  String toSql(AgeRating value) {
    return value.name;
  }
}

class Locations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('Movie')
class Movies extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get director => text()();
  IntColumn get releaseYear => integer()();
  TextColumn get genre => text()();
  TextColumn get description => text().nullable()();
  TextColumn get coverImagePath => text().nullable()();
  TextColumn get format => text().map(const MovieFormats()).withDefault(Constant('dvd'))();
  TextColumn get ageRating => text().map(const AgeRatings()).withDefault(Constant('parentalGuidance'))();
  IntColumn get locationId => integer().nullable().references(Locations, #id)();
  DateTimeColumn get addedDate => dateTime().withDefault(currentDateAndTime)();
}
