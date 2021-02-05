import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../screens/wrapper.dart';

import '../../services/auth.service.dart';
import './register_screen.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key key}) : super(key: key);
  static const routeName = "/sign-in";

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            gradient: RadialGradient(colors: [
              Colors.indigo[800],
              Colors.indigo[900],
              Colors.grey[900]
            ], radius: 0.7),
          ),
          padding: EdgeInsets.symmetric(vertical: 0.1 * height, horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SignupTitle(),
              SignInForm(),
            ],
          ),
        ),
      ),
    );
  }
}

// ?  =======================================================
// ?  =======================================================
class SignupTitle extends StatelessWidget {
  const SignupTitle({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Flexible(
      child: Container(
        height: 0.1 * height,
        margin: EdgeInsets.only(bottom: 0.03 * height),
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.11 * height),
        transform: Matrix4.rotationZ(8 * pi / 180)..translate(-10.0),
        // ..translate(-10.0),
        decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.indigo[900], blurRadius: 15)],
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
                colors: [Colors.indigo[900], Colors.grey[900]],
                begin: Alignment.bottomLeft)),
        child: Text(
          'Login',
          softWrap: false,
          overflow: TextOverflow.visible,
          style: TextStyle(
            color: Theme.of(context).accentTextTheme.headline6.color,
            fontSize: 50,
            fontFamily: 'Anton',
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// ?  =======================================================
// ?  =======================================================
class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

final AuthService _auth = AuthService();
GlobalKey<FormState> _formKey;
bool isLoading;

//Text Field State
String email;
String password;
String error;

class _SignInFormState extends State<SignInForm> {
  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    isLoading = false;
    email = "";
    password = "";
    error = "";
    super.initState();
  }

  @override
  void dispose() {
    if (_formKey.currentState != null) {
      _formKey.currentState.dispose();
    }
    isLoading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return isLoading
        ? CircularProgressIndicator()
        : Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 0.015 * height),
                TextFormField(
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                  strutStyle: StrutStyle(fontWeight: FontWeight.bold),
                  decoration: inputDecoration.copyWith(
                      labelText: "email", hintText: "email"),
                  validator: (val) => val.isEmpty ? "Enter an email" : null,
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                ),
                SizedBox(height: 0.03 * height),
                TextFormField(
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                  strutStyle: StrutStyle(fontWeight: FontWeight.bold),
                  decoration: inputDecoration.copyWith(
                      labelText: "password", hintText: "password"),
                  validator: (val) => val.length < 6
                      ? "Password must be atleast 6 characters long"
                      : null,
                  obscureText: true,
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                ),
                SizedBox(height: 0.03 * height),

                //* SIGN IN ===========================
                FlatButton(
                  child: Container(
                    alignment: Alignment.center,
                    height: 0.06 * height,
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(blurRadius: 2, color: Colors.white30)
                      ],
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[900],
                    ),
                    child: Text(
                      "Sign in",
                      textScaleFactor: 1.5,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  // !     Login function ===============
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      await _auth
                          .signInWithEmailAndPassword(email, password)
                          .catchError((err) {
                        showDialog(
                            context: context,
                            child: AlertDialog(
                              title: Text("Error"),
                              content: Text(err.toString()),
                            ));
                        setState(() {
                          isLoading = false;
                        });
                      }).then((user) => {
                                if (user == null)
                                  {
                                    setState(() {
                                      isLoading = false;
                                    })
                                  }
                                else
                                  {
                                    setState(() {
                                      isLoading = false;
                                    }),
                                    Navigator.of(context)
                                        .pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) => Wrapper(),
                                          ),
                                        )
                                        .catchError(
                                          (err) => {print(err)},
                                        )
                                        .then(
                                          (_) => {print("navigated to ...")},
                                        ),
                                  }
                              });
                    }
                  },
                ),
                // * ================================
                SizedBox(height: 0.06 * height),
                ButtonBar(
                  buttonMinWidth: width,
                  children: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed(
                              RegisterProfileScreen.routeName);
                        },
                        child: Text(
                          "Create account",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    FlatButton(
                        onPressed: () {},
                        child: Text(
                          "Forgot password",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                )
              ],
            ),
          );
  }
}

// * =======================================================================
// * =======================================================================

const inputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.white70, fontWeight: FontWeight.normal),
  hintStyle: TextStyle(color: Colors.white70, fontWeight: FontWeight.w200),
  fillColor: Color.fromRGBO(0, 0, 0, 0),
);
