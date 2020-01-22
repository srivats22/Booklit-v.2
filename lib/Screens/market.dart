import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class Market extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MarketState();
  }
}

class _MarketState extends State<Market> {
  List<Seller> sellers = List();
  Seller seller;
  DatabaseReference sellerRef;
  TextEditingController controller = new TextEditingController();
  String filter;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    seller = Seller("", "", "", "");
    final FirebaseDatabase database = FirebaseDatabase.instance;
    sellerRef = database.reference().child('seller');
    sellerRef.onChildAdded.listen(_onEntryAdded);
    sellerRef.onChildChanged.listen(_onEntryChanged);
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
  }

  _onEntryAdded(Event event) {
    setState(() {
      sellers.add(Seller.fromSnapshot(event.snapshot));
    });
  }

  _onEntryChanged(Event event) {
    var old = sellers.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      sellers[sellers.indexOf(old)] = Seller.fromSnapshot(event.snapshot);
    });
  }

  void handleSubmit() {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();
      form.reset();
      sellerRef.push().set(seller.toJson());
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
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                autofocus: true,
                controller: controller,
                decoration: InputDecoration(
                    hintText: 'Search Book Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)))),
              ),
            ),
            Flexible(
              child: FirebaseAnimatedList(
                  query: sellerRef,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    return sellers[index].bookName.contains(filter)
                        ? GestureDetector(
                        onTap: () => showBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                height: 400,
                                child: ListView(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  children: <Widget>[
                                    Image.network(
                                      sellers[index].image,
                                      height: 200,
                                      width: 200,
                                    ),
                                    Center(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            sellers[index].sellerName,
                                            style: TextStyle(
                                                fontWeight:
                                                FontWeight.bold),
                                          ),
                                          Text(
                                            sellers[index].sellercontact,
                                            style: TextStyle(
                                                fontWeight:
                                                FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Card(
                            elevation: 10,
                            color: Color.fromRGBO(255, 236, 179, 1),
                            child: ListTile(
                              leading: Image.network(
                                sellers[index].image,
                                fit: BoxFit.cover,
                              ),
                              title: Text(sellers[index].sellerName),
                              subtitle: Text(sellers[index].sellercontact),
                            ),
                          ),
                        ))
                        : new Container();
                  }),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add
          ),
          onPressed: (){
            showBottomSheet(context: context, builder: (context){
              return Container(
                child: Form(
                  key: formKey,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: <Widget>[
                      TextFormField(
                        initialValue: "",
                        onSaved: (val) => seller.image = val,
                        validator: (val) => val == "" ? val : null,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20),
                            hintText: 'Image',
                            border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(50)))),
                      ),
                      TextFormField(
                        initialValue: "",
                        onSaved: (val) => seller.sellercontact = val,
                        validator: (val) => val == "" ? val : null,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20),
                            hintText: 'Contact',
                            border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(50)))),
                      ),
                      TextFormField(
                        initialValue: "",
                        onSaved: (val) => seller.sellerName = val,
                        validator: (val) => val == "" ? val : null,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20),
                            hintText: 'Name',
                            border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(50)))),
                      ),
                      TextFormField(
                        initialValue: "",
                        onSaved: (val) => seller.bookName = val,
                        validator: (val) => val == "" ? val : null,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20),
                            hintText: 'Book Name',
                            border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(50)))),
                      ),
                      RaisedButton(
                        onPressed: handleSubmit,
                        child: Text('Submit'),
                      ),
                      RaisedButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text('Close'),
                      )
                    ],
                  ),
                )
              );
            });
          },
        ),
      ),
    );
  }
}

class Seller {
  String key;
  String image;
  String sellerName;
  String sellercontact;
  String bookName;

  Seller(this.image, this.sellerName, this.sellercontact, this.bookName);

  Seller.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        image = snapshot.value["image"],
        sellerName = snapshot.value["seller Name"],
  sellercontact = snapshot.value["Seller Contact"],
  bookName = snapshot.value["Book  Name"];

  toJson() {
    return {
      "image": image,
      "seller name": sellerName,
      "Seller comtact": sellercontact,
      "Book Name": bookName,
      "image": image
    };
  }
}

