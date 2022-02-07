import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:scpanel_ui/src/controller/api_controller.dart';
import 'package:scpanel_ui/src/http_exception.dart';
import 'package:scpanel_ui/src/models/host.dart';

class LoginController extends GetxController {
  RxBool showPwd = false.obs;
  RxBool ishttps = false.obs;
  RxBool nextScreen = false.obs;
  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  String error = '';
  Host? host;

  bool loggedIn = false;

  late ApiController _apiController;

  LoginController() {
    _apiController = Get.find<ApiController>();
  }

  TextEditingController ipController = TextEditingController();
  TextEditingController portController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  checkServerStatus() async {
    isLoading.value = true;
    try {
      host = await _apiController.testHost(
        ip: ipController.text,
        port: portController.text,
        httpType: ishttps.isTrue ? 'https' : 'http',
      );
      isLoading.value = false;
      nextScreen.value = true;
    } on HttpException catch (e) {
      showError(errMessage: e.message);
      isLoading.value = false;
    } catch (e) {
      showError(errMessage: e.toString());
      isLoading.value = false;
    }
  }

  changeSHowPwd() {
    showPwd.value = !showPwd.value;
  }

  login() async {
    if (passwordController.text.isEmpty) {
      showError(errMessage: 'Please enter password');
    } else {
      isLoading.value = true;
      try {
        await _apiController.loginServer(
            host: host as Host,
            password: passwordController.text,
            cb: () {
              loggedIn = true;
            });
        isLoading.value = false;
      } on HttpException catch (e) {
        showError(errMessage: e.message);
        isLoading.value = false;
      } catch (e) {
        showError(errMessage: e.toString());
        isLoading.value = false;
      }
    }
  }

  changeValue(value) {
    if (value == true && ishttps.value == true) {
      ishttps.value = false;
    } else if (value == false && ishttps.value == false) {
      ishttps.value = true;
    } else {
      ishttps.value = value;
    }
  }

  showError({required String errMessage}) {
    error = errMessage;
    isError.value = true;
    Timer(const Duration(seconds: 3), () {
      error = '';
      isError.value = false;
    });
  }

  disposeControllers() {
    passwordController.dispose();
    ipController.dispose();
    portController.dispose();
  }
}
