import 'package:flutter/material.dart';
import 'package:forex_app/models/user.dart';
import 'package:forex_app/screens/home_screen/home_screen_helpers/home_screen_videos.dart';
import 'package:forex_app/shared/app_drawer.dart';
import 'package:forex_app/shared/bottom_nav_bar.dart';
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

  OverlayEntry overlayEntry1;
  OverlayEntry overlayEntry2;
  OverlayEntry overlayEntry3;

  AnimationController _controller;
  Animation<double> _animation1;
  Animation<double> _animation2;
  Animation<double> _animation3;

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

    super.initState();
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
            floatingActionButton: FloatingActionButton(onPressed: () {
              setState(() {
                if (isModalOpen) {
                  removeOverlay(context);
                } else {
                  showOverlay(context);
                }
                isModalOpen = !isModalOpen;
              });
            }),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            // ! BOTTOM NAVIGATION BAR =================================
          );
  }

  showOverlay(BuildContext context) {
    OverlayState overlayState = Overlay.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    overlayEntry1 = OverlayEntry(
      maintainState: false,
      builder: (context) => Positioned(
        bottom: 0.12 * height,
        right: _animation1.value * width,
        child: RawMaterialButton(
          onPressed: () {},
          elevation: 2.0,
          fillColor: Colors.white,
          child: Icon(
            Icons.layers_clear,
            size: 40.0,
            color: Colors.black,
          ),
          padding: EdgeInsets.all(10.0),
          shape: CircleBorder(),
        ),
      ),
    );

    overlayEntry2 = OverlayEntry(
      maintainState: false,
      builder: (context) => Positioned(
        bottom: 0.24 * height,
        right: _animation2.value * width,
        child: RawMaterialButton(
          onPressed: () {},
          elevation: 2.0,
          fillColor: Colors.white,
          child: Icon(
            Icons.layers_clear,
            size: 40.0,
            color: Colors.black,
          ),
          padding: EdgeInsets.all(10.0),
          shape: CircleBorder(),
        ),
      ),
    );

    overlayEntry3 = OverlayEntry(
      maintainState: false,
      builder: (context) => Positioned(
        bottom: 0.36 * height,
        right: _animation3.value * width,
        child: RawMaterialButton(
          onPressed: () {
            setState(() {
              photoMode = !photoMode;
            });
          },
          elevation: 2.0,
          fillColor: Colors.white,
          child: Icon(
            Icons.navigation,
            size: 40.0,
            color: Colors.black,
          ),
          padding: EdgeInsets.all(10.0),
          shape: CircleBorder(),
        ),
      ),
    );

    _controller.addListener(() {
      overlayState.setState(() {});
    });

    overlayState.insert(overlayEntry1);
    overlayState.insert(overlayEntry2);
    overlayState.insert(overlayEntry3);

    _controller.forward();
  }

  removeOverlay(context) {
    _controller.reverse().whenComplete(() {
      overlayEntry1.remove();
      overlayEntry2.remove();
      overlayEntry3.remove();
    });
  }
}
