import 'package:hive/hive.dart';

part 'server.g.dart';

@HiveType(typeId: 1)
class Server extends HiveObject {
  Server({
    required this.id,
    required this.ip,
    required this.port,
    required this.status,
    required this.error,
    required this.email,
    required this.homeDir,
  });
  @HiveField(0)
  late final int id;
  @HiveField(1)
  late final String ip;
  @HiveField(2)
  late final String port;
  @HiveField(3)
  late final bool status;
  @HiveField(4)
  late final bool error;
  @HiveField(5)
  late final String email;
  @HiveField(6)
  late final String homeDir;

  Server.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ip = json['ip'];
    port = json['port'];
    status = json['status'];
    error = json['error'];
    email = json['email'];
    homeDir = json['homeDir'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['ip'] = ip;
    _data['port'] = port;
    _data['status'] = status;
    _data['error'] = error;
    _data['email'] = email;
    _data['homeDir'] = homeDir;
    return _data;
  }
}
