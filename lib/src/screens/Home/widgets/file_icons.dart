import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FileIcon extends StatelessWidget {
  FileIcon({
    Key? key,
    required this.fileExt,
    required this.size,
  }) : super(key: key);
  String fileExt;
  double size;
  @override
  Widget build(BuildContext context) {
    return fileExt == "js"
        ? SizedBox(
            height: size,
            width: size,
            child: Image.asset("assets/files/js.png"),
          )
        : fileExt == "pdf"
            ? SizedBox(
                height: size,
                width: size,
                child: Image.asset("assets/icons/pdf.png"),
              )
            : fileExt == "py"
                ? SizedBox(
                    height: size,
                    width: size,
                    child: Image.asset("assets/files/python.png"),
                  )
                : fileExt == "dart"
                    ? SizedBox(
                        height: size,
                        width: size,
                        child: SvgPicture.asset(
                          "assets/files/dart.svg",
                        ),
                      )
                    : fileExt == "java" || fileExt == "class"
                        ? SizedBox(
                            height: size,
                            width: size,
                            child: SvgPicture.asset(
                              "assets/files/java.svg",
                            ),
                          )
                        : fileExt == "ts"
                            ? SizedBox(
                                height: size,
                                width: size,
                                child: Image.asset("assets/files/ts.png"))
                            : fileExt == "rb"
                                ? SizedBox(
                                    height: size,
                                    width: size,
                                    child: Image.asset("assets/files/ruby.png"))
                                : fileExt == "sql"
                                    ? SizedBox(
                                        height: size,
                                        width: size,
                                        child:
                                            Image.asset("assets/files/sql.png"))
                                    : fileExt == "php"
                                        ? SizedBox(
                                            height: size,
                                            width: size,
                                            child: Image.asset(
                                                "assets/files/php.png"))
                                        : fileExt == "txt"
                                            ? SizedBox(
                                                height: size,
                                                width: size,
                                                child: Image.asset(
                                                    "assets/files/text.png"))
                                            : fileExt == "kt"
                                                ? SizedBox(
                                                    height: size,
                                                    width: size,
                                                    child: Image.asset(
                                                        "assets/files/kotlin.png"))
                                                : fileExt == "c" ||
                                                        fileExt == "cpp"
                                                    ? SizedBox(
                                                        height: size,
                                                        width: size,
                                                        child: Image.asset(
                                                            "assets/files/c.png"))
                                                    : fileExt == "pem" ||
                                                            fileExt == "jks" ||
                                                            fileExt == "key" ||
                                                            fileExt == "rsa"
                                                        ? SizedBox(
                                                            height: size,
                                                            width: size,
                                                            child: Image.asset(
                                                                "assets/files/key.png"))
                                                        : SizedBox(
                                                            height: size,
                                                            width: size,
                                                            child: Image.asset(
                                                                "assets/icons/file.png"));
  }
}
