import 'package:flutter/material.dart';
import 'package:forex_app/models/user.dart';
import 'package:forex_app/screens/home_screen/home_screen_helpers/home_screen_videos.dart';
import 'package:forex_app/shared/app_drawer.dart';
import 'package:forex_app/shared/bottom_nav_bar.dart';
import 'package:forex_app/shared/overlays.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:provider/provider.dart';

import './home_screen_helpers/home_screen_photos.dart';
import '../settings/app_settings.config.dart';
import 'home_screen_helpers/home_screen_appbar.dart';
// import '../settings/app_settings.config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);
  static const routeName = "home-screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  bool photoMode = true;
  String colorScheme;
  bool isModalOpen = false;

  List<OverlayEntry> entries;

  AnimationController _controller;
  Animation<double> _animation1;
  Animation<double> _animation2;
  Animation<double> _animation3;

  List<Animation> _animations;

  List<dynamic> _functions;

  List<IconData> _icons = [Icons.ac_unit, Icons.feedback, Icons.party_mode];

  //? ==================================================================
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

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _animation1 = Tween<double>(begin: 1, end: 0.15).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.6, curve: Curves.decelerate),
      ),
    );
    _animation2 = Tween<double>(begin: 1, end: 0.08).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.8, curve: Curves.decelerate),
      ),
    );
    _animation3 = Tween<double>(begin: 1, end: 0.01).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 1.0, curve: Curves.decelerate),
      ),
    );

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

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //? ==================================================================

  @override
  Widget build(BuildContext context) {
    final UserData userData = Provider.of<UserData>(context);
    return isLoading
        ? CircularProgressIndicator()
        : Scaffold(
            appBar: getHomeScreenAppbar(colorScheme),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: colorScheme == "dark"
                      ? [Colors.indigo[900], Colors.grey[900]]
                      : [Colors.grey[500], Colors.white],
                ),
              ),
              child: !photoMode
                  ? HomeScreenPhotos(colorScheme: colorScheme)
                  : HomeScreenVideos(colorScheme: colorScheme),
            ),
            drawer: AppDrawer(
                userData: userData, colorScheme: colorScheme, active: 0),
            // ! BOTTOM NAVIGATION BAR ========
            bottomNavigationBar:
                BottomNavBar(colorScheme: colorScheme, activeIdx: 0),
            floatingActionButton: FloatingActionButton(
                child: Icon(
                  isModalOpen ? Icons.close : Icons.view_headline,
                  size: 40,
                ),
                onPressed: () {
                  setState(() {
                    if (isModalOpen) {
                      removeOverlay(context, _controller, entries);
                    } else {
                      entries = showOverlay(
                        context,
                        _controller,
                        _animations,
                        _functions,
                        _icons,
                      );
                    }
                    isModalOpen = !isModalOpen;
                  });
                }),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            // ! BOTTOM NAVIGATION BAR =================================
          );
  }
}
