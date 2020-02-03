import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HardBound extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HardBoundState();
  }
}

class _HardBoundState extends State<HardBound> {
  List<HardBoundList> items = List();
  HardBoundList item;
  DatabaseReference itemRef;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    item = HardBoundList("", "", "");
    final FirebaseDatabase database = FirebaseDatabase
        .instance; //Rather then just writing FirebaseDatabase(), get the instance.
    itemRef = database.reference().child('hardBound');
    itemRef.onChildAdded.listen(_onEntryAdded);
    itemRef.onChildChanged.listen(_onEntryChanged);
  }

  _onEntryAdded(Event event) {
    setState(() {
      items.add(HardBoundList.fromSnapshot(event.snapshot));
    });
  }

  _onEntryChanged(Event event) {
    var old = items.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      items[items.indexOf(old)] = HardBoundList.fromSnapshot(event.snapshot);
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
                      color: Color.fromRGBO(255, 204, 0, 1),
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Flexible(
              flex: 0,
              child: Center(
                child: Form(
                  key: formKey,
                  child: Flex(
                    direction: Axis.vertical,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 20, bottom: 5),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Sell a Book',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      ListTile(
                        title: TextFormField(
                          initialValue: '',
                          onSaved: (val) => item.sellerName = val,
                          validator: (val) => val == "" ? val : null,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 20),
                              hintText: 'Names',
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)))),
                        ),
                      ),
                      ListTile(
                        title: TextFormField(
                          initialValue: '',
                          onSaved: (val) => item.contactInfo = val,
                          validator: (val) => val == "" ? val : null,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 20),
                              hintText: 'Contact Info',
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)))),
                        ),
                      ),
                      ListTile(
                        title: TextFormField(
                          initialValue: '',
                          onSaved: (val) => item.bookName = val,
                          validator: (val) => val == "" ? val : null,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 20),
                              hintText: 'Book Name',
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)))),
                        ),
                      ),
                      RaisedButton(
                        color: Color.fromRGBO(255, 214, 89, 1),
                        onPressed: handleSubmit,
                        child: Text('Submit'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HardBoundList {
  String key;
  String sellerName;
  String bookName;
  String contactInfo;

  HardBoundList(this.sellerName, this.bookName, this.contactInfo);

  HardBoundList.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        bookName = snapshot.value["Book Name"],
        sellerName = snapshot.value["Name"],
        contactInfo = snapshot.value["Contact"];

  toJson() {
    return {
      "seller name": sellerName,
      "contact Info": contactInfo,
      "book name": bookName,
    };
  }
}
