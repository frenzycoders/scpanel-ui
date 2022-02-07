import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scpanel_ui/src/controller/home_page_controller.dart';
import 'package:scpanel_ui/src/http_exception.dart';

class DeleteEntity extends StatefulWidget {
  DeleteEntity({
    Key? key,
    required this.path,
    required this.homePageController,
    required this.cb,
  }) : super(key: key);
  String path;
  HomePageController homePageController;
  Function cb;
  @override
  _DeleteEntityState createState() => _DeleteEntityState();
}

class _DeleteEntityState extends State<DeleteEntity> {
  bool isLoading = false;
  bool showError = false;
  String error = '';
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Warning !'),
      content: SizedBox(
        height: 100,
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: const Text('Are you sure about it ?'),
            ),
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                '${widget.path} will be deleted after this operation',
              ),
            ),
            showError ? Text(error) : Container(),
          ],
        ),
      ),
      actions: [
        isLoading
            ? const CircularProgressIndicator()
            : RaisedButton.icon(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  try {
                    await widget.homePageController
                        .deleteEntity(path: widget.path);
                    await widget.homePageController.readFs(
                      path: widget.homePageController.mainDirectoryPath.value,
                      isHidden: widget.homePageController.isHidden.value,
                    );
                    setState(() {
                      isLoading = false;
                    });
                    Fluttertoast.showToast(
                        msg: 'deleted', gravity: ToastGravity.CENTER);
                    widget.cb();
                    Navigator.of(context).pop();
                  } on HttpException catch (e) {
                    setState(() {
                      isLoading = false;
                      showError = true;
                      error = e.message;
                    });
                  } catch (e) {
                    setState(() {
                      isLoading = false;
                      showError = true;
                      error = e.toString();
                    });
                  }
                },
                icon: showError
                    ? const Icon(Icons.refresh)
                    : const Icon(Icons.check),
                label: Text(showError ? 'Retry' : 'Yes, Sure'),
              ),
        isLoading
            ? Container()
            : RaisedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.cancel),
                label: const Text('No'),
              ),
      ],
    );
  }
}
