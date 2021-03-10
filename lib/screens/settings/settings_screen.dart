import 'package:flutter/material.dart';
import 'package:forex_app/screens/posts/new_post_helpers/video_post.dart';
import 'package:forex_app/screens/settings/settings_utils/settings_cards.dart';
import 'package:forex_app/screens/settings/settings_utils/settings_swithces.dart';
import 'package:forex_app/shared/bottom_nav_bar.dart';
import 'package:forex_app/shared/overlays.dart';
import 'package:provider/provider.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'app_settings.config.dart';
import '../../models/user.dart';
import '../../shared/app_drawer.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = "/settings-screen";

  SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  String _colorScheme;

  bool isLoading = true;
  bool photoMode = true;
  bool isModalOpen = false;

  List<OverlayEntry> entries = [];

  AnimationController _positionController;
  Animation<double> _animation1;
  Animation<double> _animation2;
  Animation<double> _animation3;

  AnimationController _colorController;

  List<Animation> _animations;

  List<dynamic> _functions;

  List<IconData> _icons = [Icons.ac_unit, Icons.feedback, Icons.party_mode];

  @override
  void initState() {
    // =======================================
    // =======================================
    super.initState();
    getColorScheme().then((value) {
      GlobalConfiguration().addValue("colorScheme", value);
      setState(() {
        _colorScheme = value;
      });
    }).catchError((err) {
      print("error code: failed home screen init state color scheme set");
      print(err);
    });
    // =======================================
    // =======================================
    _positionController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _animation1 = Tween<double>(begin: 1, end: 0.15).animate(
      CurvedAnimation(
        parent: _positionController,
        curve: Interval(0.0, 0.6, curve: Curves.decelerate),
      ),
    );
    _animation2 = Tween<double>(begin: 1, end: 0.08).animate(
      CurvedAnimation(
        parent: _positionController,
        curve: Interval(0.0, 0.8, curve: Curves.decelerate),
      ),
    );
    _animation3 = Tween<double>(begin: 1, end: 0.01).animate(
      CurvedAnimation(
        parent: _positionController,
        curve: Interval(0.0, 1.0, curve: Curves.decelerate),
      ),
    );
    // =======================================
    // =======================================
    _colorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
    // =======================================
    // =======================================
    _animations = [_animation1, _animation2, _animation3];
    void f1() {
      print("f1");
    }

    void f2() {
      print("f2");
    }

    void f3() {
      setState(() {
        photoMode = !photoMode;
      });
    }

    _functions = [f1, f2, f3];
  }

  @override
  void dispose() {
    if (entries.isNotEmpty) {
      for (OverlayEntry entry in entries) {
        entry.remove();
      }
    }
    _positionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserData userData = Provider.of<UserData>(context);
    var scaffold = Scaffold(
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
              setState(() {
                changeColorScheme();
              });
            },
          )
        ],
      ),
      drawer:
          AppDrawer(userData: userData, colorScheme: _colorScheme, active: 3),
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
                  const SizedBox(height: 20.0),
                  // ? ======
                  SecondCard(colorScheme: _colorScheme),
                  // ? ======
                  const SizedBox(height: 20.0),
                  // ? =======
                  SettingsSwitches(colorScheme: _colorScheme),
                  // ? =======
                  const SizedBox(height: 60.0),
                ],
              ),
            ),
            // ? ==========================================================
          ],
        ),
      ),
      // ! BOTTOM NAVIGATION BAR ========
      bottomNavigationBar:
          BottomNavBar(colorScheme: _colorScheme, activeIdx: 3),
      floatingActionButton: FloatingActionButton(
          child: Icon(
            isModalOpen ? Icons.close : Icons.view_headline,
            size: 40,
          ),
          onPressed: () {
            setState(() {
              if (isModalOpen) {
                removeOverlay(_positionController, entries);
              } else {
                entries = showOverlay(
                  context,
                  _positionController,
                  _colorController,
                  _animations,
                  _functions,
                  _icons,
                  colorScheme,
                );
              }
              isModalOpen = !isModalOpen;
            });
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // ! BOTTOM NAVIGATION BAR =================================
    );
    return scaffold;
  }

  changeColorScheme() async {
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
  }
}
