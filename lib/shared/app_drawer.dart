import 'package:flutter/material.dart';
import 'package:forex_app/screens/settings/app_settings.config.dart';

import '../screens/posts/new_post.dart';
import '../screens/settings/settings_screen.dart';
import '../models/user.dart';
import '../screens/trades/trades_screen.dart';

class AppDrawer extends StatefulWidget {
  final UserData userData;
  final String colorScheme;

  AppDrawer({@required this.userData, @required this.colorScheme});
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
            begin: Alignment.centerRight,
            colors: widget.colorScheme == "dark"
                ? [Colors.indigo[700], Colors.indigo[900]]
                : [Colors.grey[500], Colors.white],
          ),
        ),
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
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
            Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black12)),
              child: ListTile(
                title: Text(
                  "Trades",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(TradesScreen.routeName);
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black12)),
              child: ListTile(
                title: Text(
                  "Posts",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(NewPost.routeName);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
