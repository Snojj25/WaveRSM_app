import 'package:flutter/cupertino.dart';

enum Roles {
  subscriber,
  editor,
  admin,
}

class User {
  final String uid;
  final String email;

  User({this.uid, this.email});
}

class UserData extends ChangeNotifier {
  String uid;
  String name;
  String email;
  String password;
  String imageUrl;
  List<Roles> roles;

  UserData({
    this.uid,
    this.name,
    this.email,
    this.password,
    this.imageUrl,
    this.roles,
  });
}
