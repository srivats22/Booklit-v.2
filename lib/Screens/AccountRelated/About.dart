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
              color: Color.fromRGBO(255, 204, 0, 1),
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
                          cacheHeight: 100,
                          cacheWidth: 100,
                          scale: .5,
                          height: 100,
                          width: 100,
                        ),
                        Text(
                          'BookLit',
                          style: TextStyle(
                            color: Color.fromRGBO(255, 204, 0, 1),
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'For Students, by Students',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontStyle: FontStyle.italic),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'BookLit was developed with one goal in mind.'
                            'To make buying and selling books easier for students at '
                            'Cal State LA.\nHow do we do this? Well it is simple.\n'
                            'We find pdf versions of books used on campus, get the pdf link '
                            'which we then upload to a secure database, which gives you'
                            ' access to the books. We also have our users upload books they wish to sell'
                            ' and you can find sellers based on book name',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.robotoMono(
                                textStyle: TextStyle(fontSize: 20)),
                          ),
                        ),
                      ],
                    )))
          ],
        ),
      ),
    );
  }
}
