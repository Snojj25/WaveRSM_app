import 'package:flutter/material.dart';
import 'package:eventify/eventify.dart';
import 'package:flutter/services.dart';
import 'package:forex_app/services/database.service.dart';
import 'package:forex_app/shared/errors.dart';
import 'package:provider/provider.dart';

import 'package:forex_app/models/user.dart';
import '../../../../models/trade.model.dart';

// ! TRADE TEXT ROW ==================================================
// ! =================================================================
//
class TradeTextRow extends StatelessWidget {
  final String text1;
  final String text2;
  final profit;
  const TradeTextRow(
      {Key key, @required this.text1, @required this.text2, this.profit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text1,
              style: profit == null
                  ? TextStyle(color: Colors.white)
                  : TextStyle(color: profit >= 0 ? Colors.green : Colors.red),
              textScaleFactor: 1.3,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                text2,
                style: profit == null
                    ? TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue)
                    : TextStyle(
                        color: profit >= 0 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue),
                textScaleFactor: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ! DIALOG TITLE ROW ================================================
// ! =================================================================
class DialogTitleRow extends StatelessWidget {
  final Trade trade;
  final EventEmitter emitter;
  final AnimationController controller;
  const DialogTitleRow({
    Key key,
    @required this.trade,
    @required this.emitter,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25.0, bottom: 15),
              child: Text(
                trade.symbol,
                style: TextStyle(
                  color: trade.profit > 0 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                textScaleFactor: 1.4,
              ),
            ),
          ],
        ),
        Positioned(
          top: 10,
          right: 20,
          child: IconButton(
            icon: Icon(Icons.edit, color: Colors.yellow, size: 30),
            onPressed: () {
              emitter.emit("test", null, true);
              controller.forward();

              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}

// ! EDIT TRADE ROW ==================================================
// ! =================================================================
class EditTradeRow extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final String initialValue;
  final bool isNumeric;
  final String colorScheme;
  const EditTradeRow({
    Key key,
    @required this.text,
    @required this.controller,
    @required this.initialValue,
    @required this.isNumeric,
    @required this.colorScheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.text = initialValue;
    return Row(
      children: [
        SizedBox(width: 10),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            width: 100,
            child: Text(
              text,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
              textScaleFactor: 1.3,
            ),
          ),
        ),
        SizedBox(width: 30),
        Expanded(
            child: TextFormField(
          cursorColor: colorScheme == "dark" ? Colors.white : Colors.grey[300],
          style: TextStyle(
              color: colorScheme == "dark" ? Colors.black : Colors.white),
          decoration: _inputDecoration.copyWith(
              fillColor:
                  colorScheme == "dark" ? Colors.grey : Colors.grey[900]),
          textAlign: TextAlign.center,
          controller: controller,
          keyboardType: isNumeric
              ? TextInputType.numberWithOptions(decimal: true, signed: true)
              : TextInputType.text,
        )),
        SizedBox(width: 20),
      ],
    );
  }
}

final _inputDecoration = InputDecoration(
  border: UnderlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide(color: Colors.white, width: 2),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide(color: Colors.white, width: 2),
  ),
  filled: true,
);

// ! EDIT TRADE - CANCEL/SAVE BUTTONS ===================================
// ! ====================================================================

class CancelSaveEdtiTradeButton extends StatelessWidget {
  final List<TextEditingController> controlers;
  final EventEmitter emitter;
  final Trade trade;
  final AnimationController animationController;
  const CancelSaveEdtiTradeButton({
    Key key,
    @required this.controlers,
    @required this.emitter,
    @required this.trade,
    @required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserData userData = Provider.of<UserData>(context, listen: false);
    final _symbolController = controlers[0];
    final _profitController = controlers[1];
    final _tradeTypeController = controlers[2];
    final _entryController = controlers[3];
    final _exitController = controlers[4];
    final _lotSizeController = controlers[5];

    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: [
        // * CANCEL BUTTON =================================
        TextButton(
          child: Text(
            "CANCEL",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          style: ButtonStyle(
            backgroundColor:
                MaterialStateColor.resolveWith((states) => Colors.red),
            fixedSize:
                MaterialStateProperty.resolveWith((states) => Size(100, 30)),
            // elevation: MaterialStateProperty.resolveWith((states) => 0),
          ),
          onPressed: () {
            emitter.emit("test", null, false);
            Future.delayed(Duration(milliseconds: 100), () {
              animationController.reverse();
            });
          },
        ),
        // * ===============================================
        // * SAVE BUTTON ===================================
        TextButton(
          child: Text(
            "SAVE",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateColor.resolveWith(
                (states) => Colors.greenAccent[400]),
            fixedSize:
                MaterialStateProperty.resolveWith((states) => Size(100, 30)),
            // elevation: MaterialStateProperty.resolveWith((states) => 0),
          ),
          onPressed: () async {
            Map<String, dynamic> data = {
              "symbol": _symbolController.text,
              "profit": double.parse(_profitController.text),
              "tradeType": _tradeTypeController.text,
              "entry": double.parse(_entryController.text),
              "exit": double.parse(_exitController.text),
              "lotSize": double.parse(_lotSizeController.text),
            };
            await DataBaseService()
                .editTrade(trade, userData.uid, data)
                .catchError((err) {
              showErrorDialog(context, err, "dark");
            });
            emitter.emit("test", null, false);
            Future.delayed(Duration(milliseconds: 100), () {
              animationController.reverse();
            });
          },
        )
        // * ===============================================
      ],
    );
  }
}
