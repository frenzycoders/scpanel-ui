import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:scpanel_ui/constants.dart';
import 'package:scpanel_ui/src/screens/responsive.dart';

class ProfileCard extends StatelessWidget {
  ProfileCard({
    Key? key,
    required this.name,
    required this.onTap,
  }) : super(key: key);
  String name;
  Function onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.only(left: defaultPadding),
        padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding,
          vertical: defaultPadding / 2,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            const FaIcon(
              FontAwesomeIcons.userAlt,
              size: 20,
            ),
            if (!Responsive.isMobile(context))
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                child: Text("Jack Richer"),
              ),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }
}
