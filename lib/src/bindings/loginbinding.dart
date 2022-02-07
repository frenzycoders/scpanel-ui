import 'package:get/get.dart';
import 'package:scpanel_ui/src/controller/login_controller.dart';

class LoginBindigs extends Bindings {
  @override
  void dependencies() {
    // ignore: todo
    // TODO: implement dependencies
    Get.put(LoginController());
  }
}
