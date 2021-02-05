import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:global_configuration/global_configuration.dart';

import '../models/trade.model.dart';
import '../models/post.dart';
import '../models/user.dart';

class DataBaseService {
  // *================== TRADES ============================
  // * =====================================================

  final CollectionReference tradesCollection =
      Firestore.instance.collection("trades");

  Future<void> addTrade(Trade trade, String uid) async {
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
        })
        .then(
          (_) => _addTradeStats(uid, trade),
        )
        .catchError((err) => {
              print("error: " + err.toString()),
            });
  }

  // * TRADE STATS ===================================

// ADD TRADE STATS ===================================
  Future<void> _addTradeStats(String uid, Trade trade) {
    final bool _isPositive = trade.profit >= 0;
    final String _posOrNegTrades =
        _isPositive ? "positive-trades" : "negative-trades";
    final String _posOrNegTotal =
        _isPositive ? "positive-total" : "negative-total";
    // =======================================
    return tradesCollection
        .document("userTradeStats")
        .collection(uid)
        .document("stats")
        .updateData({
      "profit": FieldValue.increment(trade.profit),
      "total-trades": FieldValue.increment(1),
      _posOrNegTrades: FieldValue.increment(1),
      _posOrNegTotal: FieldValue.increment(trade.profit),
      trade.symbol: FieldValue.increment(1),
      (trade.symbol + "-profit"): FieldValue.increment(trade.profit)
    });
  }
  //====================================================

  // =============================================================

  Future<TradeStats> getUserTradeStats(String uid) async {
    return await tradesCollection
        .document("userTradeStats")
        .collection(uid)
        .document("stats")
        .get()
        .then(
      (DocumentSnapshot snapshot) {
        return _tradeStatsFromSnapshot(snapshot);
      },
    ).catchError((err) {
      print("error in get user trades: " + err.toString());
    });
  }

//  =========================================================

  Stream<List<Trade>> get trades {
    final String uid = GlobalConfiguration().getValue("uid");
    return Firestore.instance
        .collection("trades")
        .document("userTrades")
        .collection(uid)
        .snapshots()
        .map(_tradesFromSnapshot);
  }

  List<Trade> _tradesFromSnapshot(QuerySnapshot snapshot) {
    // final String userUid = GlobalConfiguration().getString("uid");
    return snapshot.documents.map((doc) {
      //Timestamp timestamp = doc.data["date"];
      try {
        final trade = Trade(
          symbol: doc.data["symbol"],
          tradeType: doc.data["tradeType"],
          lotSize:
              double.parse((doc.data["lotSize"] as double).toStringAsFixed(2)),
          entry: double.parse((doc.data["entry"] as double).toStringAsFixed(5)),
          exit: double.parse((doc.data["exit"] as double).toStringAsFixed(5)),
          dateTime: (doc.data["dateTime"] as Timestamp).toDate(),
          profit:
              double.parse((doc.data["profit"] as double).toStringAsFixed(2)),
        );
        return trade;
      } catch (err) {
        print(err);
      }
    }).toList();
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
    }).then(
      (_) => tradesCollection
          .document("userTradeStats")
          .collection(uid)
          .document("stats")
          .setData(initTradeStats),
    );
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

  Future<void> addPost(String title, String desc, String imgUrl,
      DateTime dateTime, String symbol, bool isPhoto) async {
    final collection = isPhoto
        ? postsCollection.document("photos").collection("posts")
        : postsCollection.document("videos").collection("posts");
    return await collection
        .document(dateTime.hashCode.toRadixString(10))
        .setData({
      "id": dateTime.hashCode.toRadixString(10),
      "title": title,
      "description": desc,
      "imgUrl": imgUrl,
      "dateTime": dateTime,
      "symbol": symbol,
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
          symbol: doc.data["symbol"],
        );
      } catch (err) {
        print("error code: 1002");
        print(err.toString());
      }
      return post;
    }).toList();
  }

  Stream<List<Post>> get videoPosts {
    return postsCollection
        .document("videos")
        .collection("posts")
        .orderBy("dateTime", descending: true)
        .snapshots()
        .map(_postsFromSnapshot);
  }

  Stream<List<Post>> get photoPosts {
    return postsCollection
        .document("photos")
        .collection("posts")
        .orderBy("dateTime", descending: true)
        .snapshots()
        .map(_postsFromSnapshot);
  }

  // Future<void> addAllowedUser(String postId, String userId) async {
  //   final DocumentReference docRef = postsCollection.document(postId);
  //   // final DocumentSnapshot snapshot = await docRef.get();
  //   return await docRef.updateData(
  //     {
  //       "allowedUsers": FieldValue.arrayUnion([userId]),
  //     },
  //   ).catchError((err) {
  //     print("error code: 1010");
  //     print(err);
  //   });
  // }

  // Future<void> removeAllowedUser(String postId, String userId) async {
  //   final DocumentReference docRef = postsCollection.document(postId);
  //   // final DocumentSnapshot snapshot = await docRef.get();
  //   return await docRef.updateData(
  //     {
  //       "allowedUsers": FieldValue.arrayRemove([userId]),
  //     },
  //   ).catchError((err) {
  //     print("error code: 1020");
  //     print(err);
  //   });
  // }

  // ! =============================================================
}

Map<String, num> initTradeStats = {
  // * GENERAL
  'profit': 0,
  'total-trades': 0,
  'positive-trades': 0,
  'negative-trades': 0,
  'positive-total': 0,
  'negative-total': 0,
  // * SYMBOLS
};

TradeStats _tradeStatsFromSnapshot(DocumentSnapshot snapshot) {
  double profit;
  int totalTrades;
  int positiveTrades;
  int negativeTrades;
  double positiveTotal;
  double negativeTotal;
  snapshot.data.forEach((key, value) {
    switch (key) {
      case "profit":
        profit = value;
        break;
      case "total-trades":
        totalTrades = value;
        break;
      case "positive-trades":
        positiveTrades = value;
        break;
      case "negative-trades":
        negativeTrades = value;
        break;
      case "positive-total":
        positiveTotal = value;
        break;
      case "negative-total":
        negativeTotal = value;
        break;
    }
  });

  final TradeStats tradeStats = new TradeStats(
    profit: double.parse(profit.toStringAsFixed(2)),
    totalTrades: totalTrades,
    positiveTrades: positiveTrades,
    negativeTrades: negativeTrades,
    positiveTotal: double.parse(positiveTotal.toStringAsFixed(2)),
    negativeTotal: double.parse(negativeTotal.toStringAsFixed(2)),
  );
  return tradeStats;
}

//
//
