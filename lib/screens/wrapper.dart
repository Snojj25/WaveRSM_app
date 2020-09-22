import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

import '../models/user.dart';
import '../screens/authenticate/login_screen.dart';
import '../screens/home_screen/home_screen.dart';
import '../services/auth.service.dart';

// import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().user,
      builder: (BuildContext ctx, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.data == null) {
          return SignIn();
        } else {
          GlobalConfiguration().clear();
          GlobalConfiguration().addValue("uid", snapshot.data.uid);
          return HomeScreen();
        }
      },
    );
  }
}
