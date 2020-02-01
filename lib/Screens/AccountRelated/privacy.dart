import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Privacy extends StatelessWidget {
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
          child: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            Text(
              'Privacy Information',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'What information do we collect?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  Text(
                    'When you signed up for BookLit, we asked for the following:\n'
                    '- Cal State LA email address\n'
                    '- Create a Password\n'
                    '- Your name\n'
                    '- Preferred contact info\n'
                    '- Class standing',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'When you want to sell a book, we ask the following:\n'
                    '- Your name\n'
                    '- Prefered Contact info',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.black,
              thickness: .5,
            ),
            Text(
              'How do we use this information?',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  Text(
                    'Private Data: \n'
                    '- Your name\n- Cal State LA email\n- Contact Info\n- Class Standing\n'
                    'This is information is collected so we know our user base',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  Text(
                    'Public Date: \n'
                    '- Name\n- Contact Info\nThis is what you fill out when you want to sell a book',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.black,
              thickness: .5,
            ),
            Text(
              'What information is shared?',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Well we dont share any information. All the information you share with us, is sent'
                'to a secure databse server in the cloud. Only the developers of the app have access'
                'to the database.',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
            Divider(
              color: Colors.black,
              thickness: .5,
            ),
            Text(
              'Emails you might receive from us:',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Change of password: If you forgot your password, and asked for a reset password'
                'then you will get an automatic email from our server with a link to change your password',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Email Verification: When signing up for BookLit, we send out an email with a link for'
                ' you to verify your account',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Request book: If you placed a request for a book, we look for it. We will email you'
                ' the result of the search once it is complete.',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            )
          ],
        ),
      )),
    );
  }
}
