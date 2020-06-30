import 'package:flutter/material.dart';
import 'constants.dart';

class RoundButton extends StatelessWidget {
  final String buttonName;
  final Function onPress;
  final Color color;
  final Color textColor;

  RoundButton(
      {this.buttonName,
      this.onPress,
      this.color = primaryColor,
      this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
      ),
      child: FlatButton(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          onPressed: onPress,
          child: Text(
            buttonName,
            style: TextStyle(color: textColor),
          )),
    );
  }
}
