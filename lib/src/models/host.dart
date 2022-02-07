import 'package:scpanel_ui/src/models/hive/server.dart';
import 'package:scpanel_ui/src/models/hive/user.dart';

class Host {
  Host({
    required this.user,
    required this.server,
    required this.protocol,
  });
  
  late final User user;
  late final Server server;
  late final String protocol;

  Host.fromJson(Map<String, dynamic> json) {
    user = User.fromJson(json['user']);
    server = Server.fromJson(json['server']);
    protocol = json['protocol'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['user'] = user.toJson();
    _data['server'] = server.toJson();
    _data['protocol'] = protocol;
    return _data;
  }
}

