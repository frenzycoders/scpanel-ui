import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scpanel_ui/src/controller/home_page_controller.dart';
import 'package:scpanel_ui/src/http_exception.dart';
import 'package:scpanel_ui/src/screens/Home/widgets/file_icons.dart';

class CreateFolder extends StatefulWidget {
  CreateFolder({
    Key? key,
    required this.folder,
    required this.homePageController,
    required this.cb,
    required this.path,
  }) : super(key: key);
  bool folder;
  HomePageController homePageController;
  Function cb;
  String path;
  @override
  State<CreateFolder> createState() => _CreateFolderState();
}

class _CreateFolderState extends State<CreateFolder> {
  bool isLoading = false;

  bool isError = false;
  String msg = '';

  String ext = '';

  createFolderFun({required String path, required String folderName}) async {
    try {
      setState(() {
        isLoading = true;
      });
      if (widget.folder) {
        await widget.homePageController
            .createFolderFunction(path: path, folderName: folderName);
      } else {
        await widget.homePageController
            .createFileFunction(path: path, fileName: folderName, data: '\n');
      }
      await widget.cb();
      setState(() {
        isLoading = false;
        isError = false;
      });
    } on HttpException catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
        msg = e.message;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
        msg = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 0, bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          widget.folder
              ? const Padding(
                  padding: EdgeInsets.only(right: 1),
                  child: Icon(
                    Icons.keyboard_arrow_right_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.only(right: 1),
                  child: Icon(
                    Icons.keyboard_arrow_right_rounded,
                    size: 20,
                    color: Colors.transparent,
                  ),
                ),
          Container(
            padding: const EdgeInsets.only(right: 2),
            alignment: Alignment.center,
            height: 25,
            width: 25,
            child: widget.folder
                ? SvgPicture.asset(
                    "assets/icons/folder.svg",
                  )
                : FileIcon(fileExt: ext, size: 20),
          ),
          Expanded(
            child: SizedBox(
              height: 30,
              child: isLoading
                  ? const Text('creating..')
                  : isError
                      ? Text(msg)
                      : TextFormField(
                          onChanged: (val) {
                            if (widget.folder == false) {
                              setState(() {
                                if (val.contains('.')) {
                                  ext =
                                      val.split('.')[val.split('.').length - 1];
                                } else {
                                  ext = '';
                                }
                              });
                            }
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:
                                widget.folder ? 'folder name' : 'file name',
                            hintStyle: TextStyle(
                              color: Colors.blueGrey.withOpacity(0.70),
                            ),
                          ),
                          autofocus: true,
                          onFieldSubmitted: (val){
                            createFolderFun(path: widget.path, folderName: val);
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
