import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

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
    book = Book("", "", "", "", "", "", "", "");
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
                      color: Color.fromRGBO(255, 204, 0, 1),
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                autofocus: true,
                controller: controller,
                decoration: InputDecoration(
                    hintText: 'Search ISBN or Book Name or Major',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)))),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Available PDF',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
            Flexible(
              child: FirebaseAnimatedList(
                query: bookRef,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  return books[index].name.contains(filter) ||
                          books[index].isbn.contains(filter) ||
                          books[index].major.contains(filter)
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
                                          books[index].image,
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
                                        books[index].name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        books[index].edition + ' Edition',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        books[index].author,
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
                                              //ToDo: open pdf link
                                              var url = books[index].link;
                                              if (canLaunch(url) != null) {
                                                launch(url);
                                              } else {
                                                throw 'Could not launch $url';
                                              }
                                            },
                                            child: Text(
                                              'Open PDF\non Mobile',
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
                                          RaisedButton(
                                            onPressed: () {
                                              //ToDo: send pdf link
                                              var bookLink = books[index].link;
                                              Share.share(bookLink);
                                            },
                                            child: Text(
                                              'Share PDF',
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
                                isThreeLine: true,
                                leading: Image.network(
                                  books[index].image,
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
                                  books[index].name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(books[index].author +
                                    '\n' +
                                    books[index].edition),
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

class Book {
  String key;
  String image;
  String name;
  String isbn;
  String edition;
  String author;
  String link;
  String major;
  String isbn13;

  Book(this.image, this.name, this.isbn, this.edition, this.author, this.link,
      this.major, this.isbn13);

  Book.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        image = snapshot.value["image"],
        name = snapshot.value["name"],
        isbn = snapshot.value["isbn"],
        edition = snapshot.value["edition"],
        author = snapshot.value["author"],
        link = snapshot.value["link"],
        major = snapshot.value["major"],
        isbn13 = snapshot.value["isbn13"];

  toJson() {
    return {
      "image": image,
      "name": name,
      "isbn": isbn,
      "edition": edition,
      "author": author,
      "link": link,
      "major": major,
      "isbn13": isbn13
    };
  }
}
