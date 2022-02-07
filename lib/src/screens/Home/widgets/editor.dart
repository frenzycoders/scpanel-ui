import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Editor extends StatefulWidget {
  Editor({
    Key? key,
    required this.textEditingController,
  }) : super(key: key);
  TextEditingController textEditingController;
  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextField(
          autofocus: true,
          showCursor: false,
          controller: widget.textEditingController,
          expands: true,
          maxLines: null,
          style: const TextStyle(color: Colors.transparent),
          onChanged: (val) {
            print('simple');
            print(widget.textEditingController.text);
            print('split with space');
            print(widget.textEditingController.text.split(' '));
            print('split with new line');
            print(widget.textEditingController.text.split('\n'));
            setState(() {});
          },
        ),
        RichText(
          text: TextSpan(
              children: widget.textEditingController.text
                  .split('\n')
                  .map(
                    (e) => TextSpan(
                      text: '0',
                      children: widget.textEditingController.text
                          .split(' ')
                          .map(
                            (e) => TextSpan(
                              text: ' ' + e,
                              style: e == 'const'
                                  ? const TextStyle(
                                      color: Colors.red,
                                    )
                                  : const TextStyle(
                                      color: Colors.white,
                                    ),
                            ),
                          )
                          .toList(),
                    ),
                  )
                  .toList()),
        )
      ],
    );
  }
}
