//Response formate
//{
//       "name": "Android",
//       "isFolder": true,
//       "path": "/home/jack/Android"
// }

//Model

class Directory {
  String name;
  bool isFolder;
  String path;

  Directory({required this.name, required this.isFolder, required this.path});

  Directory.fromJSON(Map<String, dynamic> json)
      : name = json['name'],
        isFolder = json['isFolder'],
        path = json['path'];
}
