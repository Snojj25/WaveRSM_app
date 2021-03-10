import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './models/post.dart';
import './models/user.dart';
import './screens/authenticate/login_screen.dart';
import './screens/authenticate/register_screen.dart';
import './screens/posts/new_post.dart';
import './screens/wrapper.dart';
import './services/auth.service.dart';
import './models/trade.model.dart';
import './screens/home_screen/home_screen.dart';
import './services/database.service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(
          value: AuthService().user,
        ),
        StreamProvider<List<Trade>>.value(
          value: DataBaseService().trades,
        ),
        StreamProvider<UserData>.value(
          value: DataBaseService().userData,
        ),
        StreamProvider<List<Post>>.value(
          value: DataBaseService().videoPosts,
        ),
        StreamProvider<List<Post>>.value(
          value: DataBaseService().photoPosts,
        ),
      ],
      child: Platform.isAndroid
          ? MaterialApp(
              title: 'Forex app',
              theme: ThemeData(
                typography: Typography.material2018(
                  black: Typography.blackHelsinki,
                  white: Typography.whiteMountainView,
                ),
                hintColor: Colors.white60,
                textTheme: TextTheme(
                  bodyText1: TextStyle(color: Colors.grey[600]),
                  bodyText2: TextStyle(color: Colors.grey[600]),
                ),
                backgroundColor: Colors.indigo[900],
                primaryColor: Colors.black,
                primaryColorDark: Colors.indigo[900],
                primaryColorLight: Colors.grey[800],
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: Wrapper(),
              routes: {
                HomeScreen.routeName: (ctx) => HomeScreen(),
                RegisterProfileScreen.routeName: (ctx) =>
                    RegisterProfileScreen(),
                SignIn.routeName: (ctx) => SignIn(),
                NewPost.routeName: (ctx) => NewPost(),
              },
            )
          : CupertinoApp(
              title: 'Forex app',
              theme: CupertinoThemeData(
                primaryColor: Colors.purple,
                barBackgroundColor: Colors.yellow,
                scaffoldBackgroundColor: Colors.orange,
              ),
              color: Colors.black,
              home: Wrapper(),
              routes: {
                HomeScreen.routeName: (ctx) => HomeScreen(),
                RegisterProfileScreen.routeName: (ctx) =>
                    RegisterProfileScreen(),
                SignIn.routeName: (ctx) => SignIn(),
                NewPost.routeName: (ctx) => NewPost(),
              },
            ),
    );
  }
}
