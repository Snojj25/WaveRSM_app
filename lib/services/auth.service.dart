import 'package:firebase_auth/firebase_auth.dart';
import 'package:global_configuration/global_configuration.dart';

import '../models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid, email: user.email) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  // ? =====================================================================
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      GlobalConfiguration().addValue("uid", user.uid);
      return _userFromFirebaseUser(user);
    } catch (err) {
      print("Error logging in: " + err.toString());
      throw err;
    }
  }

  Future<User> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      GlobalConfiguration().addValue("uid", user.uid);
      return _userFromFirebaseUser(user);
    } catch (err) {
      print("Error registering: " + err.toString());
      throw err;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (err) {
      print("Error signing out: " + err.toString());
      return null;
    }
  }

  // ! =====================================================-

  bool checkAuthorization(UserData user, List<Roles> roles) {
    if (user == null) return false;
    for (var role in roles) {
      if (user.roles.contains(role)) {
        return true;
      }
    }
    return false;
  }

  bool allowSubscriber(UserData user) {
    const allowed = [Roles.subscriber, Roles.editor, Roles.admin];
    return this.checkAuthorization(user, allowed);
  }

  bool allowEditor(UserData user) {
    const allowed = [Roles.editor, Roles.admin];
    return this.checkAuthorization(user, allowed);
  }

  bool allowAdmin(UserData user) {
    const allowed = [Roles.admin];
    return this.checkAuthorization(user, allowed);
  }
}
