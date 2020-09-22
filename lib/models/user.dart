class User {
  final String uid;
  final String email;

  User({this.uid, this.email});
}

class UserData {
  String uid;
  String name;
  String email;
  String password;
  String imageUrl;

  UserData({
    this.uid,
    this.name,
    this.email,
    this.password,
    this.imageUrl,
  });
}
