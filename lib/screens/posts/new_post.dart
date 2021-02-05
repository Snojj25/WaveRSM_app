import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../settings/app_settings.config.dart';
import '../../shared/app_drawer.dart';
import './new_post_helpers/video_post.dart';
import './new_post_helpers/photo_post.dart';

class NewPost extends StatefulWidget {
  NewPost({Key key}) : super(key: key);
  static const routeName = "new-post-screen";

  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  String colorScheme;

  @override
  void initState() {
    super.initState();
    getColorScheme().then((value) {
      setState(() {
        colorScheme = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserData userData = Provider.of<UserData>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // backgroundColor: Colors.indigo[900],
        // !==========================================================================
        appBar: AppBar(
          backgroundColor:
              colorScheme == "dark" ? Colors.black : Colors.grey[500],
          elevation: 0,
          iconTheme: IconThemeData(
              color: colorScheme == "dark" ? Colors.white : Colors.black),
          brightness:
              colorScheme == "dark" ? Brightness.dark : Brightness.light,
          title: Text(
            'New Post',
            style: TextStyle(
                color: colorScheme == "dark" ? Colors.white : Colors.black),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  "Photo",
                  style: TextStyle(
                      color:
                          colorScheme == "dark" ? Colors.white : Colors.black),
                ),
              ),
              Tab(
                child: Text(
                  "Video",
                  style: TextStyle(
                      color:
                          colorScheme == "dark" ? Colors.white : Colors.black),
                ),
              ),
            ],
            indicatorColor: colorScheme == "dark" ? Colors.white : Colors.black,
          ),
        ),
        // !==========================================================================
        drawer:
            AppDrawer(userData: userData, colorScheme: colorScheme, active: 2),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colorScheme == "dark"
                  ? [Colors.indigo[900], Colors.grey[900]]
                  : [Colors.grey[500], Colors.white],
              begin: Alignment.topLeft,
            ),
          ),
          child: TabBarView(
            children: [PhotoPost(), VideoPost()],
          ),
        ),
      ),
    );
  }
}
