import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:bijou/gmap.dart';
import 'package:bijou/businesspage.dart';
import 'package:bijou/searchhist.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  final database = FirebaseFirestore.instance;
  String searchString;
  var currentLocation;
  var businesses = [];
  var closebusinesses = [];
  var filterdist = '1';
  bool loading = true;

  @override
  void initState() {
    super.initState();
    Geolocator.getCurrentPosition().then((currloc) {
      setState(() {
        currentLocation = currloc;
        populateBusinesses();
        filterResults(filterdist);
      });
    });
  }

  populateBusinesses() {
    businesses = [];
    FirebaseFirestore.instance.collection('Businesses').get().then((docs) {
      if (docs.docs.isNotEmpty) {
        for (int i = 0; i < docs.docs.length; ++i) {
          businesses.add(docs.docs[i].data());
        }
      }
    });
  }

  emptyTextFormField() {
    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (loading)
      return CircularProgressIndicator();
    else
      return Scaffold(
        appBar: AppBar(
          title: Text('Search'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: () {
                  closebusinesses.clear();
                  getDist();
                })
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      onChanged: (val) {
                        setState(() {
                          searchString = val.toLowerCase();
                        });
                      },
                      style: TextStyle(fontSize: 18.0, color: Colors.black),
                      controller: _searchController,
                      decoration: InputDecoration(
                          hintText: "Search Small...",
                          hintStyle: TextStyle(color: Colors.grey),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          filled: true,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.white,
                            ),
                            onPressed: emptyTextFormField,
                          )),
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: (searchString == null ||
                              searchString.trim() == '')
                          ? FirebaseFirestore.instance
                              .collection('Businesses')
                              .snapshots()
                          : FirebaseFirestore.instance
                              .collection('Businesses')
                              .where('SearchKey', arrayContains: searchString)
                              .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error ${snapshot.error}');
                        }
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return SizedBox(
                              child: Center(
                                child: Text('Loading'),
                              ),
                            );
                          case ConnectionState.none:
                            return Text('No data present');

                          case ConnectionState.done:
                            return Text('Done');

                          default:
                            if (closebusinesses.length > 0) {
                              return new ListView(
                                  children: snapshot.data.docs
                                      .map((DocumentSnapshot document) {
                                for (int i = 0;
                                    i < closebusinesses.length;
                                    ++i) {
                                  if (document['Name'] ==
                                      closebusinesses[i]['Name']) {
                                    return new GestureDetector(
                                      onTap: () {
                                        userSearches(searchString);
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    businesspage(
                                                        business:
                                                            closebusinesses[
                                                                i])));
                                      },
                                      child: Card(
                                          child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: 100,
                                            height: 100,
                                            //child: Image.asset('ecofriendly.png'),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  document['Name'],
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  width: 200,
                                                  child: Text(
                                                    document['Description'],
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.grey[500],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      )),
                                    );
                                  }
                                }
                              }).toList());
                            } else
                              return new ListView(
                                  children: snapshot.data.docs
                                      .map((DocumentSnapshot document) {
                                for (int i = 0; i < businesses.length; ++i) {
                                  if (document['Name'] ==
                                      businesses[i]['Name']) {
                                    return new GestureDetector(
                                      onTap: () {
                                        userSearches(searchString);
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    businesspage(
                                                        business:
                                                            businesses[i])));
                                      },
                                      child: Card(
                                          child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: 100,
                                            height: 100,
                                            //child: Image.asset('ecofriendly.png'),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  document['Name'],
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  width: 200,
                                                  child: Text(
                                                    document['Description'],
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.grey[500],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      )),
                                    );
                                  }
                                }
                              }).toList());
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Increment',
          child: Icon(Icons.map),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GMap()),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      );
  }

  filterResults(dist) async {
    for (int i = 0; i < businesses.length; ++i) {
      double howfar = Geolocator.distanceBetween(
          currentLocation.latitude,
          currentLocation.longitude,
          businesses[i]['Location'].latitude,
          businesses[i]['Location'].longitude);
      double howfarmiles = howfar / 1609;
      if (howfarmiles < double.parse(dist)) {
        closebusinesses.add(businesses[i]);
      }
    }
    print(closebusinesses);
    loading = false;
  }

  Future<bool> getDist() async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter Distance in Miles'),
            contentPadding: EdgeInsets.all(10.0),
            content: TextField(
                decoration: InputDecoration(hintText: 'Miles'),
                onChanged: (val) {
                  setState(() {
                    filterdist = val;
                  });
                }),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  filterResults(filterdist);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
