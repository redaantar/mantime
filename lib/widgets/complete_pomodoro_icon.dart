import 'package:flutter/material.dart';
import 'package:mantime/theme/theme.dart';

class PomodoroIcons extends StatelessWidget {
  final int number;
  final int completed;
  // ignore: use_key_in_widget_constructors
  const PomodoroIcons({required this.number, required this.completed});

  @override
  Widget build(BuildContext context) {
    const double iconSize = 30.0;
    List<Padding> icons = [];
    const Padding completedIcon = Padding(
      padding: EdgeInsets.only(left: 5),
      child: CircleAvatar(
        backgroundColor: Colors.green,
        child: Icon(
          Icons.check,
          size: iconSize,
          color: Colors.white,
        ),
      ),
    );
    const Padding uncompletedIcon = Padding(
      padding: EdgeInsets.only(left: 5),
      child: CircleAvatar(
        backgroundColor: darkHeaderColor,
        child: Icon(
          Icons.check,
          size: iconSize,
          color: Colors.white,
        ),
      ),
    );

    for (int i = 0; i < number; i++) {
      if (i < completed) {
        icons.add(completedIcon);
      } else {
        icons.add(uncompletedIcon);
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: icons,
    );
  }
}
