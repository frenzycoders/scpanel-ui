import 'package:flutter/material.dart';
import 'package:scpanel_ui/constants.dart';
import 'package:scpanel_ui/src/screens/login/login_widget.dart';
import 'package:scpanel_ui/src/screens/responsive.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!Responsive.isMobile(context))
            Align(
              alignment: Alignment.center,
              child: Card(
                color: bgColor,
                elevation: 6,
                child: Container(
                  color: secondaryColor,
                  // height: 450,
                  width: 700,
                  child: Row(
                    children: [
                      Expanded(
                        child: Image.asset(
                          'images/server-image-1.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: LoginWidget(),
                      )
                    ],
                  ),
                ),
              ),
            ),
          if (Responsive.isMobile(context)) LoginWidget(),
        ],
      ),
    );
  }
}
