import 'package:booklit/Auth/Login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:booklit/Navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController userName, preferredContact, classStanding;
  String _email, _password;
  @override
  void initState() {
    userName = new TextEditingController();
    preferredContact = new TextEditingController();
    classStanding = new TextEditingController();
    super.initState();
  }

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
                      Text(
                        'BookLit',
                        style: TextStyle(
                            color: Color.fromRGBO(255, 204, 0, 1),
                            fontSize: 50,
                            fontWeight: FontWeight.bold),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: TextFormField(
                                validator: (input) {
                                  if (input.isEmpty) {
                                    return 'Name is required';
                                  }
                                },
                                controller: userName,
                                decoration: InputDecoration(
                                    labelText: 'Name',
                                    filled: true,
                                    fillColor:
                                        Color.fromRGBO(226, 216, 216, .65),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)))),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 20, right: 20, top: 10),
                              child: TextFormField(
                                validator: (input) {
                                  if (!input.contains("@calstatela.edu")) {
                                    return 'Cal State LA email required to signin';
                                  }
                                  if (input.isEmpty) {
                                    return 'Email is required';
                                  }
                                },
                                decoration: InputDecoration(
                                    labelText: 'Email',
                                    filled: true,
                                    fillColor:
                                        Color.fromRGBO(226, 216, 216, .65),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)))),
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
                                    fillColor:
                                        Color.fromRGBO(226, 216, 216, .65),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)))),
                                onSaved: (input) => _password = input,
                                obscureText: true,
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 20, right: 20, top: 10),
                              child: TextFormField(
                                validator: (input) {
                                  if (input.length < 6) {
                                    return 'Contact Info required';
                                  }
                                },
                                controller: preferredContact,
                                decoration: InputDecoration(
                                    labelText: 'Preferred Contact Info',
                                    filled: true,
                                    fillColor:
                                        Color.fromRGBO(226, 216, 216, .65),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)))),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 20, right: 20, top: 10),
                              child: TextFormField(
                                validator: (input) {
                                  if (input.length < 6) {
                                    return 'Class Standing required';
                                  }
                                },
                                controller: classStanding,
                                decoration: InputDecoration(
                                    labelText: 'Class Standing',
                                    filled: true,
                                    fillColor:
                                        Color.fromRGBO(226, 216, 216, .65),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)))),
                              ),
                            ),
                            RaisedButton(
                              onPressed: signUp,
                              color: Color.fromRGBO(255, 204, 0, 1),
                              child: Text(
                                'Sign Up',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Have an account?",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                Login()));
                                  },
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(255, 204, 0, 1),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ), //column for form
                      ),
                    ],
                  ),
                ],
              )))),
    );
  }

  void signUp() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        final FirebaseUser user = await FirebaseAuth.instance.currentUser();
        user.sendEmailVerification();
        final uid = user.uid;
        Firestore.instance.collection("users").document(uid).setData({
          "Name": userName.text,
          "Contact Info": preferredContact.text,
          "Class Standing": classStanding.text
        });
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => Navigation()));
      } catch (e) {
        print(e.message);
      }
    }
  }
}
