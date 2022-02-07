import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:scpanel_ui/src/HttpLogoutException.dart';
import 'package:scpanel_ui/src/controller/api_controller.dart';
import 'package:scpanel_ui/src/http_exception.dart';

// ignore: must_be_immutable
class IsAutenticated extends StatelessWidget {
  IsAutenticated({
    Key? key,
    required this.widget,
    required this.route,
  }) : super(key: key);
  Widget widget;
  String route;
  @override
  Widget build(BuildContext context) {
    ApiController apiController = Get.find<ApiController>();
    return FutureBuilder(
      future: (() async {
        try {
          if (await apiController.checkAuthenticated()) {
            if (route == '/login') {
              Get.offAndToNamed('/dashboard');
            } else if (route == '/splash') {
              Get.offAndToNamed('/dashboard');
            }
          } else {
            if (route != '/login') {
              Get.offAndToNamed('/login');
            }
          }
        } on HttpLogoutException catch (e) {
          if (route != '/login') Get.offAndToNamed('/login');
        } on HttpException catch (e) {
          Fluttertoast.showToast(msg: e.message, gravity: ToastGravity.CENTER);
          Get.offAndToNamed('/error');
        } catch (e) {
          Fluttertoast.showToast(
              msg: e.toString(), gravity: ToastGravity.CENTER);
          Get.offAndToNamed('/error');
        }
      })(),
      builder: (BuildContext context, snapshot) {
        return snapshot.connectionState == ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : snapshot.hasError
                ? Container(
                    alignment: Alignment.center,
                    child: Text(snapshot.data.toString()),
                  )
                : widget;
      },
    );
  }
}
