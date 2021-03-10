import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SecondCard extends StatelessWidget {
  final String colorScheme;
  const SecondCard({Key key, @required this.colorScheme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: colorScheme == "dark" ? Colors.blueGrey[200] : Colors.black87,
      elevation: 4.0,
      margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.lock_outline,
              color: colorScheme == "dark" ? Colors.black : Colors.white,
            ),
            title: Text(
              "Change Password",
              style: TextStyle(
                color: colorScheme == "dark" ? Colors.black : Colors.white,
              ),
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: colorScheme == "dark" ? Colors.black : Colors.white,
            ),
            onTap: () {
              //open change password
            },
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.language,
              color: colorScheme == "dark" ? Colors.black : Colors.white,
            ),
            title: Text(
              "Change Language",
              style: TextStyle(
                color: colorScheme == "dark" ? Colors.black : Colors.white,
              ),
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: colorScheme == "dark" ? Colors.black : Colors.white,
            ),
            onTap: () {
              //open change language
            },
          ),
          ListTile(
            leading: Icon(
              Icons.location_on,
              color: colorScheme == "dark" ? Colors.black : Colors.white,
            ),
            title: Text(
              "Change Location",
              style: TextStyle(
                color: colorScheme == "dark" ? Colors.black : Colors.white,
              ),
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: colorScheme == "dark" ? Colors.black : Colors.white,
            ),
            onTap: () {
              //open change location
            },
          ),
        ],
      ),
    );
  }
}
