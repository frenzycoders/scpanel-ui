// ignore_for_file: invalid_use_of_protected_member
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scpanel_ui/constants.dart';
import 'package:scpanel_ui/src/controller/home_page_controller.dart';
import 'package:scpanel_ui/src/controller/storage_controller.dart';
import 'package:scpanel_ui/src/models/basic_info.dart';
import 'package:scpanel_ui/src/models/hive/user.dart';
import 'package:scpanel_ui/src/screens/Home/widgets/code_editor.dart';
import 'package:scpanel_ui/src/screens/Home/widgets/custom_drawer.dart';
import 'package:scpanel_ui/src/screens/Home/widgets/hero_button.dart';
import 'package:scpanel_ui/src/screens/Home/widgets/openFileList.dart';
import 'package:scpanel_ui/src/screens/Home/widgets/profile_card.dart';
import 'package:scpanel_ui/src/screens/responsive.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    StorageController storageController = Get.find<StorageController>();
    BasicInfo basicInfo = storageController.basicInfo.value as BasicInfo;
    User user = storageController.user.value as User;
    HomePageController home = Get.find<HomePageController>();

    return Scaffold(
      key: home.scaffoldkey,
      body: home.isLoading.isTrue
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: !Responsive.isMobile(context)
                  ? [
                      const CustomDrawer(),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              elevation: 4,
                              child: SizedBox(
                                height: 100,
                                child: Container(
                                  color: secondaryColor,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const FaIcon(
                                                      FontAwesomeIcons.laptop),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    '${basicInfo.hostname}@${basicInfo.platform}',
                                                    style: GoogleFonts.firaSans(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    HeroButton(
                                                      icon: Icons.storage,
                                                      title: 'File Manager',
                                                      onTap: () {},
                                                    ),
                                                    HeroButton(
                                                      icon: Icons.link_sharp,
                                                      title: 'Links',
                                                      onTap: () {},
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                ProfileCard(
                                                  name: user.name,
                                                  onTap: () {
                                                    print('myProfile');
                                                  },
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    home.logout(cb:
                                                        (bool status,
                                                            String msg) {
                                                      Fluttertoast.showToast(
                                                          msg: msg);
                                                      if (status) {
                                                        Get.offAndToNamed(
                                                            '/login');
                                                      }
                                                    });
                                                  },
                                                  icon: const Icon(
                                                      Icons.logout_outlined),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      const Divider(
                                        height: 0,
                                      ),
                                      Obx(() {
                                        return home.openFiles.value.isNotEmpty
                                            ? SizedBox(
                                                height: 50,
                                                child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return OpenFileList(
                                                      fileOpen: home.openFiles
                                                          .value[index],
                                                    );
                                                  },
                                                  itemCount: home
                                                      .openFiles.value.length,
                                                ),
                                              )
                                            : Container();
                                      })
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            CodeEditor(),
                          ],
                        ),
                      )
                    ]
                  : [],
            ),
      drawer: const CustomDrawer(),
    );
  }
}
