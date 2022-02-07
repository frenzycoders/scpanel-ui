// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scpanel_ui/src/controller/api_controller.dart';
import 'package:scpanel_ui/src/controller/storage_controller.dart';
import 'package:scpanel_ui/src/http_exception.dart';
import 'package:scpanel_ui/src/models/basic_info.dart';
import 'package:scpanel_ui/src/models/directory.dart';
import 'package:scpanel_ui/src/models/fileEntity.dart';
import 'package:scpanel_ui/src/models/file_open.dart';

class HomePageController extends GetxController {
  late StorageController storageController;
  late ApiController _apiController;
  BasicInfo? basicInfo;
  RxBool createFolder = false.obs;
  RxBool createFile = false.obs;
  OperationType? operationType;

  RxBool isLoading = false.obs;
  RxString mainDirectoryPath = ''.obs;
  Rx<Directory> selectTreeViewFolder =
      Directory(name: '', isFolder: false, path: '').obs;
  Rx<Directory> selectedTreeViewFolderForMiniFs =
      Directory(name: '', isFolder: false, path: '').obs;

  RxBool isHidden = true.obs;
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  RxBool directoryLoading = false.obs;
  RxList directories = [].obs;

  RxList<FileOpen> openFiles =
      [FileOpen(path: 'N/A', name: 'DASHBOARD', isSaved: false)].obs;
  Rx<FileOpen> activeOpenFile =
      FileOpen(path: 'N/A', name: 'DASHBOARD', isSaved: false).obs;

  HomePageController() {
    isLoading.value = true;
    storageController = Get.find<StorageController>();
    _apiController = Get.find<ApiController>();
    if (storageController.serverBox.get('server-key') != null) {
      mainDirectoryPath.value =
          storageController.serverBox.get('server-key')!.homeDir;
    }
    isLoading.value = false;
  }

  fetchFilesFromOpenList({required String path}) async {
    FileOpen? fileopen;
    for (var element in openFiles.value) {
      if (element.path == path) {
        fileopen = element;
        break;
      }
    }
    return fileopen;
  }

  pushFileToOpenList({required FileOpen fileOpen}) async {
    final file = await fetchFilesFromOpenList(path: fileOpen.path);
    if (file == null) {
      List<FileOpen> f = openFiles.value;
      f.add(fileOpen);
      openFiles.value = [];
      openFiles.value = f;
      activeOpenFile.value = fileOpen;
    } else {
      activeOpenFile.value = file as FileOpen;
    }
  }

  popFileFromOpenList({required String path}) async {
    List<FileOpen> file = [];
    int index = 0;
    int fileIndex = 0;
    for (var element in openFiles.value) {
      if (element.path != path) {
        file.add(element);
      } else {
        fileIndex = index;
      }
      index += 1;
    }

    openFiles.value = file;

    if (fileIndex == 0) {
      activeOpenFile.value = openFiles.value[0];
    } else {
      activeOpenFile.value = openFiles.value[fileIndex - 1];
    }
  }

  setactiveOpenFile({required String path}) async {
    final file = await fetchFilesFromOpenList(path: path);
    activeOpenFile.value = file as FileOpen;
  }

  readFs({required String path, required bool isHidden}) async {
    directoryLoading.value = true;

    try {
      List<Directory> dirs =
          await _apiController.readFs(isHidden: isHidden, path: path);
      directories.value = dirs;
      mainDirectoryPath.value = path;
      directoryLoading.value = false;
      openFiles.value = [
        FileOpen(path: 'N/A', name: 'DASHBOARD', isSaved: false)
      ];
      activeOpenFile.value =
          FileOpen(path: 'N/A', name: 'DASHBOARD', isSaved: false);
    } on HttpException catch (e) {
      directoryLoading.value = false;
      throw HttpException(e.message);
    } catch (e) {
      directoryLoading.value = false;
      rethrow;
    }
  }

  Future<List<Directory>> readFSAndReturn({
    required String path,
    required bool isHidden,
  }) async {
    try {
      List<Directory> dirs =
          await _apiController.readFs(isHidden: isHidden, path: path);
      return dirs;
    } on HttpException catch (e) {
      directoryLoading.value = false;
      throw HttpException(e.message);
    } catch (e) {
      directoryLoading.value = false;
      rethrow;
    }
  }

  createFolderFunction(
      {required String path, required String folderName}) async {
    try {
      await _apiController.createFolder(path: path, folderName: folderName);
      createFile.value = false;
      createFolder.value = false;
    } on HttpException catch (e) {
      throw HttpException(e.message);
    } catch (e) {
      rethrow;
    }
  }

  createFileFunction({
    required String path,
    required String fileName,
    required String data,
  }) async {
    try {
      await _apiController.createFile(
          path: path, fileName: fileName, data: data);
      createFile.value = false;
      createFolder.value = false;
    } on HttpException catch (e) {
      throw HttpException(e.message);
    } catch (e) {
      rethrow;
    }
  }

  deleteEntity({required String path}) async {
    try {
      await _apiController.deleteEntity(path: path);
    } on HttpException catch (e) {
      throw HttpException(e.message);
    } catch (e) {
      rethrow;
    }
  }

  Future readFileData() async {
    try {
      return await _apiController.readFile(path: activeOpenFile.value.path);
    } on HttpException catch (e) {
      throw HttpException(e.message);
    } catch (e) {
      rethrow;
    }
  }

  setIsHidden({required bool value}) {
    isHidden.value = value;
  }

  setSelectTreeViewFolder({required Directory directory}) {
    selectTreeViewFolder.value = directory;
  }

  setDirectoriesAndMainDirectoryPath(
      {required List<Directory> dir, required String mainPath}) {
    mainDirectoryPath.value = mainPath;
    directories.value = dir;
  }

  setMiniFsTreeFolder(Directory directory) {
    selectedTreeViewFolderForMiniFs.value = directory;
  }

  changeCreateFolder() {
    createFile.value = false;
    createFolder.value = !createFolder.value;
  }

  changeCreateFile() {
    createFolder.value = false;
    createFile.value = !createFile.value;
  }

  setOperationType({
    required String source,
    required bool isCopy,
  }) {
    operationType =
        OperationType(forCopy: isCopy, desti: 'n/a', source: source);
  }

  copyMoveOperations({required String desti, required Function cb}) async {
    if (operationType == null) {
      cb(true, 'please copy entity first');
    } else {
      try {
        operationType!.desti = desti;
        if (operationType!.forCopy) {
          await _apiController.copyEntity(
              operationType: operationType as OperationType);
          cb(true, 'copied');
        } else {
          await _apiController.moveEntity(
              operationType: operationType as OperationType);
          cb(true, 'moved');
        }
      } on HttpException catch (e) {
        cb(false, e.message);
      } catch (e) {
        cb(false, e.toString());
      }
    }
  }

  renameEntity({
    required String path,
    required String newName,
    required Function cb,
    required Function loadingcb,
  }) async {
    loadingcb(true);
    try {
      await _apiController.renameEntity(path: path, newName: newName);
      loadingcb(false);
      cb(
        true,
        'renamed ' +
            path.split('/')[path.split('/').length - 1] +
            ' to ' +
            newName,
        newName,
      );
    } on HttpException catch (e) {
      loadingcb(false);
      cb(false, e.message, newName);
    } catch (e) {
      loadingcb(false);
      cb(false, e.toString(), newName);
    }
  }

  isSaved({required bool status}) {
    activeOpenFile.value.isSaved = status;
    activeOpenFile.value = activeOpenFile.value;
  }

  logout({required Function cb}) async {
    try {
      await _apiController.logout();
      cb(true, 'Logged out');
    } on HttpException catch (e) {
      // print(e.message);
      cb(false, e.message);
    } catch (e) {
      print(e.toString());
      cb(false, e.toString());
    }
  }
}
