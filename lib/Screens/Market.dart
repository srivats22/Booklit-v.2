import 'dart:io';
import 'package:booklit/Screens/MarketSearch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:booklit/Screens/HardBound.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:url_launcher/url_launcher.dart';

class Market extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MarketState();
  }
}

class _MarketState extends State<Market> {
  List<Item> items = List();
  Item item;
  DatabaseReference itemRef;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    item = Item("", "", "", "");
    final FirebaseDatabase database = FirebaseDatabase
        .instance; //Rather then just writing FirebaseDatabase(), get the instance.
    itemRef = database.reference().child('sellBook');
    itemRef.onChildAdded.listen(_onEntryAdded);
    itemRef.onChildChanged.listen(_onEntryChanged);
  }

  _onEntryAdded(Event event) {
    setState(() {
      items.add(Item.fromSnapshot(event.snapshot));
    });
  }

  _onEntryChanged(Event event) {
    var old = items.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      items[items.indexOf(old)] = Item.fromSnapshot(event.snapshot);
    });
  }

  void handleSubmit() {
    final FormState form = formKey.currentState;

    if (form.validate()) {
      form.save();
      form.reset();
      itemRef.push().set(item.toJson());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'BookLit',
                        style: TextStyle(
                            color: Color.fromRGBO(255, 204, 0, 1),
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      MarketSearch()));
                        },
                        icon: Icon(Icons.search),
                        color: Colors.black,
                        iconSize: 30,
                      ),
                    ),
                  )
                ],
              )),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Sellers',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
          ),
          Flexible(
            child: FirebaseAnimatedList(
              query: itemRef,
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                return GestureDetector(
                    onTap: () => showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            height: 500,
                            child: ListView(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Image.network(
                                    items[index].image,
                                    scale: .8,
                                    height: 200,
                                    width: 200,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Text(
                                  'Book Name: ' + items[index].book,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  "Seller's Name: " + items[index].name,
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  "Contact Info: " + items[index].contact,
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center,
                                ),
                                ButtonBar(
                                  alignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    RaisedButton(
                                      onPressed: () {
                                        if (items[index]
                                            .contact
                                            .contains('@')) {
                                          var email = items[index].contact;
                                          var uri =
                                              'mailto:$email?subject=Book availability&body=Hi, Is the book still'
                                              ' available';
                                          if (canLaunch(uri) != null) {
                                            launch(uri);
                                          } else {
                                            throw 'Cannot launch $uri';
                                          }
                                        } else {
                                          var number = items[index].contact;
                                          var uri =
                                              'sms:$number?body=Is the book still available';
                                          if (canLaunch(uri) != null) {
                                            launch(uri);
                                          } else {
                                            throw 'Cannot launch $uri';
                                          }
                                        }
                                      },
                                      child: Text(
                                        'Contact Seller',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      color: Color.fromRGBO(255, 204, 0, 1),
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30.0)),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        }),
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Card(
                        elevation: 10,
                        color: Color.fromRGBO(255, 236, 179, 1),
                        child: ListTile(
                          leading: Image.network(
                            items[index].image,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes
                                      : null,
                                ),
                              );
                            },
                          ),
                          title: Text(
                            items[index].name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(items[index].contact),
                        ),
                      ),
                    ));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => HardBound()));
        },
        label: Text('Sell Book'),
        icon: Icon(Icons.add),
      ),
    );
  }
}

class Item {
  String key;
  String image;
  String book;
  String name;
  String contact;

  Item(this.image, this.book, this.name, this.contact);

  Item.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        image = snapshot.value["image"],
        name = snapshot.value["name"],
        contact = snapshot.value["contact"],
        book = snapshot.value["book"];

  toJson() {
    return {"image": image, "name": name, "contact": contact, "book": book};
  }
}
