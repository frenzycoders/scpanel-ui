import 'package:hive/hive.dart';

part 'utils.g.dart';

@HiveType(typeId: 2)
class Utils {
  @HiveField(0)
  String httpType;
  @HiveField(1)
  String token;
  Utils({required this.httpType, required this.token});
}
