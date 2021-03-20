import 'package:flutter/material.dart';

class EditActive extends StatefulWidget {
  EditActive({Key key}) : super(key: key);

  @override
  _EditActiveState createState() => _EditActiveState();
}

class _EditActiveState extends State<EditActive> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("edt active posts")),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [Colors.indigo[900], Colors.grey[900]],
        )),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [Colors.grey[700], Colors.grey[700]],
                ),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      "Title",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textScaleFactor: 1.3,
                    ),
                  ),
                  Container(
                    child: Image.asset("assets/stock_photos/stock_image1.jpg"),
                  ),
                  ListTile(
                    title: Text(
                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it ",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
