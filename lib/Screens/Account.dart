import 'package:booklit/Auth/Login.dart';
import 'package:booklit/Screens/AccountRelated/UserProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'AccountRelated/About.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Account extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AccountState();
  }
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        body: ListView(
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
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ListTile(
                    leading: Card(
                      color: Color.fromRGBO(126, 187, 191, 1),
                      child: Icon(
                        Icons.account_circle,
                        size: 50,
                        color: Colors.black,
                      ),
                    ),
                    title: FutureBuilder(
                      future: FirebaseAuth.instance.currentUser(),
                      builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                        if (snapshot.hasData) {
                          String email = snapshot.data.email;
                          String name = email.substring(
                              0, email.indexOf("@calstatela.edu"));
                          return Text(
                            'Name: ' + name,
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(fontSize: 20)),
                          );
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                    subtitle: FutureBuilder(
                      future: FirebaseAuth.instance.currentUser(),
                      builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                        if (snapshot.hasData) {
                          String email = snapshot.data.email;
                          return Text(
                            'Email: ' +
                                email +
                                '\nVerified: ' +
                                snapshot.data.isEmailVerified.toString(),
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                    fontSize: 20, color: Colors.black)),
                          );
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: ListTile(
                      leading: Icon(
                        Icons.lock,
                        color: Colors.black,
                      ),
                      title: Text(
                        'Privacy',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: .5,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: ListTile(
                      leading: Icon(
                        Icons.security,
                        color: Colors.black,
                      ),
                      title: Text(
                        'Terms of Use',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: .5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => About()),
                      );
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.info,
                        color: Colors.black,
                      ),
                      title: Text(
                        'About',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Divider(
                    thickness: .5,
                    color: Colors.black,
                  ),
                  GestureDetector(
                    onTap: _launchURL,
                    child: ListTile(
                      leading: Icon(
                        Icons.attach_money,
                        color: Colors.black,
                      ),
                      title: Text(
                        'Support Development',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: .5,
                  ),
                  GestureDetector(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Login()));
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.exit_to_app,
                        color: Colors.black,
                      ),
                      title: Text(
                        'Logout',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

_launchURL() async {
  const url =
      'https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=2BGZ6UUJRHPN4&currency_code=USD&source=url';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
