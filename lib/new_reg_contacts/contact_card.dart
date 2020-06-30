import 'package:flutter/material.dart';
import '../Sign_in_up/components/constants.dart';

class ContactCard extends StatelessWidget {
  final String name;
  final String initials;
  final String mobileNumber;
  final Color color;
  final Function onLongPress;
  final Function onTap;
  final Widget trailing;
  ContactCard(
      {this.name,
      this.initials,
      this.mobileNumber,
      this.color,
      this.onLongPress,
      this.onTap,
      this.trailing});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
        color: color,
        elevation: 1.0,
        margin: EdgeInsets.symmetric(horizontal: 1, vertical: 0.1),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
          leading: Container(
            decoration: BoxDecoration(
                border:
                    Border(right: BorderSide(width: 1.0, color: Colors.grey))),
            padding: EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              backgroundColor: primaryLightColor,
              child: Text(
                initials,
                style: TextStyle(color: primaryColor),
              ),
            ),
          ),
          title: Text(
            name,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(mobileNumber),
          trailing: trailing,
        ),
      ),
    );
  }
}
