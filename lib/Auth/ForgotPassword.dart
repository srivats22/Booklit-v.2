import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ForgotPasswordState();
  }
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email;
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
                    Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Just fill out the form below and you will get a link to reset your password',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Form(
                        key: _formKey,
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
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: forgotPassword,
                          color: Color.fromRGBO(255, 204, 0, 1),
                          child: Text(
                            'Submit',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void forgotPassword() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
        Fluttertoast.showToast(
            msg: "Password Reset Email sent, Dont forget to check spam",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      } catch (e) {
        print(e);
      }
    }
  }
}
