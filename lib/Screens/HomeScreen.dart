import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  List<Book> books = List();
  Book book;
  DatabaseReference bookRef;
  TextEditingController controller = new TextEditingController();
  String filter;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    book = Book("", "", "", "", "", "");
    final FirebaseDatabase database = FirebaseDatabase.instance;
    bookRef = database.reference().child('PDFs');
    bookRef.onChildAdded.listen(_onEntryAdded);
    bookRef.onChildChanged.listen(_onEntryChanged);
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
  }

  _onEntryAdded(Event event) {
    setState(() {
      books.add(Book.fromSnapshot(event.snapshot));
    });
  }

  _onEntryChanged(Event event) {
    var old = books.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      books[books.indexOf(old)] = Book.fromSnapshot(event.snapshot);
    });
  }

  void handleSubmit() {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();
      form.reset();
      bookRef.push().set(book.toJson());
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
                    hintText: 'Search ISBN or Book Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)))),
              ),
            ),
            Flexible(
              child: FirebaseAnimatedList(
                  query: bookRef,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    return books[index].name.contains(filter) ||
                            books[index].isbn.contains(filter)
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
                                          books[index].image,
                                          height: 200,
                                          width: 200,
                                        ),
                                        Center(
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                books[index].name,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                books[index].edition,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                books[index].author,
                                                style: TextStyle(
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ],
                                          ),
                                        ),
                                        ButtonBar(
                                          alignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            RaisedButton(
                                              child:
                                                  Text('Open PDF\non mobile'),
                                              onPressed: () {
                                                var url = books[index].link;
                                                if (canLaunch(url) != null) {
                                                  launch(url);
                                                } else {
                                                  throw 'Could not launch $url';
                                                }
                                              },
                                            ),
                                            RaisedButton(
                                              child: Text('Send PDF\n(email)'),
                                            ),
                                            RaisedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('Close'),
                                            )
                                          ],
                                        )
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
                                    books[index].image,
                                    fit: BoxFit.cover,
                                  ),
                                  title: Text(books[index].name),
                                  subtitle: Text(books[index].edition),
                                ),
                              ),
                            ))
                        : new Container();
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class Book {
  String key;
  String image;
  String name;
  String isbn;
  String edition;
  String author;
  String link;

  Book(this.image, this.name, this.isbn, this.edition, this.author, this.link);

  Book.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        image = snapshot.value["image"],
        name = snapshot.value["name"],
        isbn = snapshot.value["isbn"],
        edition = snapshot.value["edition"],
        author = snapshot.value["author"],
        link = snapshot.value["link"];

  toJson() {
    return {
      "image": image,
      "name": name,
      "isbn": isbn,
      "edition": edition,
      "author": author,
      "link": link
    };
  }
}
