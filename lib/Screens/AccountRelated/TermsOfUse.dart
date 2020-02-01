import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TermsOfUse extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TermsOfUseState();
  }
}

class _TermsOfUseState extends State<TermsOfUse> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
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
        body: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
        ),
      ),
    );
  }
}
