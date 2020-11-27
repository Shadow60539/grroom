import 'package:hive/hive.dart';

part 'location.g.dart';

@HiveType(typeId: 2)
class Location {
  @HiveField(1)
  String lastLocation;
  Location(this.lastLocation);
}
