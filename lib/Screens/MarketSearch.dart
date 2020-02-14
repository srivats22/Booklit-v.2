import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:url_launcher/url_launcher.dart';

class MarketSearch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MarkerSearch();
  }
}

class _MarkerSearch extends State<MarketSearch> {
  List<Item> items = List();
  Item item;
  DatabaseReference itemRef;
  TextEditingController controller = new TextEditingController();
  String filter;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    item = Item("", "", "", "");
    final FirebaseDatabase database = FirebaseDatabase
        .instance; //Rather then just writing FirebaseDatabase(), get the instance.
    itemRef = database.reference().child('sellBook');
    itemRef.onChildAdded.listen(_onEntryAdded);
    itemRef.onChildChanged.listen(_onEntryChanged);
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
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
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Padding(
                padding: EdgeInsets.only(top: 10),
                child: TextFormField(
                  autofocus: true,
                  controller: controller,
                  decoration: InputDecoration(
                      hintText: 'Search book name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)))),
                ),
              ),
            ),
            Flexible(
              child: FirebaseAnimatedList(
                query: itemRef,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  return items[index].book.toLowerCase().contains(filter) ||
                          items[index].book.contains(filter)
                      ? GestureDetector(
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
                                            if (loadingProgress == null)
                                              return child;
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
                                        items[index].book,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        items[index].name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        items[index].contact,
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 18),
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
                                                var email =
                                                    items[index].contact;
                                                var uri =
                                                    'mailto:$email?subject=Book availability&body=Hi, Is the book still'
                                                    ' available';
                                                if (canLaunch(uri) != null) {
                                                  launch(uri);
                                                } else {
                                                  throw 'Cannot launch $uri';
                                                }
                                              } else {
                                                var number =
                                                    items[index].contact;
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
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            color:
                                                Color.fromRGBO(255, 204, 0, 1),
                                            elevation: 10,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        30.0)),
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
                                title: Text(
                                  items[index].name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(items[index].contact),
                              ),
                            ),
                          ))
                      : new Container();
                },
              ),
            )
          ],
        ),
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
