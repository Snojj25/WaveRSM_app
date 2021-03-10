import 'package:flutter/material.dart';

showErrorDialog(BuildContext context, String error, String colorScheme) {
  showGeneralDialog(
    transitionBuilder: (context, a1, a2, widget) {
      return Transform.scale(
        scale: a1.value,
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme == "dark" ? Colors.grey : Colors.grey[900],
              border: Border.all(color: Colors.red[700], width: 3),
              borderRadius: BorderRadius.circular(25),
            ),
            height: 200,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "An error occured!",
                    style: TextStyle(
                        color: Colors.red[500], fontWeight: FontWeight.w800),
                    textScaleFactor: 1.5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    error,
                    style: TextStyle(
                      color:
                          colorScheme == "dark" ? Colors.black : Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("OK")),
              ],
            ),
          ),
        ),
      );
    },
    transitionDuration: Duration(milliseconds: 400),
    barrierDismissible: true,
    barrierLabel: '',
    context: context,
    pageBuilder: (context, animation1, animation2) {
      return null;
    },
  );
}
