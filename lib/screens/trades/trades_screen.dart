import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:global_configuration/global_configuration.dart';

import './all_trades.dart';
import '../../services/ml_vision.service.dart';
import '../../services/database.service.dart';

class TradesScreen extends StatelessWidget {
  const TradesScreen({Key key}) : super(key: key);
  static const routeName = "trades-screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.red,
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: Text("info"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo[900], Colors.grey[900]],
          ),
        ),
        child: ImageLabeler(),
      ),
    );
  }
}

// ! ==========================================

class ImageLabeler extends StatefulWidget {
  const ImageLabeler({Key key}) : super(key: key);

  @override
  _ImageLabelerState createState() => _ImageLabelerState();
}

class _ImageLabelerState extends State<ImageLabeler> {
  bool isLoading = false;
  final String uid = GlobalConfiguration().getValue("uid");

  File _selectedImage;
  VisionText _visionText;
  List<List<String>> _tradesList = [];
  List<Trade> _trades = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FlatButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              _selectedImage = await getImageFile().catchError((err) {
                print("error code: 3001");
                print(err);
              });
              setState(() {
                _selectedImage = _selectedImage;
              });
              if (_selectedImage != null) {
                _visionText =
                    await getVisionText(_selectedImage).catchError((err) {
                  print("error code: 3002");
                  print(err);
                });
                _tradesList = getTradeInfo(_visionText);
                try {
                  for (var i = 0; i < _tradesList.length; i++) {
                    if (_tradesList[i].length == 3) {
                      Trade trade = makeTrade(_tradesList[i]);
                      _trades.add(trade);
                    }
                  }
                } catch (err) {
                  print("error code: 3003");
                  print(err);
                }
                setState(() {
                  _trades = _trades;
                  isLoading = false;
                });
              } else {
                setState(() {
                  isLoading = false;
                  _selectedImage = null;
                });
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              height: 50,
              width: 500,
              alignment: Alignment.center,
              child: Text(
                "Add trades",
                style: TextStyle(color: Colors.white),
                textScaleFactor: 1.3,
              ),
            ),
          ),
        ),
        isLoading == true
            ? CircularProgressIndicator()
            : _selectedImage != null && _trades != []
                ? Column(
                    children: [
                      Container(
                        height: 250,
                        child: Image.file(
                          _selectedImage,
                        ),
                      ),
                      Stack(
                        children: [
                          Container(
                            height: 250,
                            child: ListView.builder(
                              itemCount: _trades.length,
                              itemBuilder: (ctx, idx) => ListTile(
                                leading: Text(
                                  idx.toString(),
                                  textScaleFactor: 1.2,
                                  style: TextStyle(color: Colors.white),
                                ),
                                title: Text(
                                  _trades[idx].symbol,
                                  textScaleFactor: 1.2,
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  _trades[idx].entry.toString() +
                                      " => " +
                                      _trades[idx].exit.toString(),
                                  textScaleFactor: 1.2,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 15,
                            right: 15,
                            child: IconButton(
                              icon: Icon(
                                Icons.save,
                                size: 20,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                for (var i = 0; i < _trades.length; i++) {
                                  await DataBaseServce()
                                      .addTrade(_trades[i], uid: uid)
                                      .catchError((err) {
                                    print(err);
                                  });
                                }
                                setState(() {
                                  _trades = [];
                                  _selectedImage = null;
                                  isLoading = false;
                                });
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  )
                : Expanded(child: AllTrades()),
      ],
    );
  }
}
