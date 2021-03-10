import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:forex_app/screens/settings/app_settings.config.dart';

import '../../../services/database.service.dart';
import '../../../services/ml_vision.service.dart';
import '../../../shared/video_player.dart';

String colorScheme;

class VideoPost extends StatefulWidget {
  const VideoPost({Key key}) : super(key: key);

  @override
  _VideoPostState createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost> {
  File _selectedImageFile;

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
            NewPostForm(colorScheme: colorScheme),
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
  final String colorScheme;
  NewPostForm({Key key, @required this.colorScheme}) : super(key: key);

  @override
  _NewPostFormState createState() => _NewPostFormState();
}

final _formKey = GlobalKey<FormState>();

final _titleController = TextEditingController();
final _descController = TextEditingController();
final _symbolController = TextEditingController();
File _selectedVideoFile;

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
                    cursorColor: widget.colorScheme == "dark"
                        ? Colors.blue[300]
                        : Colors.black,
                    style: TextStyle(
                      color: widget.colorScheme == "dark"
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: inputDecoration.copyWith(
                        hintText: "enter a title", labelText: "title"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    cursorWidth: 4,
                    cursorColor: widget.colorScheme == "dark"
                        ? Colors.blue[300]
                        : Colors.black,
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
                    cursorColor: widget.colorScheme == "dark"
                        ? Colors.blue[300]
                        : Colors.black,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    decoration: inputDecoration.copyWith(
                        hintText: "enter a symbol", labelText: "symbol"),
                    validator: (val) => val.isEmpty ? "Enter a symbol" : null,
                    controller: _symbolController,
                  ),
                ),
                // !  SELECT FILE BUTTON =======================
                _selectedVideoFile == null
                    ? ElevatedButton(
                        child: Text("Add a new post"),
                        onPressed: () async {
                          try {
                            _selectedVideoFile = await getImageFile();
                            setState(() {
                              _selectedVideoFile = _selectedVideoFile;
                            });
                          } catch (err) {
                            print("error code: 2006");
                            print(err);
                          }
                        })
                    : ElevatedButton(
                        // color: Colors.red,
                        onPressed: () {
                          setState(() {
                            _selectedVideoFile = null;
                          });
                        },
                        child: Text(
                          "cancel",
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textScaleFactor: 1.3,
                        ),
                      ),

                // * VIDEO FILE PREVIEW =============================
                _selectedVideoFile != null
                    ? Container(
                        child: CustomVideoPlayer(),
                      )
                    : Text(""),
                ElevatedButton(
                  // color: Colors.green,
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
                    setState(() {
                      _isLoading = true;
                    });
                    _submitPost(_selectedVideoFile, _titleController.text,
                            _descController.text, _symbolController.text, false)
                        .catchError((err) {
                      print("error code: 'submit video post");
                      print(err);
                    }).then((value) {
                      print("submitted");
                    });
                    setState(() {
                      _selectedVideoFile = null;
                      _titleController.clear();
                      _descController.clear();
                      _symbolController.clear();
                      _isLoading = false;
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
  labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
  hintStyle: TextStyle(color: Colors.black87, fontWeight: FontWeight.normal),
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
