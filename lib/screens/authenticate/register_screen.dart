import 'dart:math';
import 'package:validators/validators.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

import '../../screens/wrapper.dart';
import '../../services/auth.service.dart';
import '../../services/database.service.dart';
import './login_screen.dart';

class RegisterProfileScreen extends StatefulWidget {
  static const routeName = "/register-screen";

  @override
  _RegisterProfileScreenState createState() => _RegisterProfileScreenState();
}

class _RegisterProfileScreenState extends State<RegisterProfileScreen> {
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
            gradient: RadialGradient(
              colors: [
                Colors.grey[900],
                Colors.grey[900],
                Colors.indigo[900],
              ],
              radius: 0.8,
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 0.1 * height, horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RegisterTitle(),
              RegisterForm(),
            ],
          ),
        ),
      ),
    );
  }
}

// * ==================================================
// * ==================================================

class RegisterTitle extends StatelessWidget {
  const RegisterTitle({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Flexible(
      child: Container(
        height: 0.11 * height,
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
          'Register',
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

// * ==================================================
// * ==================================================
class RegisterForm extends StatefulWidget {
  const RegisterForm({Key key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final AuthService _auth = AuthService();
  final _registerFormKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CircularProgressIndicator()
        : Form(
            key: _registerFormKey,
            child: Column(
              children: <Widget>[
                MyTextFormField(
                  hintText: "Name",
                  controller: _nameController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter a name";
                    } else {
                      return null;
                    }
                  },
                ),
                MyTextFormField(
                  hintText: "Email",
                  isEmail: true,
                  controller: _emailController,
                  validator: (value) {
                    if (value.isEmpty || !isEmail(value)) {
                      return "Please enter a valid email";
                    } else {
                      return null;
                    }
                  },
                ),
                MyTextFormField(
                  hintText: "Password",
                  isPassword: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.length < 7) {
                      return "Please enter a password with at least 7 charecters";
                    } else {
                      return null;
                    }
                  },
                ),
                MyTextFormField(
                  hintText: "Confirm Password",
                  isPassword: true,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return "Passwords don't match";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 30),
                // ! Registration button ===========================
                TextButton(
                  child: Container(
                    alignment: Alignment.center,
                    height: 40,
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
                      "Create account",
                      textScaleFactor: 1.5,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  // !     Register function ===============
                  onPressed: () async {
                    if (_registerFormKey.currentState.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      await _auth
                          .registerWithEmailAndPassword(
                              _emailController.text, _passwordController.text)
                          .catchError((err) {
                        setState(() {
                          isLoading = false;
                        });
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text("Error"),
                                  content: Text(err.toString()),
                                ));
                      }).then((user) => {
                                if (user == null)
                                  {
                                    setState(() {
                                      isLoading = false;
                                    }),
                                    AlertDialog(
                                      title: Text(
                                        "Somtehing went wrong",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    )
                                  }
                                else
                                  {
                                    DataBaseService().setUserData(
                                        user.uid,
                                        _nameController.text,
                                        _emailController.text,
                                        _passwordController.text),
                                    GlobalConfiguration()
                                        .addValue("uid", user.uid),
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (ctx) => Wrapper()),
                                    )
                                  }
                              });
                    }
                  },
                ),
                // ! ====================================
                TextButton(
                  child: Text(
                    "I alredy have an account.",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(SignIn.routeName);
                  },
                ),
              ],
            ),
          );
  }
}

// * ==================================================
// * ==================================================

class MyTextFormField extends StatelessWidget {
  final String hintText;
  final Function validator;
  final TextEditingController controller;
  final bool isPassword;
  final bool isEmail;

  MyTextFormField({
    this.hintText,
    this.validator,
    this.controller,
    this.isPassword = false,
    this.isEmail = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: TextFormField(
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        controller: controller,
        decoration: InputDecoration(
          focusColor: Colors.purple,
          hintText: hintText,
          labelText: hintText,
          alignLabelWithHint: true,
          hintStyle:
              TextStyle(color: Colors.white70, fontWeight: FontWeight.w200),
          labelStyle:
              TextStyle(color: Colors.white70, fontWeight: FontWeight.normal),
        ),
        obscureText: isPassword ? true : false,
        validator: validator,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      ),
    );
  }
}
