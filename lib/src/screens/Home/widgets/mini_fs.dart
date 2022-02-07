import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scpanel_ui/constants.dart';
import 'package:scpanel_ui/src/controller/home_page_controller.dart';
import 'package:scpanel_ui/src/http_exception.dart';
import 'package:scpanel_ui/src/models/directory.dart';
import 'package:scpanel_ui/src/screens/Home/widgets/file_entity.dart';

class MiniFs extends StatefulWidget {
  MiniFs({
    Key? key,
    required this.home,
    required this.onSubmit,
    required this.BtnText,
    required this.title,
  }) : super(key: key);
  late HomePageController home;
  Function onSubmit;
  String BtnText;
  String title;
  @override
  State<MiniFs> createState() => _MiniFsState();
}

class _MiniFsState extends State<MiniFs> {
  List<Directory> dirs = [];
  bool isLoading = false;
  bool isError = false;
  String msg = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRootDirs();
  }

  getRootDirs() async {
    try {
      changeLoadingState(true);
      dirs = await widget.home.readFSAndReturn(path: '/', isHidden: true)
          as List<Directory>;
      changeLoadingState(false);
    } on HttpException catch (e) {
      changeLoadingState(false);
      showErr(e.message);
    } catch (e) {
      changeLoadingState(false);
      showErr(e.toString());
    }
  }

  changeLoadingState(value) {
    setState(() {
      isLoading = value;
    });
  }

  showErr(msg) {
    setState(() {
      isError = true;
      msg = msg;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: bgColor,
      title: Text(
        widget.title,
        style: GoogleFonts.firaSans(),
      ),
      content: Obx(() {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: secondaryColor,
              height: 350,
              width: 350,
              child: widget.home.directories.isNotEmpty
                  ? ListView.builder(
                      itemBuilder: (context, index) {
                        return FileEntity(
                          prevFun: () {
                            getRootDirs();
                          },
                          isMiniFs: true,
                          name: dirs[index].name,
                          path: dirs[index].path,
                          isFolder: dirs[index].isFolder,
                          homePageController: widget.home,
                        );
                      },
                      itemCount: dirs.length,
                    )
                  : const Center(
                      child: Text('Empty..'),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Container(
                width: double.infinity,
                height: 40,
                color: secondaryColor,
                child: TextField(
                  controller: TextEditingController(
                      text: widget
                          .home.selectedTreeViewFolderForMiniFs.value.path),
                  decoration: const InputDecoration(
                    helperText: 'select folder or enter your path',
                    border: InputBorder.none,
                  ),
                ),
              ),
            )
          ],
        );
      }),
      actions: [
        RaisedButton.icon(
          onPressed: () async {
            widget.onSubmit(
                widget.home.selectedTreeViewFolderForMiniFs.value, context);
          },
          icon: const Icon(
            Icons.folder_open,
          ),
          label: Text(widget.BtnText),
        ),
        RaisedButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.clear,
          ),
          label: const Text('CLOSE'),
        )
      ],
    );
  }
}
