import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:forex_app/screens/authenticate/login_screen.dart';
// import 'package:forex_app/screens/posts/new_post_helpers/video_post.dart';
import 'package:forex_app/screens/settings/app_settings.config.dart';
import 'package:forex_app/shared/errors.dart';

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

TextEditingController _titleController;
TextEditingController _descController;
TextEditingController _symbolController;
File _selectedImageFile;

class _NewPostFormState extends State<NewPostForm> {
  @override
  void initState() {
    _titleController = TextEditingController();
    _descController = TextEditingController();
    _symbolController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _symbolController.dispose();
    super.dispose();
  }

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
                    decoration: InputDecoration(
                      hintText: "Enter a title",
                      labelText: "Title",
                      labelStyle: TextStyle(
                          color: widget.colorScheme == "dark"
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w300),
                      hintStyle: TextStyle(
                          color: widget.colorScheme == "dark"
                              ? Colors.white
                              : Colors.black87,
                          fontWeight: FontWeight.w300),
                      fillColor: Color.fromRGBO(1, 2, 3, 0),
                    ),
                    validator: (val) => val.isEmpty ? "Enter a title" : null,
                    controller: _titleController,
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
                        color: widget.colorScheme == "dark"
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: "Enter a description",
                      labelText: "Description",
                      labelStyle: TextStyle(
                          color: widget.colorScheme == "dark"
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w300),
                      hintStyle: TextStyle(
                          color: widget.colorScheme == "dark"
                              ? Colors.white
                              : Colors.black87,
                          fontWeight: FontWeight.w300),
                      fillColor: Color.fromRGBO(1, 2, 3, 0),
                    ),
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
                        color: widget.colorScheme == "dark"
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: "Enter a Symbol",
                      labelText: "Symbol",
                      labelStyle: TextStyle(
                          color: widget.colorScheme == "dark"
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w300),
                      hintStyle: TextStyle(
                          color: widget.colorScheme == "dark"
                              ? Colors.white
                              : Colors.black87,
                          fontWeight: FontWeight.w300),
                      fillColor: Color.fromRGBO(1, 2, 3, 0),
                    ),
                    validator: (val) => val.isEmpty ? "Enter a symbol" : null,
                    controller: _symbolController,
                  ),
                ),
                _selectedImageFile == null
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                              child: Text(
                                "Add a new post",
                                textScaleFactor: 1.4,
                              ),
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
                              }),
                        ),
                      )
                    : TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedImageFile = null;
                          });
                        },
                        child: Container(
                          color: Colors.red,
                          child: Text(
                            "cancel",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textScaleFactor: 1.3,
                          ),
                        ),
                      ),
                _selectedImageFile != null
                    ? Container(child: Image.file(_selectedImageFile))
                    : Text(""),
                TextButton(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: width * 0.5,
                    alignment: Alignment.center,
                    child: Text(
                      "SUBMIT",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      textScaleFactor: 1.5,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                    });
                    _submitPost(
                      _selectedImageFile,
                      _titleController.text,
                      _descController.text,
                      _symbolController.text,
                      true,
                      context,
                      widget.colorScheme,
                    ).catchError((err) {
                      showErrorDialog(
                          context, err.toString(), widget.colorScheme);
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

Future<void> _submitPost(
    File imageFile,
    String title,
    String description,
    String symbol,
    bool isPhoto,
    BuildContext context,
    String colorScheme) async {
  final StorageReference ref =
      FirebaseStorage.instance.ref().child(imageFile.path);

  await ref.putFile(imageFile).onComplete.catchError((err) {
    showErrorDialog(context, err.toString(), colorScheme);
  });

  final String url = await ref.getDownloadURL().catchError((err) {
    showErrorDialog(context, err.toString(), colorScheme);
  });

  final DateTime dateTime = DateTime.now();

  await DataBaseService()
      .addPost(title, description, url, dateTime, symbol, isPhoto)
      .catchError((err) {
    showErrorDialog(context, err.toString(), colorScheme);
  }).then((value) {
    print("Post added successfuly.");
  });
}
