import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:bijou/gmap.dart';
import 'package:bijou/businesspage.dart';
import 'package:bijou/searchhist.dart';
import 'package:firebase_database/firebase_database.dart';

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
  var bus_dist = [];
  var filterdist = '10';
  bool loading = true;

  reloadMainPageState() {
    setState(() {
      loading = true;
    });
  }

  @override
  void initState() {
    //reloadMainPageState();
    super.initState();
    Geolocator.getCurrentPosition().then((currloc) {
      setState(() {
        currentLocation = currloc;
        populateBusinesses();
      });
    });
  }

  populateBusinesses() {
    FirebaseFirestore.instance.collection('Businesses').get().then((docs) {
      if (docs.docs.isNotEmpty) {
        for (int i = 0; i < docs.docs.length; ++i) {
          businesses.add(docs.docs[i].data());
        }
        print(businesses);
        filterResults('10');
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
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: () {
                  setState(() {
                    loading = true;
                  });
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
                            color: Colors.grey,
                            size: 30.0,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.grey,
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
                            if (closebusinesses.length > 0 &&
                                loading == false) {
                              return new ListView(
                                  children: snapshot.data.docs
                                      .map((DocumentSnapshot document) {
                                for (int i = 0;
                                    i < closebusinesses.length;
                                    ++i) {
                                  if (document['Name'] ==
                                      closebusinesses[i]['Name']) {
                                    if (closebusinesses[i]['Blackowned'] &&
                                        closebusinesses[i]['Womenowned'] &&
                                        closebusinesses[i]['Ecofriendly']) {
                                      return new GestureDetector(
                                        onTap: () {
                                          userSearches(searchString);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      businesspage(
                                                        business:
                                                            closebusinesses[i],
                                                        bus_dis: bus_dist[i],
                                                      )));
                                        },
                                        child: Card(
                                            child: Row(
                                          children: <Widget>[
                                            Container(
                                              width: 120,
                                              height: 100,
                                              child: Image.network(
                                                  closebusinesses[i]['Image']),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    document['Name'],
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 200,
                                                    child: Text(
                                                      '${bus_dist[i].toStringAsFixed(2)} miles',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.grey[500],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Container(
                                                    width: 200,
                                                    child: Text(
                                                      document['Description'],
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.grey[500],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Container(
                                                        width: 20,
                                                        height: 20,
                                                        alignment: Alignment(
                                                            -1.0, 1.0),
                                                        child: Image(
                                                            image: AssetImage(
                                                                'assets/blackowned.png')),
                                                      ),
                                                      Container(
                                                        width: 20,
                                                        height: 20,
                                                        alignment: Alignment(
                                                            -1.0, 1.0),
                                                        child: Image(
                                                            image: AssetImage(
                                                                'assets/womenowned.png')),
                                                      ),
                                                      Container(
                                                        width: 20,
                                                        height: 20,
                                                        alignment: Alignment(
                                                            -1.0, 1.0),
                                                        child: Image(
                                                            image: AssetImage(
                                                                'assets/ecofriendly.png')),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                      );
                                    } else if (closebusinesses[i]
                                            ['Blackowned'] &&
                                        closebusinesses[i]['Womenowned']) {
                                      return new GestureDetector(
                                        onTap: () {
                                          userSearches(searchString);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      businesspage(
                                                        business:
                                                            closebusinesses[i],
                                                        bus_dis: bus_dist[i],
                                                      )));
                                        },
                                        child: Card(
                                            child: Row(
                                          children: <Widget>[
                                            Container(
                                              width: 120,
                                              height: 100,
                                              child: Image.network(
                                                  closebusinesses[i]['Image']),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    document['Name'],
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 200,
                                                    child: Text(
                                                      '${bus_dist[i].toStringAsFixed(2)} miles',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.grey[500],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Container(
                                                    width: 200,
                                                    child: Text(
                                                      document['Description'],
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.grey[500],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Container(
                                                        width: 20,
                                                        height: 20,
                                                        alignment: Alignment(
                                                            -1.0, 1.0),
                                                        child: Image(
                                                            image: AssetImage(
                                                                'assets/blackowned.png')),
                                                      ),
                                                      Container(
                                                        width: 20,
                                                        height: 20,
                                                        alignment: Alignment(
                                                            -1.0, 1.0),
                                                        child: Image(
                                                            image: AssetImage(
                                                                'assets/womenowned.png')),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                      );
                                    } else if (closebusinesses[i]
                                            ['Blackowned'] &&
                                        closebusinesses[i]['Ecofriendly']) {
                                      return new GestureDetector(
                                        onTap: () {
                                          userSearches(searchString);
                                          print('did it work');
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      businesspage(
                                                        business:
                                                            closebusinesses[i],
                                                        bus_dis: bus_dist[i],
                                                      )));
                                        },
                                        child: Card(
                                            child: Row(
                                          children: <Widget>[
                                            Container(
                                              width: 120,
                                              height: 100,
                                              child: Image.network(
                                                  closebusinesses[i]['Image']),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    document['Name'],
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 200,
                                                    child: Text(
                                                      '${bus_dist[i].toStringAsFixed(2)} miles',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.grey[500],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Container(
                                                    width: 200,
                                                    child: Text(
                                                      document['Description'],
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.grey[500],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Container(
                                                        width: 20,
                                                        height: 20,
                                                        alignment: Alignment(
                                                            -1.0, 1.0),
                                                        child: Image(
                                                            image: AssetImage(
                                                                'assets/blackowned.png')),
                                                      ),
                                                      Container(
                                                        width: 20,
                                                        height: 20,
                                                        alignment: Alignment(
                                                            -1.0, 1.0),
                                                        child: Image(
                                                            image: AssetImage(
                                                                'assets/ecofriendly.png')),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                      );
                                    } else if (closebusinesses[i]
                                            ['Womenowned'] &&
                                        closebusinesses[i]['Ecofriendly']) {
                                      return new GestureDetector(
                                        onTap: () {
                                          userSearches(searchString);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      businesspage(
                                                        business:
                                                            closebusinesses[i],
                                                        bus_dis: bus_dist[i],
                                                      )));
                                        },
                                        child: Card(
                                            child: Row(
                                          children: <Widget>[
                                            Container(
                                              width: 120,
                                              height: 100,
                                              child: Image.network(
                                                  closebusinesses[i]['Image']),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    document['Name'],
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 200,
                                                    child: Text(
                                                      '${bus_dist[i].toStringAsFixed(2)} miles',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.grey[500],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Container(
                                                    width: 200,
                                                    child: Text(
                                                      document['Description'],
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.grey[500],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Container(
                                                        width: 20,
                                                        height: 20,
                                                        alignment: Alignment(
                                                            -1.0, 1.0),
                                                        child: Image(
                                                            image: AssetImage(
                                                                'assets/womenowned.png')),
                                                      ),
                                                      Container(
                                                        width: 20,
                                                        height: 20,
                                                        alignment: Alignment(
                                                            -1.0, 1.0),
                                                        child: Image(
                                                            image: AssetImage(
                                                                'assets/ecofriendly.png')),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                      );
                                    } else if (closebusinesses[i]
                                        ['Blackowned']) {
                                      return new GestureDetector(
                                        onTap: () {
                                          userSearches(searchString);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      businesspage(
                                                        business:
                                                            closebusinesses[i],
                                                        bus_dis: bus_dist[i],
                                                      )));
                                        },
                                        child: Card(
                                            child: Row(
                                          children: <Widget>[
                                            Container(
                                              width: 120,
                                              height: 100,
                                              child: Image.network(
                                                  closebusinesses[i]['Image']),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    document['Name'],
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 200,
                                                    child: Text(
                                                      '${bus_dist[i].toStringAsFixed(2)} miles',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.grey[500],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Container(
                                                    width: 200,
                                                    child: Text(
                                                      document['Description'],
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.grey[500],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  Container(
                                                    width: 20,
                                                    height: 20,
                                                    alignment:
                                                        Alignment(-1.0, 1.0),
                                                    child: Image(
                                                        image: AssetImage(
                                                            'assets/blackowned.png')),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                      );
                                    } else if (closebusinesses[i]
                                        ['Womenowned']) {
                                      return new GestureDetector(
                                        onTap: () {
                                          userSearches(searchString);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      businesspage(
                                                        business:
                                                            closebusinesses[i],
                                                        bus_dis: bus_dist[i],
                                                      )));
                                        },
                                        child: Card(
                                            child: Row(
                                          children: <Widget>[
                                            Container(
                                              width: 120,
                                              height: 100,
                                              child: Image.network(
                                                  closebusinesses[i]['Image']),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    document['Name'],
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 200,
                                                    child: Text(
                                                      '${bus_dist[i].toStringAsFixed(2)} miles',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.grey[500],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Container(
                                                    width: 200,
                                                    child: Text(
                                                      document['Description'],
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.grey[500],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  Container(
                                                    width: 20,
                                                    height: 20,
                                                    alignment:
                                                        Alignment(-1.0, 1.0),
                                                    child: Image(
                                                        image: AssetImage(
                                                            'assets/womenowned.png')),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                      );
                                    } else if (closebusinesses[i]
                                        ['Ecofriendly']) {
                                      return new GestureDetector(
                                        onTap: () {
                                          if (searchString.isNotEmpty) {
                                            userSearches(searchString);
                                          }
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      businesspage(
                                                        business:
                                                            closebusinesses[i],
                                                        bus_dis: bus_dist[i],
                                                      )));
                                        },
                                        child: Card(
                                            child: Row(
                                          children: <Widget>[
                                            Container(
                                              width: 120,
                                              height: 100,
                                              child: Image.network(
                                                  closebusinesses[i]['Image']),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    document['Name'],
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 200,
                                                    child: Text(
                                                      '${bus_dist[i].toStringAsFixed(2)} miles',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.grey[500],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Container(
                                                    width: 200,
                                                    child: Text(
                                                      document['Description'],
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.grey[500],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  Container(
                                                    width: 20,
                                                    height: 20,
                                                    alignment:
                                                        Alignment(-1.0, 1.0),
                                                    child: Image(
                                                        image: AssetImage(
                                                            'assets/ecofriendly.png')),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                      );
                                    } else
                                      return new GestureDetector(
                                        onTap: () {
                                          print(
                                              closebusinesses[i]['ImageCount']);
                                          userSearches(searchString);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      businesspage(
                                                        business:
                                                            closebusinesses[i],
                                                        bus_dis: bus_dist[i],
                                                      )));
                                        },
                                        child: Card(
                                            child: Row(
                                          children: <Widget>[
                                            Container(
                                              width: 120,
                                              height: 100,
                                              child: Image.network(
                                                  closebusinesses[i]['Image']),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    document['Name'],
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 200,
                                                    child: Text(
                                                      '${bus_dist[i].toStringAsFixed(2)} miles',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.grey[500],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Container(
                                                    width: 200,
                                                    child: Text(
                                                      document['Description'],
                                                      style: TextStyle(
                                                        fontSize: 13,
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
                              return Text(
                                  'No close businesses, change filter distance');
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        floatingActionButton: Container(
          height: MediaQuery.of(context).size.width * 0.125,
          width: MediaQuery.of(context).size.width * 0.125,
          child: FloatingActionButton(
            backgroundColor: Colors.pinkAccent,
            tooltip: 'Increment',
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
            child: Icon(Icons.map),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GMap()),
            ),
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniEndDocked,
      );
  }

  filterResults(dist) {
    print(businesses.length);
    for (int i = 0; i < businesses.length; ++i) {
      double howfar = Geolocator.distanceBetween(
          currentLocation.latitude,
          currentLocation.longitude,
          businesses[i]['Location'].latitude,
          businesses[i]['Location'].longitude);
      double howfarmiles = howfar / 1609;
      print(howfarmiles);
      if (howfarmiles < double.parse(dist)) {
        closebusinesses.add(businesses[i]);
        bus_dist.add(howfarmiles);
      }
    }
    print('Image' + '1');
    setState(() {
      loading = false;
    });
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
                  setState(() {
                    loading = true;
                    closebusinesses.clear();
                  });
                  reloadMainPageState();

                  filterResults(filterdist);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
