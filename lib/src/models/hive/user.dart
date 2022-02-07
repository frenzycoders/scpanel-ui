import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.hostUser,
  });
  @HiveField(0)
  late final String id;
  @HiveField(1)
  late final String name;
  @HiveField(2)
  late final String email;
  @HiveField(3)
  late final String hostUser;

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    hostUser = json['host_user'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['email'] = email;
    _data['host_user'] = hostUser;
    return _data;
  }
}

