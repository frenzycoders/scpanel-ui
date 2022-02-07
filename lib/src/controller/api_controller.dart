import 'dart:convert';

import 'package:get/get.dart';
import 'package:scpanel_ui/src/HttpLogoutException.dart';
import 'package:scpanel_ui/src/controller/storage_controller.dart';
import 'package:scpanel_ui/src/http_exception.dart';
import 'package:scpanel_ui/src/models/basic_info.dart';
import 'package:scpanel_ui/src/models/directory.dart';
import 'package:scpanel_ui/src/models/fileEntity.dart';
import 'package:scpanel_ui/src/models/hive/user.dart';
import 'package:scpanel_ui/src/models/hive/utils.dart';
import 'package:scpanel_ui/src/models/host.dart';
import 'package:http/http.dart' as http;

class ApiController extends GetxController {
  late StorageController _storageController;

  ApiController() {
    _storageController = Get.find<StorageController>();
  }

  Future<Host> testHost({
    required String ip,
    required String port,
    required String httpType,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('$httpType://$ip:$port/user/test-host'),
        body: {
          "ip": ip,
          "port": port,
          "protocol": httpType,
        },
      );
      if (response.statusCode != 200) throw HttpException(response.body);
      Host host = Host.fromJson(json.decode(response.body));

      return host;
    } catch (e) {
      rethrow;
    }
  }

  loginServer(
      {required Host host,
      required String password,
      required Function cb}) async {
    try {
      http.Response response = await http.post(
        Uri.parse(
            '${host.protocol}://${host.server.ip}:${host.server.port}/user/login'),
        body: {
          "password": password,
        },
      );

      if (response.statusCode != 200) throw HttpException(response.body);

      Utils utils = Utils(
        httpType: host.protocol,
        token: json.decode(response.body)['user']['token'],
      );
      if (await _storageController.storeLoginCredentials(
          user: host.user, server: host.server, utils: utils)) {
        cb();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<User> getProfile() async {
    try {
      http.Response response = await http.get(
        Uri.parse(
          '${_storageController.utils.value?.httpType}://${_storageController.server.value?.ip}:${_storageController.server.value?.port}/user/profile',
        ),
        headers: {
          "authorization": 'Bearer ${_storageController.utils.value?.token}',
        },
      );
      if (response.statusCode != 200) throw HttpException(response.body);
      if (response.statusCode == 400) {
        await _storageController.removeData();
        throw HttpLogoutException(response.body, true);
      }
      User user = User.fromJson(json.decode(response.body)['user']);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<BasicInfo> basicInfo() async {
    try {
      http.Response response = await http.get(
        Uri.parse(
          '${_storageController.utils.value?.httpType}://${_storageController.server.value?.ip}:${_storageController.server.value?.port}/user/basic-info',
        ),
        headers: {
          "authorization": 'Bearer ${_storageController.utils.value?.token}',
        },
      );
      if (response.statusCode != 200) throw HttpException(response.body);
      if (response.statusCode == 400) {
        await _storageController.removeData();
        throw HttpLogoutException(response.body, true);
      }
      BasicInfo basicInfo = BasicInfo.fromJson(json.decode(response.body));
      return basicInfo;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkAuthenticated() async {
    try {
      if (await _storageController.fetchDetails()) {
        try {
          User user = await getProfile();
          BasicInfo basic = await basicInfo();
          await _storageController.setBasicInfo(basicInfo: basic);
          await _storageController.setUser(user: user);
          await _storageController.setUtils(
            utils: Utils(
              httpType: _storageController.utils.value?.httpType as String,
              token: _storageController.utils.value?.token as String,
            ),
          );

          return true;
        } on HttpException catch (e) {
          throw HttpException(e.message);
        } catch (e) {
          rethrow;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<List<Directory>> readFs({
    String? path,
    required bool isHidden,
  }) async {
    List<Directory> directories = [];
    List<Directory> files = [];

    String uri =
        '${_storageController.utils.value?.httpType}://${_storageController.server.value?.ip}:${_storageController.server.value?.port}/user/fs';

    if (path == null) {
      uri = uri + '?hidden=' + isHidden.toString();
    } else {
      uri = uri + '?path=' + path.toString() + '&hidden=' + isHidden.toString();
    }
    try {
      http.Response response = await http.get(
        Uri.parse(uri),
        headers: {
          'authorization': 'Bearer ${_storageController.utils.value?.token}'
        },
      );

      if (response.statusCode != 200) throw HttpException(response.body);
      json.decode(response.body)['dirs'].forEach((d) {
        Directory directory = Directory.fromJSON(d);
        if (directory.isFolder) {
          directories.add(directory);
        } else {
          files.add(directory);
        }
      });

      return directories + files;
    } catch (e) {
      rethrow;
    }
  }

  Future createFolder({
    required String path,
    required folderName,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse(
          '${_storageController.utils.value?.httpType}://${_storageController.server.value?.ip}:${_storageController.server.value?.port}/user/fs/folder?path=$path&folderName=$folderName',
        ),
        headers: {
          "authorization": 'Bearer ${_storageController.utils.value?.token}'
        },
      );
      print(response.body);
      if (response.statusCode != 200) throw HttpException(response.body);
    } catch (e) {
      rethrow;
    }
  }

  Future createFile(
      {required String path, required fileName, required String data}) async {
    try {
      http.Response response = await http.post(
          Uri.parse(
            '${_storageController.utils.value?.httpType}://${_storageController.server.value?.ip}:${_storageController.server.value?.port}/user/fs/file?path=$path&fileName=$fileName',
          ),
          headers: {
            "authorization": 'Bearer ${_storageController.utils.value?.token}'
          },
          body: {
            "data": data,
          });
      print(response.body);
      if (response.statusCode != 200) throw HttpException(response.body);
    } catch (e) {
      rethrow;
    }
  }

  Future deleteEntity({required String path}) async {
    try {
      http.Response response = await http.delete(
        Uri.parse(
          '${_storageController.utils.value?.httpType}://${_storageController.server.value?.ip}:${_storageController.server.value?.port}/user/fs?path=$path',
        ),
        headers: {
          "authorization": 'Bearer ${_storageController.utils.value?.token}'
        },
      );
      print(response.body);
      if (response.statusCode != 200) throw HttpException(response.body);
    } catch (e) {
      rethrow;
    }
  }

  Future copyEntity({required OperationType operationType}) async {
    try {
      http.Response response = await http.post(
        Uri.parse(
          '${_storageController.utils.value?.httpType}://${_storageController.server.value?.ip}:${_storageController.server.value?.port}/user/fs/copy?source=${operationType.source}&destination=${operationType.desti}',
        ),
        headers: {
          "authorization": 'Bearer ${_storageController.utils.value?.token}'
        },
      );

      if (response.statusCode != 200) throw HttpException(response.body);
    } catch (e) {
      rethrow;
    }
  }

  Future moveEntity({required OperationType operationType}) async {
    try {
      http.Response response = await http.post(
        Uri.parse(
          '${_storageController.utils.value?.httpType}://${_storageController.server.value?.ip}:${_storageController.server.value?.port}/user/fs/move?source=${operationType.source}&destination=${operationType.desti}',
        ),
        headers: {
          "authorization": 'Bearer ${_storageController.utils.value?.token}'
        },
      );

      if (response.statusCode != 200) throw HttpException(response.body);
    } catch (e) {
      rethrow;
    }
  }

  Future renameEntity({required String path, required String newName}) async {
    try {
      http.Response response = await http.post(
        Uri.parse(
          '${_storageController.utils.value?.httpType}://${_storageController.server.value?.ip}:${_storageController.server.value?.port}/user/fs/rename?path=$path&newName=$newName',
        ),
        headers: {
          "authorization": 'Bearer ${_storageController.utils.value?.token}'
        },
      );

      if (response.statusCode != 200) throw HttpException(response.body);
    } catch (e) {
      rethrow;
    }
  }

  Future readFile({required String path}) async {
    try {
      http.Response response = await http.get(
        Uri.parse(
          '${_storageController.utils.value?.httpType}://${_storageController.server.value?.ip}:${_storageController.server.value?.port}/user/fs/file?path=$path',
        ),
        headers: {
          "authorization": 'Bearer ${_storageController.utils.value?.token}'
        },
      );

      if (response.statusCode != 200) throw HttpException(response.body);
      return json.decode(response.body)['data'];
    } catch (e) {
      rethrow;
    }
  }

  logout() async {
    try {
      final response = await http.delete(
        Uri.parse(
          '${_storageController.utils.value?.httpType}://${_storageController.server.value?.ip}:${_storageController.server.value?.port}/user/logout',
        ),
        headers: {
          "authorization": 'Bearer ${_storageController.utils.value?.token}'
        },
      );
      if (response.statusCode != 200) {
        throw HttpException(response.body);
      }
      await _storageController.removeData();
      return;
    } catch (e) {
      rethrow;
    }
  }
}
