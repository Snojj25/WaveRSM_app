import 'package:flutter/material.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                height: 0.90 * height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/stock_photos/random1.jpeg"),
                  ),
                ),
              ),
              Container(),
              Container()
            ],
          ),
        ),
      ),
    );
  }
}
