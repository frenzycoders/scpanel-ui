import 'dart:html';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scpanel_ui/constants.dart';
import 'package:scpanel_ui/src/bindings/home_bindings.dart';
import 'package:scpanel_ui/src/bindings/initialBindings.dart';
import 'package:scpanel_ui/src/bindings/loginbinding.dart';
import 'package:scpanel_ui/src/models/hive/server.dart';
import 'package:scpanel_ui/src/models/hive/user.dart';
import 'package:scpanel_ui/src/models/hive/utils.dart';
import 'package:scpanel_ui/src/screens/Home/error.dart';
import 'package:scpanel_ui/src/screens/Home/home_screen.dart';
import 'package:scpanel_ui/src/screens/isAutenticated.dart';
import 'package:scpanel_ui/src/screens/login/login_screen.dart';
import 'package:scpanel_ui/src/screens/splash_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ServerAdapter());
  await Hive.openBox<Server>('server');
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<User>('user');
  Hive.registerAdapter(UtilsAdapter());
  await Hive.openBox<Utils>('utils');
  document.onContextMenu.listen((event) => event.preventDefault());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBindings(),
      title: 'welcome | scpanel',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme:
            GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).apply(
          bodyColor: Colors.white,
        ),
        canvasColor: secondaryColor,
      ),
      getPages: [
        GetPage(
          name: '/splash',
          page: () =>
              IsAutenticated(widget: const SplashScreen(), route: '/splash'),
        ),
        GetPage(
          name: '/login',
          page: () => IsAutenticated(
            widget: const LoginScreen(),
            route: '/login',
          ),
          binding: LoginBindigs(),
        ),
        GetPage(
          name: '/dashboard',
          page: () => IsAutenticated(widget: HomeScreen(), route: '/dashboard'),
          binding: HomePageBindings(),
        ),
        GetPage(
          name: '/error',
          page: () => ErrorScreen(),
        )
      ],
      initialRoute: '/splash',
    );
  }
}
