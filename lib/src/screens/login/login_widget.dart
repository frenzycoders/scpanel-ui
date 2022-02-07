import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scpanel_ui/constants.dart';
import 'package:scpanel_ui/src/controller/login_controller.dart';
import 'package:scpanel_ui/src/models/host.dart';
import 'package:scpanel_ui/src/screens/login/next_widget.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<LoginController>(builder: (login) {
      return login.nextScreen.isTrue
          ? NextWidget(
              host: login.host as Host,
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'LOG',
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              height: 0.0,
                              fontSize: 25,
                            ),
                      ),
                      Text(
                        ' IN',
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                              height: 0.0,
                              fontSize: 25,
                            ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: !login.ishttps.value,
                            onChanged: (value) {
                              login.changeValue(value);
                            },
                          ),
                          const Text('http')
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: login.ishttps.value,
                            onChanged: (value) {
                              login.changeValue(value);
                            },
                          ),
                          const Text('https')
                        ],
                      ),
                    ],
                  ),
                ),
                login.isError.isTrue
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(login.error),
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: TextField(
                    enabled: !login.isLoading.value,
                    controller: login.ipController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.web),
                      hintText: 'Your Server IP',
                      hintStyle: TextStyle(
                        color: Colors.blueGrey.withOpacity(0.70),
                      ),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(
                    enabled: !login.isLoading.value,
                    controller: login.portController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.vpn_key,
                      ),
                      hintText: 'Your Server Port',
                      hintStyle: TextStyle(
                        color: Colors.blueGrey.withOpacity(0.70),
                      ),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    keyboardType: TextInputType.number,
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
                          onTap: () {
                            login.checkServerStatus();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 50,
                            color: primaryColor,
                            child: const Text('NEXT'),
                          ),
                        ),
                )
              ],
            );
    });
  }
}
