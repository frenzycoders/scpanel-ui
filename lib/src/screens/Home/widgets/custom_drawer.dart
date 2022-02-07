// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scpanel_ui/constants.dart';
import 'package:scpanel_ui/src/controller/home_page_controller.dart';
import 'package:scpanel_ui/src/http_exception.dart';
import 'package:scpanel_ui/src/models/directory.dart';
import 'package:scpanel_ui/src/screens/Home/widgets/create_folder.dart';
import 'package:scpanel_ui/src/screens/Home/widgets/file_entity.dart';
import 'package:scpanel_ui/src/screens/Home/widgets/mini_fs.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool showError = false;
  String errorMsg = '';
  String path = '';

  showErrorFun({required String message}) {
    setState(() {
      showError = true;
      errorMsg = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetX<HomePageController>(
      builder: (home) {
        return FutureBuilder(future: (() async {
          path = home.mainDirectoryPath.value;
          try {
            await home.readFs(
              path: home.mainDirectoryPath.value,
              isHidden: home.isHidden.value,
            );
          } on HttpException catch (e) {
            showErrorFun(message: e.message);
          } catch (e) {
            showErrorFun(message: e.toString());
          }
        })(), builder: (context, snapshot) {
          return Drawer(
            child: Column(
              children: [
                DrawerHeader(
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: const Text('Quick routes'),
                            content: Container(
                              alignment: Alignment.center,
                              height: 100,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RaisedButton.icon(
                                      onPressed: () {
                                        home.readFs(
                                          path: '/',
                                          isHidden: home.isHidden.value,
                                        );
                                        Navigator.of(context).pop();
                                      },
                                      icon: const Icon(
                                          Icons.admin_panel_settings),
                                      label: const Text('open root'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RaisedButton.icon(
                                      onPressed: () {
                                        home.readFs(
                                          path: home.storageController.serverBox
                                              .get('server-key')!
                                              .homeDir,
                                          isHidden: home.isHidden.value,
                                        );
                                        Navigator.of(context).pop();
                                      },
                                      icon: const Icon(Icons.home),
                                      label: const Text('open home'),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/logo/server.png",
                            height: 60,
                            width: 60,
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            'scpanel',
                            style: GoogleFonts.firaSans(
                              fontSize: 20,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                home.directoryLoading.isTrue
                    ? Container(
                        alignment: Alignment.center,
                        child: const Text('Loading...'),
                      )
                    : showError
                        ? Container(
                            alignment: Alignment.center,
                            child: Text(errorMsg),
                          )
                        : ListTile(
                            hoverColor: bgColor,
                            tileColor: bgColor,
                            onTap: () {
                              home.setSelectTreeViewFolder(
                                directory: Directory(
                                  name: path
                                      .split('/')[path.split('/').length - 1],
                                  isFolder: true,
                                  path: path,
                                ),
                              );
                            },
                            horizontalTitleGap: 0.0,
                            leading: const Icon(
                              Icons.storage_rounded,
                              color: Colors.white54,
                              size: 16,
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: TextButton(
                                    onPressed: () {
                                      showDialog(
                                        barrierDismissible: false,
                                        useSafeArea: true,
                                        context: context,
                                        builder: (context) {
                                          return MiniFs(
                                            title: 'select folder',
                                            BtnText: 'OPEN',
                                            home: home,
                                            onSubmit: (Directory value,
                                                BuildContext context) async {
                                              try {
                                                List dir =
                                                    await home.readFSAndReturn(
                                                  path: value.path,
                                                  isHidden: home.isHidden.value,
                                                );
                                                home.setDirectoriesAndMainDirectoryPath(
                                                  dir: dir as List<Directory>,
                                                  mainPath: value.path,
                                                );
                                                Navigator.of(context).pop();
                                              } on HttpException catch (e) {
                                                Fluttertoast.showToast(
                                                  msg: e.message,
                                                  gravity: ToastGravity.CENTER,
                                                );
                                              } catch (e) {
                                                Fluttertoast.showToast(
                                                  msg: e.toString(),
                                                  gravity: ToastGravity.CENTER,
                                                );
                                              }
                                            },
                                          );
                                        },
                                      );
                                    },
                                    child: Text(
                                      path == '/'
                                          ? path
                                          : path.split(
                                              '/')[path.split('/').length - 1],
                                      style: const TextStyle(
                                          color: Colors.white54),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        home.changeCreateFolder();
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 25,
                                        width: 25,
                                        child: SvgPicture.asset(
                                          "assets/icons/folder.svg",
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: InkWell(
                                        onTap: () {
                                          home.changeCreateFile();
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 25,
                                          width: 25,
                                          child: Image.asset(
                                            "assets/icons/file.png",
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        home.createFile.value = false;
                                        home.createFile.value = false;
                                        home.readFs(
                                            path: path,
                                            isHidden: home.isHidden.value);
                                      },
                                      icon: const Icon(Icons.refresh),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                Obx(() {
                  return !showError
                      ? Expanded(
                          child: home.directories.isNotEmpty
                              ? Scrollbar(
                                  child: ListView(
                                    physics: const ClampingScrollPhysics(),
                                    children: [
                                      home.createFolder.isTrue
                                          ? path ==
                                                  home.selectTreeViewFolder
                                                      .value.path
                                              ? CreateFolder(
                                                  path: home
                                                      .selectTreeViewFolder
                                                      .value
                                                      .path,
                                                  folder: true,
                                                  homePageController: home,
                                                  cb: () async {
                                                    await home.readFs(
                                                      path: home
                                                          .mainDirectoryPath
                                                          .value,
                                                      isHidden:
                                                          home.isHidden.value,
                                                    );
                                                  },
                                                )
                                              : Container()
                                          : Container(),
                                      ...home.directories.map((element) {
                                        return FileEntity(
                                          prevFun: () {
                                            home.readFs(
                                              path:
                                                  home.mainDirectoryPath.value,
                                              isHidden: home.isHidden.value,
                                            );
                                          },
                                          isMiniFs: false,
                                          name: element.name,
                                          path: element.path,
                                          isFolder: element.isFolder,
                                          homePageController: home,
                                        );
                                      }).toList(),
                                      home.createFile.isTrue
                                          ? path ==
                                                  home.selectTreeViewFolder
                                                      .value.path
                                              ? CreateFolder(
                                                  path: home
                                                      .mainDirectoryPath.value,
                                                  folder: false,
                                                  homePageController: home,
                                                  cb: () async {
                                                    await home.readFs(
                                                      path: home
                                                          .mainDirectoryPath
                                                          .value,
                                                      isHidden:
                                                          home.isHidden.value,
                                                    );
                                                  },
                                                )
                                              : Container()
                                          : Container(),
                                    ],
                                  ),
                                )
                              : const Text('Empty'),
                        )
                      : Container();
                }),
              ],
            ),
          );
        });
      },
    );
  }
}
