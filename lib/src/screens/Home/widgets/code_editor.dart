import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:scpanel_ui/src/controller/home_page_controller.dart';
import 'package:scpanel_ui/src/http_exception.dart';
import 'package:scpanel_ui/src/models/file_open.dart';

class CodeEditor extends StatelessWidget {
  CodeEditor({
    Key? key,
  }) : super(key: key);
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GetX<HomePageController>(builder: (home) {
      return Expanded(
        child: home.activeOpenFile.value.path == 'N/A'
            ? const Text('Desktop')
            : FutureBuilder(
                future: (() async {
                  try {
                    final data = await home.readFileData();
                    textEditingController.text = data;
                  } on HttpException catch (e) {
                    textEditingController.text = e.message;
                  } catch (e) {
                    textEditingController.text = e.toString();
                  }
                })(),
                builder: (context, snapShot) {
                  return snapShot.connectionState == ConnectionState.waiting
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : TextField(
                          controller: textEditingController,
                          expands: true,
                          maxLines: null,
                          onChanged: (value) {
                            FileOpen fileOpen = home.activeOpenFile.value;
                            home.isSaved(status: false);
                            Timer(
                              const Duration(seconds: 1),
                              () async {
                                List path = fileOpen.path.split('/');
                                path[path.length - 1] = '';
                                String p = path.join('/');
                                try {
                                  if (value != textEditingController.text) {
                                    home.createFileFunction(
                                      path: p,
                                      fileName: fileOpen.name,
                                      data: value,
                                    );
                                    home.isSaved(status: true);
                                  }
                                } on HttpException catch (e) {
                                  Fluttertoast.showToast(
                                      msg: e.message,
                                      gravity: ToastGravity.CENTER);
                                } catch (e) {
                                  Fluttertoast.showToast(msg: e.toString());
                                }
                              },
                            );
                          },
                        );
                },
              ),
      );
    });
  }
}
