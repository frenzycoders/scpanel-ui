import 'package:get/get.dart';
import 'package:scpanel_ui/src/controller/home_page_controller.dart';

class HomePageBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(HomePageController());
  }
}
