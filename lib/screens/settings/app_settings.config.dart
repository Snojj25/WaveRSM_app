import 'package:shared_preferences/shared_preferences.dart';

// !  ================  COLOR SCHEME ================
// *SET Color Scheme
Future<bool> setColorScheme(String colorScheme) async {
  final prefs = await SharedPreferences.getInstance().catchError((err) {
    print("error code: SharedPreferences failed to get Instance");
    print(err);
  });

  return prefs.setString("colorScheme", colorScheme).catchError((err) {
    print("error code: Shared preferences failed to set colorScheme");
    print(err);
  });
}

//*GET Color Scheme
Future<String> getColorScheme() async {
  final prefs = await SharedPreferences.getInstance().catchError((err) {
    print("error code: SharedPreferences failed to get Instance");
    print(err);
  });

  return prefs.getString("colorScheme");
}
