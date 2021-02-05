import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:file_picker/file_picker.dart';

import 'package:forex_app/models/trade.model.dart';

Future<File> getImageFile() async {
  final File imageFile = await FilePicker.getFile();
  return imageFile;
}

Future<VisionText> getVisionText(selectedImage) async {
  final textRecognizer = FirebaseVision.instance.textRecognizer();
  final selectedImageFile = FirebaseVisionImage.fromFile(selectedImage);
  return await textRecognizer.processImage(selectedImageFile);
}
/////////////////////////////////////////////////////////////

List<List<String>> getTradeInfo(VisionText visionText) {
  List<List<String>> tradeInfoList = [];
  final List<TextBlock> blocks = visionText.blocks.sublist(3);
  int counter = 0;
  bool isStarted = false;
  print("===================");
  for (var i = 0; i < blocks.length; i++) {
    // if (blocks[i].text.contains("buy") || blocks[i].text.contains("sell")) {
    if (blocks[i].text.contains(",")) {
      if (isStarted) {
        counter++;
      }
      tradeInfoList.add([]);
      isStarted = true;
    }
    if (isStarted) {
      tradeInfoList[counter].add(blocks[i].text);
    }
  }
  return tradeInfoList;
}

/////////////////////////////////////////////////////////////

Trade makeTrade(List<String> tradeInfo) {
  List<String> _first = tradeInfo[0].split(" ");
  List<String> _second = tradeInfo[1].split(" ");
  List<String> _third = tradeInfo[2].split(" ");
  String _tradeType;
  dynamic _lotSize;
  double _entry;
  double _exit;

  // ========================================
  // THE SYMBOL
  // ========================================
  String _symbol = _first[0].substring(0, _first[0].length - 1);

  // ========================================
  // EXTRACTING THE TRADE TYPE, LOT SIZE, _entry AND _exit PRICE
  // ========================================

  // If the trade is a Buy/Sell Limit
  if (_first.contains("limit")) {
    // If it's a buy or a sell
    if (_first[2].startsWith("b")) {
      _tradeType = "Buy Limit";
    } else {
      _tradeType = "Sell Limit";
    }
    _lotSize = double.parse(_first[3]);
    // If the _entry/_exit prices are stuck together
    if (_first.length == 7) {
      _entry = double.parse(_first[5]);
      _exit = double.parse(_first[6]);
    } else {
      _entry = double.parse(_first[5].substring(0, _first[5].length ~/ 2));
      _exit = double.parse(_first[5].substring(_first[5].length ~/ 2));
    }
    // If the trade is a Buy/Sell Stop
  } else if (_first.contains("stop")) {
    // If it's a buy or a sell
    if (_first[2].startsWith("b")) {
      _tradeType = "Buy Stop";
    } else {
      _tradeType = "Sell Stop";
    }
    _lotSize = double.parse(_first[3]);
    // If the _entry/_exit prices are stuck together
    if (_first.length == 7) {
      _entry = double.parse(_first[5]);
      _exit = double.parse(_first[6]);
    } else {
      _entry = double.parse(_first[5].substring(0, _first[5].length ~/ 2));
      _exit = double.parse(_first[5].substring(_first[5].length ~/ 2));
    }
    // If the trade is normal market execution
  } else {
    // If it's a buy or a sell
    if (_first[1].startsWith("b")) {
      _tradeType = "Buy";
    } else {
      _tradeType = "Sell";
    }
    _lotSize = double.parse(_first[2].substring(0, 4));
    // If the _entry/_exit prices are stuck together
    if (_first.length == 4) {
      _entry = double.parse(_first[2].substring(4));
      _exit = double.parse(_first[3]);
    } else {
      _entry = double.parse(
        _first[2].substring(4, 12),
      );
      _exit = double.parse(
        _first[2].substring(12),
      );
    }
  }
  // ========================================

  // DATE TIME

  final formatedDate = _second[0].replaceAll(".", "-");
  final DateTime _dateTime = DateTime.parse(formatedDate);

  // PROFIT
  final double _profit = double.parse(_third[0]);

  // ========================================
  // MAKING THE TRADE
  // ========================================
  return new Trade(
    symbol: _symbol,
    tradeType: _tradeType,
    lotSize: _lotSize,
    entry: _entry,
    exit: _exit,
    dateTime: _dateTime,
    profit: _profit,
  );
}

/////////////////////////////////////////////////////////////
