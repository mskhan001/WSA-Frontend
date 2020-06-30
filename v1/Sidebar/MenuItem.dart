import 'package:flutter/material.dart';
import 'package:scbproject/Sign_in_up/components/constants.dart';

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onTap;

  const MenuItem({Key key, this.icon, this.title, this.onTap})
      : super(key: key);

  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Expanded(
          child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              leading: Icon(icon, color: primaryColor),
              title: Text(
                title,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: primaryColor,
                    fontSize: 18),
              )),
        ));
  }
}
