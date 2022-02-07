import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:scpanel_ui/src/models/basic_info.dart';
import 'package:scpanel_ui/src/models/hive/server.dart';
import 'package:scpanel_ui/src/models/hive/user.dart';
import 'package:scpanel_ui/src/models/hive/utils.dart';

class StorageController extends GetxController {
  late Box<User> userBox;
  late Box<Server> serverBox;
  late Box<Utils> utilsBox;

  Rx<dynamic> user = Object().obs;
  Rx<dynamic> server = Object().obs;
  Rx<dynamic> utils = Object().obs;
  Rx<dynamic> basicInfo = Object().obs;

  StorageController() {
    userBox = Hive.box('user');
    serverBox = Hive.box('server');
    utilsBox = Hive.box('utils');
  }

  Future<bool> storeLoginCredentials({
    required User user,
    required Server server,
    required Utils utils,
  }) async {
    try {
      await userBox.put('user-key', user);
      await serverBox.put('server-key', server);
      await utilsBox.put('utils-key', utils);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> fetchDetails() async {
    try {
      if (utilsBox.isEmpty || serverBox.isEmpty || userBox.isEmpty) {
        return false;
      } else {
        User user = userBox.get('user-key') as User;
        Server server = serverBox.get('server-key') as Server;
        Utils utils = utilsBox.get('utils-key') as Utils;
        this.user.value = user;
        this.server.value = server;
        this.utils.value = utils;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future setUser({required User user}) async {
    await userBox.put('user-key', user);
    this.user.value = user;
  }

  Future setServer({required Server server}) async {
    await serverBox.put('server-key', server);
    this.server.value = server;
  }

  Future setUtils({required Utils utils}) async {
    await utilsBox.put('utils-key', utils);
    this.utils.value = utils;
  }

  removeData() async {
    await userBox.delete('user-key');
    await serverBox.delete('server-key');
    await utilsBox.delete('utils-key');
    user.value = Object();
    server.value = Object();
    utils.value = Object();
  }

  setBasicInfo({required BasicInfo basicInfo}) {
    this.basicInfo.value = basicInfo;
  }

  setNewHomeDir({required String path}) async {
    Server server = serverBox.get('server-key') as Server;
    server.homeDir = path;
    await serverBox.put('server-key', server);
  }
}
