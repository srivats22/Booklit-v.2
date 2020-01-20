import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Request extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RequestState();
  }
}

class _RequestState extends State<Request> {
  List<RequestList> items = List();
  RequestList item;
  DatabaseReference itemRef;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    item = RequestList("", "", "");
    final FirebaseDatabase database = FirebaseDatabase
        .instance; //Rather then just writing FirebaseDatabase(), get the instance.
    itemRef = database.reference().child('request');
    itemRef.onChildAdded.listen(_onEntryAdded);
    itemRef.onChildChanged.listen(_onEntryChanged);
  }

  _onEntryAdded(Event event) {
    setState(() {
      items.add(RequestList.fromSnapshot(event.snapshot));
    });
  }

  _onEntryChanged(Event event) {
    var old = items.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      items[items.indexOf(old)] = RequestList.fromSnapshot(event.snapshot);
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
      resizeToAvoidBottomPadding: false,
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
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Request A Book',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.email,
                        color: Colors.black,
                      ),
                      title: TextFormField(
                        initialValue: "",
                        onSaved: (val) => item.email = val,
                        validator: (val) => val == "" ? val : null,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20),
                            hintText: 'Email',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)))),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.import_contacts,
                        color: Colors.black,
                      ),
                      title: TextFormField(
                        initialValue: '',
                        onSaved: (val) => item.bookName = val,
                        validator: (val) => val == "" ? val : null,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20),
                            hintText: 'Book Names',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)))),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.texture,
                        color: Colors.black,
                      ),
                      title: TextFormField(
                        initialValue: '',
                        onSaved: (val) => item.format = val,
                        validator: (val) => val == "" ? val : null,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20),
                            hintText: 'Format(PDF/Hard bound)',
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
    );
  }
}

class RequestList {
  String key;
  String email;
  String bookName;
  String format;

  RequestList(this.email, this.bookName, this.format);

  RequestList.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        email = snapshot.value["Email"],
        bookName = snapshot.value["Book Name"],
        format = snapshot.value["Format"];

  toJson() {
    return {"Email": email, "Book Name": bookName, "Format": format};
  }
}
