import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _UserProfileState();
  }
}

class _UserProfileState extends State<UserProfile> {
  TextEditingController userName, preferredContact, classStanding;

  @override
  void initState() {
    // TODO: implement initState
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
        body: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(8),
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'BookLit',
                style: TextStyle(
                    color: Color.fromRGBO(255, 214, 89, 1),
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Name is required';
                    }
                  },
                  controller: userName,
                  decoration: InputDecoration(
                      labelText: 'Name',
                      filled: true,
                      fillColor: Color.fromRGBO(226, 216, 216, .65),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)))),
                ),
                TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Contact Info is required';
                    }
                  },
                  controller: preferredContact,
                  decoration: InputDecoration(
                      labelText: 'Prefered Contact',
                      filled: true,
                      fillColor: Color.fromRGBO(226, 216, 216, .65),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)))),
                ),
                TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Class Standing is required';
                    }
                  },
                  controller: classStanding,
                  decoration: InputDecoration(
                      labelText: 'Class Standing',
                      filled: true,
                      fillColor: Color.fromRGBO(226, 216, 216, .65),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)))),
                ),
                RaisedButton(
                  onPressed: submitProfile,
                  color: Color.fromRGBO(255, 204, 0, 1),
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void submitProfile() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final uid = user.uid;
    Firestore.instance.collection("users").document(uid).setData({
      "Name": userName.text,
      "Contact Info": preferredContact.text,
      "Class Standing": classStanding.text
    });
  }
}
