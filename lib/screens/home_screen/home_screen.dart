import 'package:flutter/material.dart';
import 'package:forex_app/screens/settings/app_settings.config.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import 'package:global_configuration/global_configuration.dart';

import '../../models/user.dart';
import '../../services/auth.service.dart';
import '../../shared/app_drawer.dart';
import '../../models/post.dart';
import '../../services/database.service.dart';
import '../../shared/video_player.dart';
// import '../settings/app_settings.config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);
  static const routeName = "home-screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  String _colorScheme;

  @override
  void initState() {
    getColorScheme().then((value) {
      GlobalConfiguration().addValue("colorScheme", value);
      setState(() {
        _colorScheme = value;
      });
    }).catchError((err) {
      print("error code: failed home screen init state color scheme set");
      print(err);
    });
    isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserData userData = Provider.of<UserData>(context);
    // final String colorScheme = GlobalConfiguration().getValue("colorScheme");
    return isLoading
        ? CircularProgressIndicator()
        : Scaffold(
            appBar: AppBar(
              title: Text("home screen"),
              actions: [
                IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    // Navigator.of(context).pushReplacementNamed(SignIn.routeName);
                    AuthService().signOut();
                  },
                )
              ],
            ),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _colorScheme == "dark"
                      ? [Colors.indigo[900], Colors.grey[900]]
                      : [Colors.grey[500], Colors.white],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    alignment: Alignment.center,
                    child: Text(
                      "ANALYSES",
                      textScaleFactor: 1.7,
                      style: TextStyle(
                          color: _colorScheme == "dark"
                              ? Colors.grey[300]
                              : Colors.indigo[900]),
                    ),
                  ),
                  Expanded(child: AnalysesList()),
                ],
              ),
            ),
            drawer: AppDrawer(userData: userData, colorScheme: _colorScheme),
          );
  }
}

//! ============================================================
//! ============================================================

class AnalysesList extends StatefulWidget {
  const AnalysesList({Key key}) : super(key: key);

  @override
  _AnalysesListState createState() => _AnalysesListState();
}

class _AnalysesListState extends State<AnalysesList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DataBaseServce().posts,
      builder: (BuildContext ctx, AsyncSnapshot<List<Post>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        return Container(
          margin: const EdgeInsets.all(10),
          height: double.maxFinite,
          child: ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (ctx, idx) {
              return Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(color: Colors.black, spreadRadius: 3)
                    ],
                    color: Colors.grey[400]),
                child: VideoContainer(post: snapshot.data[idx]),
              );
            },
          ),
        );
      },
    );
  }
}

// ! =========================================================
//! ==========================================================

class VideoContainer extends StatefulWidget {
  final Post post;
  VideoContainer({Key key, @required this.post}) : super(key: key);

  @override
  _VideoContainerState createState() => _VideoContainerState();
}

class _VideoContainerState extends State<VideoContainer> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    return Column(
      children: [
        ListTile(
          title: Text(widget.post.title),
          trailing: ButtonBar(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.lock_outline,
                  color: Colors.black,
                  size: 40,
                ),
                onPressed: () async {
                  await DataBaseServce()
                      .removeAllowedUser(widget.post.id, user.uid)
                      .catchError((err) {
                    print("Error code: 1011");
                    print(err);
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.lock_open,
                  color: Colors.black,
                  size: 40,
                ),
                onPressed: () async {
                  await DataBaseServce()
                      .addAllowedUser(widget.post.id, user.uid)
                      .catchError((err) {
                    print("Error code: 1011");
                    print(err);
                  });
                },
              )
            ],
          ),
        ),
        widget.post.allowedUsers.contains(user.uid)
            ? Container(
                child: CustomVideoPlayer(
                  videoPlayerController:
                      VideoPlayerController.network(widget.post.imgUrl),
                ),
              )
            : Container(
                alignment: Alignment.center,
                height: 300,
                color: Colors.black,
                child: Text(
                  "You can not see this video right now",
                  style: TextStyle(color: Colors.red[300]),
                  textScaleFactor: 1.5,
                ),
              ),
        ListTile(
          title: widget.post.allowedUsers.contains(user.uid)
              ? Text(widget.post.description)
              : Text("Description is locked"),
        ),
      ],
    );
  }
}

// ! =========================================================
