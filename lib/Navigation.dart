import 'package:booklit/Screens/Account.dart';
import 'package:booklit/Screens/HomeScreen.dart';
import 'package:booklit/Screens/Request.dart';
import 'package:booklit/Screens/market.dart';
import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NavigationState();
  }
}

class _NavigationState extends State<Navigation> {
  int _selectedPage = 0;
  final _pageOption = [
    Home(),
    Market(),
    Request(),
    Account(),
  ];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        body: _pageOption[_selectedPage],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color.fromRGBO(255, 214, 89, 1),
          currentIndex: _selectedPage,
          onTap: (int index) {
            setState(() {
              _selectedPage = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.picture_as_pdf,
                  color: Colors.black,
                ),
                title: Text(
                  'PDF',
                  style: TextStyle(color: Colors.black),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.shopping_basket,
                  color: Colors.black,
                ),
                title: Text(
                  'Market',
                  style: TextStyle(color: Colors.black),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                title: Text(
                  'Request',
                  style: TextStyle(color: Colors.black),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_circle,
                  color: Colors.black,
                ),
                title: Text(
                  'Account',
                ))
          ],
        ),
      ),
    );
  }
}
