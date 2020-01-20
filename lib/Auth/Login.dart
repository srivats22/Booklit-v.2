import 'package:booklit/Auth/ForgotPassword.dart';
import 'package:booklit/Auth/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:booklit/Navigation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/loginbackdrop.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
              child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('BookLit',
                      style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                              color: Color.fromRGBO(255, 204, 0, 1),
                              fontSize: 50,
                              fontWeight: FontWeight.bold))),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: TextFormField(
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'Provide an Email';
                              }
                              if (!input.contains('@calstatela.edu')) {
                                return 'Use Calstate LA email';
                              }
                            },
                            decoration: InputDecoration(
                                labelText: 'Email',
                                filled: true,
                                fillColor: Color.fromRGBO(226, 216, 216, .65),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)))),
                            onSaved: (input) => _email = input,
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, top: 10),
                          child: TextFormField(
                            validator: (input) {
                              if (input.length < 6) {
                                return 'Password has to be atleast 6 characters';
                              }
                            },
                            decoration: InputDecoration(
                                labelText: 'Password',
                                filled: true,
                                fillColor: Color.fromRGBO(226, 216, 216, .65),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)))),
                            onSaved: (input) => _password = input,
                            obscureText: true,
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ForgotPassword()));
                            },
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Text(
                                    'Forgot Password?',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ))),
                        ButtonBar(
                          alignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RaisedButton(
                              onPressed: signIn,
                              color: Color.fromRGBO(255, 204, 0, 1),
                              child: Text(
                                'Sign In',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: new Container(
                                  margin: const EdgeInsets.only(
                                      left: 10.0, right: 20.0),
                                  child: Divider(
                                    color: Colors.white,
                                    height: 36,
                                  )),
                            ),
                            Text(
                              "OR",
                              style: TextStyle(color: Colors.white),
                            ),
                            Expanded(
                              child: new Container(
                                  margin: const EdgeInsets.only(
                                      left: 20.0, right: 10.0),
                                  child: Divider(
                                    color: Colors.white,
                                    height: 36,
                                  )),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Don't have an account?",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            SignUp()));
                              },
                              child: Text(
                                'Create Account',
                                style: TextStyle(
//                                    color: Colors.black,
                                    color: Color.fromRGBO(255, 204, 0, 1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )),
        ),
      ),
    );
  }

  void signIn() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        Fluttertoast.showToast(
            msg: "Login Successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => Navigation()));
      } catch (e) {
        Fluttertoast.showToast(
            msg: e.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }
}
