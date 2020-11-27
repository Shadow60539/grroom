import 'package:hive/hive.dart';

part 'inf.g.dart';

@HiveType(typeId: 1)
class InfluencerCode {
  @HiveField(1)
  String code;
  InfluencerCode(this.code);
}
