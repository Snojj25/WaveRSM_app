import 'package:flutter/material.dart';

class SettingsSwitches extends StatelessWidget {
  final String colorScheme;
  const SettingsSwitches({Key key, @required this.colorScheme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
            color: colorScheme == "dark" ? Colors.black : Colors.white,
          ),
        ),
        SwitchListTile(
          activeColor: colorScheme == "dark" ? Colors.blue : Colors.black,
          contentPadding: const EdgeInsets.all(0),
          value: true,
          title: Text(
            "Received notification",
            style: TextStyle(
                color: colorScheme == "dark" ? Colors.white : Colors.black),
          ),
          onChanged: (val) {},
        ),
        SwitchListTile(
          activeColor: colorScheme == "dark" ? Colors.blue : Colors.black,
          contentPadding: const EdgeInsets.all(0),
          value: false,
          title: Text(
            "Received newsletter",
            style: TextStyle(
                color: colorScheme == "dark" ? Colors.white : Colors.black),
          ),
          onChanged: null,
        ),
        SwitchListTile(
          activeColor: colorScheme == "dark" ? Colors.blue : Colors.black,
          contentPadding: const EdgeInsets.all(0),
          value: true,
          title: Text(
            "Received Offer Notification",
            style: TextStyle(
                color: colorScheme == "dark" ? Colors.white : Colors.black),
          ),
          onChanged: (val) {},
        ),
        SwitchListTile(
          value: false,
          activeColor: colorScheme == "dark" ? Colors.blue : Colors.black,
          contentPadding: const EdgeInsets.all(0),
          title: Text(
            "Received App Updates",
            style: TextStyle(
                color: colorScheme == "dark" ? Colors.white : Colors.black),
          ),
          onChanged: (bool newValue) {},
        ),
      ],
    );
  }
}
