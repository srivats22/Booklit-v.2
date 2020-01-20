import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'BookLit',
          style: TextStyle(
              color: Color.fromRGBO(255, 214, 89, 1),
              fontSize: 40,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            Align(
                alignment: Alignment.topCenter,
                child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Column(
                      children: <Widget>[
                        Image.asset(
                          'assets/images/logoFinal.png',
                          scale: .5,
                          height: 100,
                          width: 100,
                        ),
                        Text(
                          'BookLit',
                          style: TextStyle(
                              color: Color.fromRGBO(255, 214, 89, 1),
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        ),
                        Text('For Students, by Students'),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'BookLit was developed with one goal in mind.'
                            'To make buying and selling books easier for students at\n'
                            'Cal State LA.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.robotoMono(
                                textStyle: TextStyle(fontSize: 20)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 30, right: 30),
                          child: Divider(
                            color: Colors.black,
                            thickness: .5,
                          ),
                        ),
                        GestureDetector(
                          child: ListTile(
                            leading: Icon(
                              FontAwesomeIcons.github,
                              color: Colors.black,
                              size: 20,
                            ),
                            title: Text(
                              'Github',
                              style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                      color: Colors.black, fontSize: 20)),
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: ListTile(
                            leading: Icon(
                              Icons.email,
                              color: Colors.black,
                            ),
                            title: Text(
                              'Contact Us',
                              style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                      fontSize: 20, color: Colors.black)),
                            ),
                          ),
                        )
                      ],
                    )))
          ],
        ),
      ),
    );
  }
}
