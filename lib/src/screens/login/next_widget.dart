import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:scpanel_ui/constants.dart';
import 'package:scpanel_ui/src/controller/login_controller.dart';
import 'package:scpanel_ui/src/http_exception.dart';
import 'package:scpanel_ui/src/models/host.dart';

class NextWidget extends StatelessWidget {
  NextWidget({
    Key? key,
    required this.host,
  }) : super(key: key);
  Host host;
  @override
  Widget build(BuildContext context) {
    return GetX<LoginController>(builder: (login) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Verify',
              style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    height: 0.0,
                    fontSize: 25,
                  ),
            ),
          ),
          login.isError.isTrue
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(login.error),
                )
              : Container(),
          Padding(
            padding: EdgeInsets.all(30),
            child: TextField(
              enabled: false,
              controller: TextEditingController(text: host.user.hostUser),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: primaryColor, width: 1.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: TextField(
              enabled: false,
              controller: TextEditingController(text: host.user.email),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: primaryColor, width: 1.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: TextField(
              obscureText: !login.showPwd.value,
              controller: login.passwordController,
              enabled: !login.isLoading.value,
              decoration: InputDecoration(
                hintText: 'Your password',
                prefixIcon: const Icon(
                  Icons.password,
                ),
                suffixIcon: !login.isLoading.isTrue
                    ? IconButton(
                        onPressed: () {
                          login.changeSHowPwd();
                        },
                        icon: const FaIcon(FontAwesomeIcons.eye),
                      )
                    : IconButton(
                        onPressed: () {
                          login.changeSHowPwd();
                        },
                        icon: const FaIcon(FontAwesomeIcons.eyeSlash),
                      ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: bgColor, width: 2.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: primaryColor, width: 1.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: login.isLoading.isTrue
                ? Container(
                    alignment: Alignment.center,
                    height: 50,
                    child: const CircularProgressIndicator(),
                  )
                : InkWell(
                    onTap: () async {
                      try {
                        await login.login();
                        if (login.loggedIn) {
                          Get.offAndToNamed('/dashboard');
                        }
                      } on HttpException catch (e) {
                        log(e.message);
                      } catch (e) {
                        log(e.toString());
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      color: primaryColor,
                      child: const Text('LOGIN'),
                    ),
                  ),
          )
        ],
      );
    });
  }
}
