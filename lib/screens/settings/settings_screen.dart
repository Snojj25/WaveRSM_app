import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_settings.config.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/user.dart';
import '../../shared/app_drawer.dart';
import '../posts/new_post_helpers/video_post.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = "/settings-screen";
  final String colorScheme;

  SettingsScreen({@required this.colorScheme});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _colorScheme;

  bool _appUpdates;

  @override
  void initState() {
    super.initState();
    _appUpdates = false;
    _colorScheme = widget.colorScheme;
  }

  @override
  Widget build(BuildContext context) {
    final UserData userData = Provider.of<UserData>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: _colorScheme == "dark" ? Colors.white : Colors.black),
        elevation: 0,
        brightness: _colorScheme == "dark" ? Brightness.dark : Brightness.light,
        backgroundColor:
            _colorScheme == "dark" ? Colors.black : Colors.grey[400],
        title: Text(
          'Settings',
          style: TextStyle(
              color: _colorScheme == "dark" ? Colors.white : Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              FontAwesomeIcons.solidMoon,
              color: _colorScheme == "dark" ? Colors.white : Colors.black,
            ),
            onPressed: () async {
              print(GlobalConfiguration().getValue("colorScheme"));
              if (_colorScheme == "dark") {
                await setColorScheme("light");
                GlobalConfiguration().updateValue("colorScheme", "light");
                setState(() {
                  _colorScheme = "light";
                });
              } else {
                await setColorScheme("dark");
                GlobalConfiguration().updateValue("colorScheme", "dark");
                setState(() {
                  _colorScheme = "dark";
                });
              }
              print(GlobalConfiguration().getValue("colorScheme"));
            },
          )
        ],
      ),
      drawer:
          AppDrawer(userData: userData, colorScheme: colorScheme, active: 3),
      body: Container(
        decoration: BoxDecoration(
          gradient: _colorScheme == "dark"
              ? LinearGradient(
                  colors: [Colors.indigo[900], Colors.grey[900]],
                )
              : LinearGradient(
                  colors: [Colors.grey[400], Colors.white],
                ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // ? ===================================================
                  Card(
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    color: _colorScheme == "dark"
                        ? Colors.blueGrey[200]
                        : Colors.black,
                    child: ListTile(
                      onTap: () {
                        //open edit profile
                      },
                      title: Text(
                        "John Doe",
                        style: TextStyle(
                          color: _colorScheme == "dark"
                              ? Colors.black
                              : Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundImage: AssetImage("assets/profile.png"),
                      ),
                      trailing: Icon(
                        Icons.edit,
                        color: _colorScheme == "dark"
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Card(
                    color: _colorScheme == "dark"
                        ? Colors.blueGrey[200]
                        : Colors.black87,
                    elevation: 4.0,
                    margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: Icon(
                            Icons.lock_outline,
                            color: _colorScheme == "dark"
                                ? Colors.black
                                : Colors.white,
                          ),
                          title: Text(
                            "Change Password",
                            style: TextStyle(
                              color: _colorScheme == "dark"
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            color: _colorScheme == "dark"
                                ? Colors.black
                                : Colors.white,
                          ),
                          onTap: () {
                            //open change password
                          },
                        ),
                        _buildDivider(),
                        ListTile(
                          leading: Icon(
                            FontAwesomeIcons.language,
                            color: _colorScheme == "dark"
                                ? Colors.black
                                : Colors.white,
                          ),
                          title: Text(
                            "Change Language",
                            style: TextStyle(
                              color: _colorScheme == "dark"
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            color: _colorScheme == "dark"
                                ? Colors.black
                                : Colors.white,
                          ),
                          onTap: () {
                            //open change language
                          },
                        ),
                        _buildDivider(),
                        ListTile(
                          leading: Icon(
                            Icons.location_on,
                            color: _colorScheme == "dark"
                                ? Colors.black
                                : Colors.white,
                          ),
                          title: Text(
                            "Change Location",
                            style: TextStyle(
                              color: _colorScheme == "dark"
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            color: _colorScheme == "dark"
                                ? Colors.black
                                : Colors.white,
                          ),
                          onTap: () {
                            //open change location
                          },
                        ),
                      ],
                    ),
                  ),
                  // ? ======================================================
                  const SizedBox(height: 20.0),
                  Text(
                    "Notification Settings",
                    style: TextStyle(
                      shadows: [
                        Shadow(
                            color: Colors.blue,
                            blurRadius: 5,
                            offset: Offset.fromDirection(6, 5)),
                        Shadow(
                            color: Colors.white,
                            blurRadius: 5,
                            offset: Offset.fromDirection(6, 5)),
                        Shadow(
                            color: Colors.blue,
                            blurRadius: 5,
                            offset: Offset.fromDirection(6, 5))
                      ],
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color:
                          _colorScheme == "dark" ? Colors.black : Colors.white,
                    ),
                  ),
                  SwitchListTile(
                    activeColor:
                        _colorScheme == "dark" ? Colors.blue : Colors.black,
                    contentPadding: const EdgeInsets.all(0),
                    value: true,
                    title: Text(
                      "Received notification",
                      style: TextStyle(
                          color: _colorScheme == "dark"
                              ? Colors.white
                              : Colors.black),
                    ),
                    onChanged: (val) {},
                  ),
                  SwitchListTile(
                    activeColor:
                        _colorScheme == "dark" ? Colors.blue : Colors.black,
                    contentPadding: const EdgeInsets.all(0),
                    value: false,
                    title: Text(
                      "Received newsletter",
                      style: TextStyle(
                          color: _colorScheme == "dark"
                              ? Colors.white
                              : Colors.black),
                    ),
                    onChanged: null,
                  ),
                  SwitchListTile(
                    activeColor:
                        _colorScheme == "dark" ? Colors.blue : Colors.black,
                    contentPadding: const EdgeInsets.all(0),
                    value: true,
                    title: Text(
                      "Received Offer Notification",
                      style: TextStyle(
                          color: _colorScheme == "dark"
                              ? Colors.white
                              : Colors.black),
                    ),
                    onChanged: (val) {},
                  ),
                  SwitchListTile(
                    value: _appUpdates,
                    activeColor:
                        _colorScheme == "dark" ? Colors.blue : Colors.black,
                    contentPadding: const EdgeInsets.all(0),
                    title: Text(
                      "Received App Updates",
                      style: TextStyle(
                          color: _colorScheme == "dark"
                              ? Colors.white
                              : Colors.black),
                    ),
                    onChanged: (bool newValue) {
                      print(_appUpdates);
                      setState(() {
                        _appUpdates = newValue;
                      });
                      print(_appUpdates);
                    },
                  ),
                  const SizedBox(height: 60.0),
                  // RaisedButton(onPressed: () {
                  //   getSettings();
                  // })
                ],
              ),
            ),
            // ? ==========================================================
            Positioned(
              bottom: -20,
              left: -20,
              child: Container(
                width: 80,
                height: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.purple,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: 00,
              left: 00,
              child: IconButton(
                icon: Icon(
                  FontAwesomeIcons.powerOff,
                  color: Colors.white,
                ),
                onPressed: () {
                  //log out
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }
}
