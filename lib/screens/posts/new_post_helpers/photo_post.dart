import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:forex_app/screens/authenticate/login_screen.dart';
import 'package:forex_app/screens/settings/app_settings.config.dart';

import '../../../services/database.service.dart';
import '../../../services/ml_vision.service.dart';

class PhotoPost extends StatefulWidget {
  const PhotoPost({Key key}) : super(key: key);

  @override
  _PhotoPostState createState() => _PhotoPostState();
}

class _PhotoPostState extends State<PhotoPost> {
  File _selectedImageFile;
  String colorScheme;

  @override
  void initState() {
    super.initState();
    getColorScheme().then((value) {
      setState(() {
        colorScheme = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 15),
              padding: const EdgeInsets.all(15),
              alignment: Alignment.center,
              child: Text(
                "Add a photo post here!",
                textScaleFactor: 1.7,
                style: TextStyle(
                  color: colorScheme == "dark" ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            NewPostForm(),
            _selectedImageFile != null
                ? Container(
                    height: 100,
                    child: Image.file(_selectedImageFile),
                  )
                : Text(""),
            // RaisedButton(onPressed: () async {
            //   _submitProfilePhoto(context, _selectedImageFile);
            // })
          ],
        ),
      ),
    );
  }
}

class NewPostForm extends StatefulWidget {
  NewPostForm({Key key}) : super(key: key);

  @override
  _NewPostFormState createState() => _NewPostFormState();
}

final _formKey = GlobalKey<FormState>();

final _titleController = TextEditingController();
final _descController = TextEditingController();
final _symbolController = TextEditingController();
File _selectedImageFile;

class _NewPostFormState extends State<NewPostForm> {
  @override
  Widget build(BuildContext context) {
    bool _isLoading = false;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return _isLoading
        ? Center(
            child: Container(
              margin: EdgeInsets.only(top: 0.35 * height),
              child: CircularProgressIndicator(
                backgroundColor: Colors.black38,
              ),
            ),
          )
        : Form(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (val) => val.isEmpty ? "Enter a title" : null,
                    controller: _titleController,
                    cursorWidth: 4,
                    cursorColor: Colors.blue[300],
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    decoration: inputDecoration.copyWith(
                        hintText: "enter a title", labelText: "title"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    cursorWidth: 4,
                    cursorColor: Colors.blue[300],
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    decoration: inputDecoration.copyWith(
                        hintText: "enter a description",
                        labelText: "description"),
                    validator: (val) =>
                        val.isEmpty ? "Enter a description" : null,
                    controller: _descController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    cursorWidth: 4,
                    cursorColor: Colors.blue[300],
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    decoration: inputDecoration.copyWith(
                        hintText: "enter a symbol", labelText: "symbol"),
                    validator: (val) => val.isEmpty ? "Enter a symbol" : null,
                    controller: _symbolController,
                  ),
                ),
                _selectedImageFile == null
                    ? RaisedButton(
                        child: Text("Add a new post"),
                        onPressed: () async {
                          try {
                            _selectedImageFile = await getImageFile();
                            setState(() {
                              _selectedImageFile = _selectedImageFile;
                            });
                          } catch (err) {
                            print("error code: 2006");
                            print(err);
                          }
                        })
                    : RaisedButton(
                        color: Colors.red,
                        onPressed: () {
                          setState(() {
                            _selectedImageFile = null;
                          });
                        },
                        child: Text(
                          "cancel",
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textScaleFactor: 1.3,
                        ),
                      ),
                _selectedImageFile != null
                    ? Container(child: Image.file(_selectedImageFile))
                    : Text(""),
                RaisedButton(
                  color: Colors.green,
                  child: Container(
                    width: width * 0.5,
                    alignment: Alignment.center,
                    child: Text(
                      "SUBMIT",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      textScaleFactor: 1.5,
                    ),
                  ),
                  onPressed: () {
                    // for (var i = 0; i < 25; i++) {
                    //   var title;
                    //   var desc;
                    //   var imgUrl;
                    //   var dateTime;
                    //   if (i % 3 == 0) {
                    //     title = "EURUSD Long";
                    //     desc =
                    //         "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam eu diam ac dolor auctor aliquam. Integer vitae ultricies dolor. In at elementum arcu. Praesent sed ex posuere, pulvinar metus in, consequat metus";
                    //     imgUrl =
                    //         "https://www.waveanalysis.net/images/ideas/idea-mj1HDiqy_GBPJPY_Long.png";
                    //     dateTime = DateTime.now();
                    //   }
                    //   if (i % 4 == 0) {
                    //     title = "GBPNZD Short";
                    //     desc =
                    //         "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam eu diam ac dolor auctor aliquam. Integer vitae ultricies dolor. In at elementum arcu. Praesent sed ex posuere, pulvinar metus in, consequat metus";
                    //     imgUrl =
                    //         "https://www.waveanalysis.net/images/ideas/idea-mj1HDiqy_GBPJPY_Long.png";
                    //     dateTime = DateTime.now();
                    //   } else {
                    //     title = "AUDCAD Long";
                    //     desc =
                    //         "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam eu diam ac dolor auctor aliquam. Integer vitae ultricies dolor. In at elementum arcu. Praesent sed ex posuere, pulvinar metus in, consequat metus";
                    //     imgUrl =
                    //         "https://www.waveanalysis.net/images/ideas/idea-mj1HDiqy_GBPJPY_Long.png";
                    //     dateTime = DateTime.now();
                    //   }
                    //   DataBaseServce().addPost(title, desc, imgUrl, dateTime);
                    // }
                    setState(() {
                      _isLoading = true;
                    });
                    _submitPost(_selectedImageFile, _titleController.text,
                            _descController.text, _symbolController.text, true)
                        .catchError((err) {
                      print(err);
                    }).then((value) => print("submitted"));
                    setState(() {
                      _selectedImageFile = null;
                      _titleController.clear();
                      _descController.clear();
                      _symbolController.clear();
                      isLoading = false;
                    });
                  },
                ),
              ],
            ),
            key: _formKey,
          );
  }
}

// * ================================================================
// ?                HELPERS

final inputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.white70, fontWeight: FontWeight.normal),
  hintStyle: TextStyle(color: Colors.white70, fontWeight: FontWeight.normal),
  fillColor: Color.fromRGBO(1, 2, 3, 0),
);

Future<void> _submitPost(File imageFile, String title, String description,
    String symbol, bool isPhoto) async {
  print("step 1");

  final StorageReference ref =
      FirebaseStorage.instance.ref().child(imageFile.path);

  print("step 2");

  await ref.putFile(imageFile).onComplete.catchError((err) {
    print("error code: 2001");
    print(err);
  });

  print("step 3");

  final String url = await ref.getDownloadURL().catchError((err) {
    print("error code: 2002");
    print(err);
  });

  print("step 4");

  final DateTime dateTime = DateTime.now();

  await DataBaseService()
      .addPost(title, description, url, dateTime, symbol, isPhoto)
      .catchError((err) {
    print("Error code: 2003");
    print(err);
  }).then((value) {
    print("Post added successfuly.");
  });
}
