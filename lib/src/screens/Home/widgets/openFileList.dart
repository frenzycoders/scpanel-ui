import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:scpanel_ui/constants.dart';
import 'package:scpanel_ui/src/controller/home_page_controller.dart';
import 'package:scpanel_ui/src/models/file_open.dart';
import 'package:scpanel_ui/src/screens/Home/widgets/file_icons.dart';

class OpenFileList extends StatelessWidget {
  OpenFileList({
    Key? key,
    required this.fileOpen,
  }) : super(key: key);
  FileOpen fileOpen;

  @override
  Widget build(BuildContext context) {
    return GetX<HomePageController>(builder: (home) {
      return InkWell(
        onTap: () {
          home.activeOpenFile.value = fileOpen;
        },
        child: Container(
          width: 200,
          color: fileOpen.path == home.activeOpenFile.value.path
              ? bgColor
              : secondaryColor,
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              fileOpen.path == 'N/A'
                  ? SizedBox(
                      height: 15,
                      width: 15,
                      child: Image.asset("assets/logo/server.png"),
                    )
                  : FileIcon(
                      fileExt: fileOpen.name
                          .split('.')[fileOpen.name.split('.').length - 1],
                      size: 15,
                    ),
              Flexible(
                child: Text(
                  fileOpen.name,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              fileOpen.path != 'N/A'
                  ? Obx(() {
                      return fileOpen.path == home.activeOpenFile.value.path &&
                              home.activeOpenFile.value.isSaved == false
                          ? const Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                '*',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            )
                          : Container();
                    })
                  : Container(),
              Padding(
                padding: const EdgeInsets.all(5),
                child: IconButton(
                  onPressed: () async {
                    if (fileOpen.path == 'N/A') {
                      Fluttertoast.showToast(
                          msg: 'Default screen you can\'t remove it');
                    } else {
                      await home.popFileFromOpenList(path: fileOpen.path);
                    }
                  },
                  icon: const Icon(
                    Icons.clear,
                    size: 15,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
