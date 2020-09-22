import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../services/database.service.dart';
import '../../services/ml_vision.service.dart';
import '../../shared/video_player.dart';

class NewPost extends StatefulWidget {
  NewPost({Key key}) : super(key: key);
  static const routeName = "new-post-screen";

  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  File _selectedImageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      appBar: AppBar(
        title: Text("new post"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                alignment: Alignment.center,
                child: Text(
                  "Add a new post here!",
                  textScaleFactor: 1.7,
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
      ),
    );
  }
}

// * ============================================================

class NewPostForm extends StatefulWidget {
  NewPostForm({Key key}) : super(key: key);

  @override
  _NewPostFormState createState() => _NewPostFormState();
}

final _formKey = GlobalKey<FormState>();

final _titleController = TextEditingController();
final _descController = TextEditingController();
File _selectedVideoFile;

class _NewPostFormState extends State<NewPostForm> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Form(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              validator: (val) => val.isEmpty ? "Enter a title" : null,
              controller: _titleController,
              cursorWidth: 4,
              cursorColor: Colors.blue[300],
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              decoration: inputDecoration.copyWith(
                  hintText: "enter a title", labelText: "title"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              cursorWidth: 4,
              cursorColor: Colors.blue[300],
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              decoration: inputDecoration.copyWith(
                  hintText: "enter a description", labelText: "description"),
              validator: (val) => val.isEmpty ? "Enter a description" : null,
              controller: _descController,
            ),
          ),
          _selectedVideoFile == null
              ? RaisedButton(
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
              : RaisedButton(
                  color: Colors.red,
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
          _selectedVideoFile != null
              ? Container(
                  child: CustomVideoPlayer(
                    videoPlayerController:
                        VideoPlayerController.file(_selectedVideoFile),
                  ),
                )
              : Text(""),
          RaisedButton(
            color: Colors.green,
            child: Container(
              width: width * 0.5,
              alignment: Alignment.center,
              child: Text(
                "SUBMIT",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                textScaleFactor: 1.5,
              ),
            ),
            onPressed: () {
              _submitPost(_selectedVideoFile, _titleController.text,
                      _descController.text)
                  .catchError((err) {
                print(err);
              }).then((value) => print("submitted"));
              setState(() {
                _selectedVideoFile = null;
                _titleController.clear();
                _descController.clear();
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

Future<void> _submitPost(
    File imageFile, String title, String description) async {
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

  await DataBaseServce()
      .addPost(title, description, url, dateTime)
      .catchError((err) {
    print("Error code: 2003");
    print(err);
  }).then((value) {
    print("Post added successfuly.");
  });
}
