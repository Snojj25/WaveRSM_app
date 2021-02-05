import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forex_app/screens/settings/app_settings.config.dart';

import '../screens/posts/new_post.dart';
import '../screens/settings/settings_screen.dart';
import '../models/user.dart';
import '../screens/trades/trades_screen.dart';

class AppDrawer extends StatefulWidget {
  final UserData userData;
  final String colorScheme;
  final int active;

  AppDrawer(
      {@required this.userData,
      @required this.colorScheme,
      @required this.active});
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.colorScheme == "dark"
                ? [Colors.grey[900], Colors.indigo[900], Colors.indigo[800]]
                : [Colors.grey[500], Colors.white],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            //  ! ===============================================
            //  ! ACCOUNT HEADER
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: widget.colorScheme == "dark"
                    ? Colors.black
                    : Colors.grey[800],
              ),
              accountName: Text(widget.userData.name),
              accountEmail: Text(widget.userData.email),
              currentAccountPicture: GestureDetector(
                // onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("assets/profile.png"),
                    ),
                  ),
                ),
              ),
              otherAccountsPictures: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    final String colorScheme = await getColorScheme();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          SettingsScreen(colorScheme: colorScheme),
                    ));
                  },
                )
              ],
            ),
            //  ! ===============================================
            //  ! HOME SCREEN
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: widget.colorScheme == "dark"
                        ? Colors.white
                        : Colors.black,
                    width: widget.active == 0 ? 3 : 0.3),
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: widget.colorScheme == "dark"
                      ? [Colors.indigo[900], Colors.grey[900]]
                      : [Colors.white, Colors.grey[500]],
                ),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
              child: ListTile(
                title: Text(
                  "Home Screen",
                  style: TextStyle(
                    fontSize: 20,
                    color: widget.colorScheme == "dark"
                        ? Colors.white
                        : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      "home-screen", (Route<dynamic> route) => false);
                },
              ),
            ),
            //  ! ===============================================
            //  ! TRADES
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: widget.colorScheme == "dark"
                        ? Colors.white
                        : Colors.black,
                    width: widget.active == 1 ? 3 : 0.3),
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: widget.colorScheme == "dark"
                      ? [Colors.indigo[900], Colors.grey[900]]
                      : [Colors.white, Colors.grey[500]],
                ),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
              child: ListTile(
                title: Text(
                  "Trades",
                  style: TextStyle(
                    fontSize: 20,
                    color: widget.colorScheme == "dark"
                        ? Colors.white
                        : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) =>
                          TradesScreen(colorScheme: widget.colorScheme),
                    ),
                  );
                },
              ),
            ),
            //  ! ===============================================
            //  ! POSTS
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: widget.colorScheme == "dark"
                        ? Colors.white
                        : Colors.black,
                    width: widget.active == 2 ? 3 : 0.3),
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: widget.colorScheme == "dark"
                      ? [Colors.indigo[900], Colors.grey[900]]
                      : [Colors.white, Colors.grey[500]],
                ),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
              child: ListTile(
                title: Text(
                  "Posts",
                  style: TextStyle(
                    fontSize: 20,
                    color: widget.colorScheme == "dark"
                        ? Colors.white
                        : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(NewPost.routeName);
                },
              ),
            ),
            //  ! ===============================================
            //  ! SETTINGS
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: widget.colorScheme == "dark"
                        ? Colors.white
                        : Colors.black,
                    width: widget.active == 3 ? 3 : 0.3),
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: widget.colorScheme == "dark"
                      ? [Colors.indigo[900], Colors.grey[900]]
                      : [Colors.white, Colors.grey[500]],
                ),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
              child: ListTile(
                title: Text(
                  "Settings",
                  style: TextStyle(
                    fontSize: 20,
                    color: widget.colorScheme == "dark"
                        ? Colors.white
                        : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) =>
                          SettingsScreen(colorScheme: widget.colorScheme),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
