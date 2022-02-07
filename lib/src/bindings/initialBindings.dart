// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:scpanel_ui/src/controller/api_controller.dart';
import 'package:scpanel_ui/src/controller/storage_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    
    Get.put(StorageController());
    Get.put(ApiController());
  }
}
