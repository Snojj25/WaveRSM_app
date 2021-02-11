import 'package:flutter/material.dart';
import 'package:forex_app/services/auth.service.dart';

getHomeScreenAppbar(String colorScheme) {
  return AppBar(
    backgroundColor: colorScheme == "dark" ? Colors.black : Colors.grey[500],
    iconTheme: IconThemeData(
        color: colorScheme == "dark" ? Colors.white : Colors.black),
    title: Text(
      "home screen",
      style:
          TextStyle(color: colorScheme == "dark" ? Colors.white : Colors.black),
    ),
    actions: [
      IconButton(
        icon: Icon(Icons.exit_to_app),
        onPressed: () {
          // Navigator.of(context).pushReplacementNamed(SignIn.routeName);
          AuthService().signOut();
        },
      )
    ],
  );
}
