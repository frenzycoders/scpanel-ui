import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scpanel_ui/constants.dart';
import 'package:scpanel_ui/src/controller/home_page_controller.dart';
import 'package:scpanel_ui/src/http_exception.dart';
import 'package:scpanel_ui/src/models/directory.dart';
import 'package:scpanel_ui/src/models/file_open.dart';
import 'package:scpanel_ui/src/screens/Home/widgets/create_folder.dart';
import 'package:scpanel_ui/src/screens/Home/widgets/delete_entity.dart';
import 'package:scpanel_ui/src/screens/Home/widgets/file_icons.dart';

class FileEntity extends StatefulWidget {
  FileEntity({
    Key? key,
    required this.name,
    required this.path,
    required this.isFolder,
    required this.homePageController,
    required this.isMiniFs,
    required this.prevFun,
  }) : super(key: key);
  String name;
  String path;
  bool isFolder;
  bool isMiniFs;
  HomePageController homePageController;
  Function prevFun;
  @override
  State<FileEntity> createState() => _FileEntityState();
}

class _FileEntityState extends State<FileEntity> {
  bool isOpen = false;
  String tempName = '';
  bool renameMode = false;
  bool isLoading = false;
  bool renameLoading = false;
  bool isError = false;
  String error = '';
  List<Directory> dirs = [];

  changeIsOpen() {
    if (!renameMode) {
      setState(() {
        isOpen = !isOpen;
      });
      if (isOpen) readDirs();
    }
  }

  readDirs() async {
    changeLoading(true);
    try {
      dirs = await widget.homePageController.readFSAndReturn(
        path: widget.path,
        isHidden: widget.homePageController.isHidden.value,
      ) as List<Directory>;
      changeLoading(false);
    } on HttpException catch (e) {
      showErr(e.message);
    } catch (e) {
      showErr(e.toString());
    }
  }

  changeLoading(value) {
    setState(() {
      isLoading = value;
    });
  }

  showErr(msg) {
    setState(() {
      error = msg;
      isError = true;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          return Container(
            color: widget.isMiniFs
                ? widget.path ==
                        widget.homePageController
                            .selectedTreeViewFolderForMiniFs.value.path
                    ? bgColor
                    : secondaryColor
                : widget.path ==
                        widget
                            .homePageController.selectTreeViewFolder.value.path
                    ? bgColor
                    : secondaryColor,
            child: Listener(
              onPointerDown: (PointerDownEvent event) {
                _onPointerDown(
                  event,
                  Directory(
                    name: widget.name,
                    isFolder: widget.isFolder,
                    path: widget.path,
                  ),
                );
              },
              child: InkWell(
                highlightColor: Colors.red,
                onTap: () {
                  if (widget.isFolder) {
                    if (widget.isMiniFs) {
                      widget.homePageController.setMiniFsTreeFolder(
                        Directory(
                          name: widget.name,
                          isFolder: widget.isFolder,
                          path: widget.path,
                        ),
                      );
                    } else {
                      widget.homePageController.setSelectTreeViewFolder(
                        directory: Directory(
                          name: widget.name,
                          isFolder: widget.isFolder,
                          path: widget.path,
                        ),
                      );
                    }
                    widget.homePageController.createFile.value = false;
                    widget.homePageController.createFolder.value = false;
                    changeIsOpen();
                  } else {
                    widget.homePageController.createFile.value = false;
                    widget.homePageController.createFolder.value = false;
                    widget.homePageController.setSelectTreeViewFolder(
                      directory: Directory(
                        name: widget.name,
                        isFolder: widget.isFolder,
                        path: widget.path,
                      ),
                    );
                    widget.homePageController.pushFileToOpenList(
                      fileOpen: FileOpen(
                        path: widget.path,
                        name: widget.name,
                        isSaved: true,
                      ),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 2, bottom: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 1),
                        child: Icon(
                          !isOpen
                              ? Icons.keyboard_arrow_right_rounded
                              : Icons.keyboard_arrow_down_outlined,
                          size: 20,
                          color: widget.isFolder
                              ? Colors.white
                              : Colors.transparent,
                        ),
                      ),
                      widget.isFolder
                          ? Container(
                              padding: const EdgeInsets.only(right: 2),
                              alignment: Alignment.center,
                              height: 25,
                              width: 25,
                              child: !isOpen
                                  ? SvgPicture.asset(
                                      "assets/icons/folder.svg",
                                    )
                                  : SvgPicture.asset(
                                      "assets/icons/folder-open.svg",
                                    ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(right: 2),
                              child: FileIcon(
                                fileExt: widget.name.split(
                                    '.')[widget.name.split('.').length - 1],
                                size: 20,
                              ),
                            ),
                      Flexible(
                        child: renameMode
                            ? SizedBox(
                                height: 26,
                                child: TextField(
                                  autofocus: true,
                                  onChanged: (val) {
                                    setState(() {
                                      widget.name = val;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: tempName,
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.blueGrey.withOpacity(0.70),
                                    ),
                                  ),
                                  style: GoogleFonts.firaSans(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 15,
                                  ),
                                  onSubmitted: (val) {
                                    widget.homePageController.renameEntity(
                                      loadingcb: (value) {
                                        setState(() {
                                          renameLoading = value;
                                        });
                                      },
                                      path: widget.path,
                                      newName: val,
                                      cb: (bool status, String msg,
                                          String newName) {
                                        if (status) {
                                          tempName = newName;
                                          widget.name = tempName;
                                          setState(() {
                                            renameMode = false;
                                          });
                                          widget.prevFun();
                                        }
                                        Fluttertoast.showToast(
                                          msg: msg,
                                          gravity: ToastGravity.CENTER,
                                        );
                                      },
                                    );
                                  },
                                ),
                              )
                            : Text(
                                widget.name,
                                style: GoogleFonts.firaSans(
                                  fontWeight: FontWeight.w300,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                      ),
                      renameMode
                          ? Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: renameLoading
                                  ? const Text('saving')
                                  : InkWell(
                                      onTap: () {
                                        setState(() {
                                          widget.name = tempName;
                                          renameMode = false;
                                        });
                                      },
                                      child: const Icon(
                                        Icons.clear,
                                        size: 15,
                                      ),
                                    ),
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
        Obx(() {
          return widget.homePageController.createFolder.isTrue
              ? widget.path ==
                          widget.homePageController.selectTreeViewFolder.value
                              .path &&
                      widget.homePageController.selectTreeViewFolder.value
                          .isFolder
                  ? CreateFolder(
                      path: widget.path,
                      folder: true,
                      homePageController: widget.homePageController,
                      cb: readDirs,
                    )
                  : Container()
              : Container();
        }),
        isOpen
            ? Container(
                margin: const EdgeInsets.only(left: 5),
                child: isLoading
                    ? const Text('loading...')
                    : isError
                        ? Text(error)
                        : dirs.isNotEmpty
                            ? ListView.builder(
                                physics: const ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return FileEntity(
                                    prevFun: () {
                                      readDirs();
                                    },
                                    isMiniFs: widget.isMiniFs ? true : false,
                                    name: dirs[index].name,
                                    path: dirs[index].path,
                                    isFolder: dirs[index].isFolder,
                                    homePageController:
                                        widget.homePageController,
                                  );
                                },
                                itemCount: dirs.length,
                              )
                            : const Text('Empty'),
              )
            : Container(),
        Obx(() {
          return widget.homePageController.createFile.isTrue
              ? widget.path ==
                          widget.homePageController.selectTreeViewFolder.value
                              .path &&
                      widget.homePageController.selectTreeViewFolder.value
                          .isFolder
                  ? CreateFolder(
                      folder: false,
                      homePageController: widget.homePageController,
                      cb: readDirs,
                      path: widget.path,
                    )
                  : Container()
              : Container();
        }),
      ],
    );
  }

  Future<void> _onPointerDown(
    PointerDownEvent event,
    Directory directory,
  ) async {
    // Check if right mouse button clicked
    if (event.kind == PointerDeviceKind.mouse &&
        event.buttons == kSecondaryMouseButton) {
      setState(() {
        isOpen = false;
      });
      widget.homePageController.createFile.value = false;
      widget.homePageController.createFolder.value = false;
      widget.homePageController.setSelectTreeViewFolder(
        directory: Directory(
            name: widget.name, isFolder: widget.isFolder, path: widget.path),
      );
      final overlay =
          Overlay.of(context)!.context.findRenderObject() as RenderBox;
      final menuItem = await showMenu<int>(
          color: bgColor,
          elevation: 2,
          context: context,
          items: directory.isFolder
              ? widget.homePageController.operationType == null
                  ? [
                      const PopupMenuItem(child: Text('Open'), value: 0),
                      const PopupMenuItem(
                          child: Text('Open in editor'), value: 1),
                      const PopupMenuItem(child: Text('Copy'), value: 2),
                      const PopupMenuItem(child: Text('Cut'), value: 3),
                      const PopupMenuItem(child: Text('Upload'), value: 5),
                      const PopupMenuItem(child: Text('Delete'), value: 6),
                      const PopupMenuItem(child: Text('Download'), value: 7),
                      const PopupMenuItem(child: Text('Rename'), value: 9),
                      const PopupMenuItem(child: Text('Share'), value: 8)
                    ]
                  : [
                      const PopupMenuItem(child: Text('Open'), value: 0),
                      const PopupMenuItem(
                          child: Text('Open in editor'), value: 1),
                      const PopupMenuItem(child: Text('Copy'), value: 2),
                      const PopupMenuItem(child: Text('Cut'), value: 3),
                      const PopupMenuItem(child: Text('Paste'), value: 4),
                      const PopupMenuItem(child: Text('Upload'), value: 5),
                      const PopupMenuItem(child: Text('Delete'), value: 6),
                      const PopupMenuItem(child: Text('Download'), value: 7),
                      const PopupMenuItem(child: Text('Rename'), value: 9),
                      const PopupMenuItem(child: Text('Share'), value: 8)
                    ]
              : [
                  const PopupMenuItem(child: Text('Open'), value: 0),
                  const PopupMenuItem(child: Text('Copy'), value: 2),
                  const PopupMenuItem(child: Text('Cut'), value: 3),
                  const PopupMenuItem(child: Text('Delete'), value: 6),
                  const PopupMenuItem(child: Text('Download'), value: 7),
                  const PopupMenuItem(child: Text('Rename'), value: 9),
                  const PopupMenuItem(child: Text('Share'), value: 8)
                ],
          position: RelativeRect.fromSize(
              event.position & const Size(100.0, 40.0), overlay.size));
      // Check if menu item clicked
      switch (menuItem) {
        case 0:
          //TODO: implement functnallaty for file open
          changeIsOpen();
          break;
        case 1:
          widget.homePageController.readFs(
              path: directory.path,
              isHidden: widget.homePageController.isHidden.value);
          break;
        case 2:
          widget.homePageController
              .setOperationType(source: directory.path, isCopy: true);
          break;

        case 3:
          widget.homePageController
              .setOperationType(source: directory.path, isCopy: false);
          break;
        case 4:
          widget.homePageController.copyMoveOperations(
              desti: directory.path,
              cb: (bool value, String msg) {
                if (value) {
                  widget.prevFun();
                  if (isOpen == true) {
                    setState(() {
                      isOpen = false;
                      isOpen = true;
                    });
                    if (isOpen) readDirs();
                  } else {
                    setState(() {
                      setState(() {
                        isOpen = false;
                        isOpen = true;
                      });
                    });
                  }
                }
                Fluttertoast.showToast(
                  msg: msg,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 4,
                  toastLength: Toast.LENGTH_LONG,
                );
              });
          break;
        case 6:
          showDialog(
            context: context,
            builder: (_) {
              return DeleteEntity(
                cb: () {
                  widget.prevFun();
                },
                path: directory.path,
                homePageController: widget.homePageController,
              );
            },
          );
          break;
        case 9:
          setState(() {
            tempName = widget.name;
            isOpen = false;
            renameMode = true;
          });
          break;
        default:
      }
    }
  }
}
