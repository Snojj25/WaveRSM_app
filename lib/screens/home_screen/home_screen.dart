import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:global_configuration/global_configuration.dart';

import './home_screen_helpers/home_screen_photos.dart';
import './home_screen_helpers/home_screen_videos.dart';
import '../settings/app_settings.config.dart';
import '../../models/user.dart';
import '../../services/auth.service.dart';
import '../../shared/app_drawer.dart';
// import '../settings/app_settings.config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);
  static const routeName = "home-screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  String colorScheme;

  @override
  void initState() {
    getColorScheme().then((value) {
      GlobalConfiguration().addValue("colorScheme", value);
      setState(() {
        colorScheme = value;
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
        : DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor:
                    colorScheme == "dark" ? Colors.black : Colors.grey[500],
                iconTheme: IconThemeData(
                    color: colorScheme == "dark" ? Colors.white : Colors.black),
                title: Text(
                  "home screen",
                  style: TextStyle(
                      color:
                          colorScheme == "dark" ? Colors.white : Colors.black),
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
                bottom: TabBar(
                  tabs: [
                    Tab(
                      text: "photos",
                    ),
                    Tab(text: "videos"),
                  ],
                  labelColor:
                      colorScheme == "dark" ? Colors.white : Colors.black,
                  indicatorColor:
                      colorScheme == "dark" ? Colors.white : Colors.black,
                ),
              ),
              body: TabBarView(children: [
                HomeScreenPhotos(colorScheme: colorScheme),
                HomeScreenVideos(colorScheme: colorScheme),
              ]),
              drawer: AppDrawer(
                  userData: userData, colorScheme: colorScheme, active: 0),
            ),
          );
  }
}
