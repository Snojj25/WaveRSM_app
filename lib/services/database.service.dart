import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:global_configuration/global_configuration.dart';

import '../models/post.dart';
import '../models/user.dart';
import '../services/ml_vision.service.dart';

class DataBaseServce {
  // *================== TRADES ============================
  // * =====================================================

  final CollectionReference tradesCollection =
      Firestore.instance.collection("trades");

  Future<void> addTrade(Trade trade, {String uid = ""}) async {
    return await tradesCollection
        .document("userTrades")
        .collection(uid)
        .document(trade.symbol + trade.dateTime.toIso8601String())
        .setData({
      "symbol": trade.symbol,
      "tradeType": trade.tradeType,
      "lotSize": trade.lotSize,
      "entry": trade.entry,
      "exit": trade.exit,
      "dateTime": trade.dateTime,
      "profit": trade.profit
    });
  }

  List<Trade> _tradesFromSnapshot(QuerySnapshot snapshot) {
    // final String userUid = GlobalConfiguration().getString("uid");
    return snapshot.documents.map((doc) {
      //Timestamp timestamp = doc.data["date"];
      try {
        final trade = Trade(
          symbol: doc.data["symbol"],
          tradeType: doc.data["tradeType"],
          lotSize: doc.data["lotSize"] as double,
          entry: doc.data["entry"] as double,
          exit: doc.data["exit"] as double,
          dateTime: (doc.data["dateTime"] as Timestamp).toDate(),
          profit: doc.data["profit"] as double,
        );
        return trade;
      } catch (err) {
        print(err);
      }
    }).toList();
  }

  Stream<List<Trade>> get trades {
    final String uid = GlobalConfiguration().getValue("uid");
    return Firestore.instance
        .collection("trades")
        .document("userTrades")
        .collection(uid)
        .snapshots()
        .map(_tradesFromSnapshot);
  }

  // * ==========================================================

  // ? ===================== USER DATA ============================
  // ? ============================================================

  final CollectionReference usersCollection =
      Firestore.instance.collection("users");

  Future<void> setUserData(
      String uid, String name, String email, String password) async {
    return await usersCollection.document(uid).setData({
      "uid": uid,
      "name": name,
      "email": email,
      "password": password,
      "imageUrl": "",
    }).catchError((err) {
      print(err);
    });
  }

  UserData _userDataFromSnapshot(QuerySnapshot snapshot) {
    final String userUid = GlobalConfiguration().getValue("uid");
    final DocumentSnapshot doc = snapshot.documents
        .firstWhere((element) => element.data["uid"] == userUid);
    return UserData(
      uid: doc.documentID,
      name: doc.data["name"],
      email: doc.data["email"],
      password: doc.data["password"],
      imageUrl: doc.data["imageUrl"],
    );
  }

  Stream<UserData> get userData {
    return usersCollection.snapshots().map(_userDataFromSnapshot);
  }

  // ? ============================================================

  // ! ======================= POSTS ==============================
  // ! ============================================================

  final CollectionReference postsCollection =
      Firestore.instance.collection("posts");

  Future<void> addPost(
      String title, String desc, String imgUrl, DateTime dateTime) async {
    return await postsCollection
        .document(dateTime.hashCode.toRadixString(10))
        .setData({
      "id": dateTime.hashCode.toRadixString(10),
      "title": title,
      "description": desc,
      "imgUrl": imgUrl,
      "dateTime": dateTime,
    });
  }

  List<Post> _postsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      Post post;
      try {
        post = Post(
          id: doc.data["id"],
          title: doc.data["title"],
          description: doc.data["description"],
          imgUrl: doc.data["imgUrl"],
          dateTime: (doc.data["dateTime"] as Timestamp).toDate(),
          allowedUsers: doc.data["allowedUsers"] ?? [],
        );
      } catch (err) {
        print("error code: 1002");
        print(err.toString());
      }
      return post;
    }).toList();
  }

  Stream<List<Post>> get posts {
    return postsCollection.snapshots().map(_postsFromSnapshot);
  }

  Future<void> addAllowedUser(String postId, String userId) async {
    final DocumentReference docRef = postsCollection.document(postId);
    // final DocumentSnapshot snapshot = await docRef.get();
    return await docRef.updateData(
      {
        "allowedUsers": FieldValue.arrayUnion([userId]),
      },
    ).catchError((err) {
      print("error code: 1010");
      print(err);
    });
  }

  Future<void> removeAllowedUser(String postId, String userId) async {
    final DocumentReference docRef = postsCollection.document(postId);
    // final DocumentSnapshot snapshot = await docRef.get();
    return await docRef.updateData(
      {
        "allowedUsers": FieldValue.arrayRemove([userId]),
      },
    ).catchError((err) {
      print("error code: 1020");
      print(err);
    });
  }

  // ! =============================================================
}
