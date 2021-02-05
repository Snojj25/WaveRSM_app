import 'package:flutter/cupertino.dart';

class Post {
  final String id;
  final String title;
  final String description;
  final String imgUrl;
  final DateTime dateTime;
  final String symbol;
  // final List<dynamic> allowedUsers;

  Post({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imgUrl,
    @required this.dateTime,
    @required this.symbol,
    // this.allowedUsers,
  });
}
