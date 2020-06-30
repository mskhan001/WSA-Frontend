import '../bloc_Transition/transitions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'SideBar.dart';
import 'package:flutter/material.dart';

class SidebarLayout extends StatelessWidget {
  String tokens;
  String phonenum;
  String name;
  SidebarLayout({this.tokens, this.phonenum, this.name});
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider<NavigationBloc>(
            create: (context) =>
                NavigationBloc(tokens: tokens, phonenum: phonenum, name: name),
            child: Stack(
              children: <Widget>[
                BlocBuilder<NavigationBloc, Navigationstates>(
                  builder: (context, navigationstates) {
                    return navigationstates as Widget;
                  },
                ),
                Sidebar(tokens: tokens, phonenum: phonenum, name: name),
              ],
            )));
  }
}
