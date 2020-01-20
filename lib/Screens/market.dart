import 'package:flutter/material.dart';

class Market extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MarketState();
  }
}

class _MarketState extends State<Market> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'BookLit',
                  style: TextStyle(
                      color: Color.fromRGBO(255, 214, 89, 1),
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Text('Market')
          ],
        ),
      ),
    );
  }
}
