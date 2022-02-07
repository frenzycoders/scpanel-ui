class BasicInfo {
  BasicInfo({
    required this.arch,
    required this.freeMemory,
    required this.homeDir,
    required this.platform,
    required this.ostype,
    required this.totalMemory,
    required this.uptime,
    required this.hostname,
    required this.totalStorage,
    required this.freeStorage,
    required this.diskPath,
  });
  late final String arch;
  late final int freeMemory;
  late final String homeDir;
  late final String platform;
  late final String ostype;
  late final int totalMemory;
  late final double uptime;
  late final String hostname;
  late final double totalStorage;
  late final double freeStorage;
  late final String diskPath;
  
  BasicInfo.fromJson(Map<String, dynamic> json){
    arch = json['arch'];
    freeMemory = json['freeMemory'];
    homeDir = json['homeDir'];
    platform = json['platform'];
    ostype = json['ostype'];
    totalMemory = json['totalMemory'];
    uptime = json['uptime'];
    hostname = json['hostname'];
    totalStorage = json['totalStorage'];
    freeStorage = json['freeStorage'];
    diskPath = json['diskPath'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['arch'] = arch;
    _data['freeMemory'] = freeMemory;
    _data['homeDir'] = homeDir;
    _data['platform'] = platform;
    _data['ostype'] = ostype;
    _data['totalMemory'] = totalMemory;
    _data['uptime'] = uptime;
    _data['hostname'] = hostname;
    _data['totalStorage'] = totalStorage;
    _data['freeStorage'] = freeStorage;
    _data['diskPath'] = diskPath;
    return _data;
  }
}