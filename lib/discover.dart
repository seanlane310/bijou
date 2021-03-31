import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:async/async.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bijou/productpage.dart';
import 'package:bijou/businesspagedisc.dart';
import 'signIn.dart';
import 'package:bijou/followpages.dart';

//when connect auth:
//final const user = await _firebaseAuth.currentUser();
//return await FirebaseDatabase.instance.reference().child('user').equalTo(user.uid);

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool start = true;
  List<bool> _selections = List.generate(2, (int index) => !(index == 1));
  List<String> dbResultSet;
  List<String> allUsers;
  var allUsersName;
  var tempSearchStore = [];
  var discoverStore = [];
  var followStore = [];
  int db_length = 0;
  int fol_len = 0;
  bool loGGED_IN = false;
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  String title = "Discover";

  Widget buildResultCard(data) {
    List<String> boards;
    final AsyncMemoizer _memoizer = AsyncMemoizer();
    final _formKey = GlobalKey<FormState>();
    var textValue = "";
    //bool loggedIn = false;
    var user_ID;

    if (FirebaseAuth.instance.currentUser != null) {
      loGGED_IN = true;
      user_ID = FirebaseAuth.instance.currentUser.uid;
      print("LOGGEDIN?" + loGGED_IN.toString());
    }

    Future fetchUserInfo() async {
      return _memoizer.runOnce(() async {
        print("GET HERE?");
        var ref = FirebaseDatabase.instance
            .reference()
            .child('Customers/$user_ID/Boards/');

        ref.once().then((DataSnapshot snapshot) async {
          print("HOW ABOUT HERE?");
          boards = snapshot.value.keys.cast<String>().toList();
          boards.add("New Board");
          if (boards.contains("Bijou Favorites")) {
            boards.remove("Bijou Favorites");
          }
          print(boards);
        });
      });
    }

    Future fetchUserInfo1() async {
      return _memoizer.runOnce(() async {
        print("GET HERE?");
        var ref = FirebaseDatabase.instance
            .reference()
            .child('Customers/$user_ID/Boards/');

        ref.once().then((DataSnapshot snapshot) async {
          print("HOW ABOUT HERE?");
          boards = snapshot.value.keys.cast<String>().toList();
          boards.add("New Board");
          if (boards.contains("Bijou Favorites")) {
            boards.remove("Bijou Favorites");
          }
          print(boards);
        });
      });
    }

    return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
            ),
            child: Image.network(
              data['Image'],
              height: 315,
              width: 3150,
              fit: BoxFit.contain,
            ),
          ),
          const Divider(
            height: 0,
            thickness: 1,
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            buttonHeight: 10,
            children: [
              TextButton(
                onPressed: () {
                  if (data['type'] == 'business') {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            businesspagedisc(business: data)));
                  } else if (data['type'] == 'product') {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => productpage(product: data)));
                  }
                },
                child: Text(data['Name'],
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ),
              FloatingActionButton(
                //onPressed: () => {print("ONPRESSED?!"), boards = []},//fetchUserInfo1(),//{print(data['y']);} ,
                child: loGGED_IN
                    ? FutureBuilder(
                        future: fetchUserInfo(),
                        builder: (ctx, snapshot) {
                          //fetchUserInfo1();
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              boards != null) {
                            return PopupMenuButton(
                              initialValue: 2,
                              child: Center(child: Icon(Icons.add)),
                              itemBuilder: (context) {
                                return List.generate(boards.length, (index) {
                                  print("HERE NOW");
                                  return PopupMenuItem(
                                    value: index,
                                    child: Text(boards[index].toString()),
                                  );
                                });
                              },
                              onSelected: (int index) async {
                                if (index != boards.length - 1) {
                                  String board_chosen = boards[index];
                                  String pin = data['id'];
                                  String type = data['type'] == 'business'
                                      ? 'Business'
                                      : 'Product';
                                  FirebaseDatabase.instance
                                      .reference()
                                      .child(
                                          'Customers/$user_ID/Boards/$board_chosen/$type')
                                      .update({'$pin': 'true'});
                                } else {
                                  showDialog<void>(
                                      context: ctx,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Stack(
                                            overflow: Overflow.visible,
                                            children: <Widget>[
                                              Positioned(
                                                right: -40.0,
                                                top: -40.0,
                                                child: InkResponse(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: CircleAvatar(
                                                    child: Icon(Icons.close),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                ),
                                              ),
                                              Form(
                                                key: _formKey,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Text(
                                                            "Enter Board Name")),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: TextFormField(
                                                          onChanged: (v) {
                                                        textValue = v;
                                                      }),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: RaisedButton(
                                                          child: Text(
                                                              "Create Board and Add Pin"),
                                                          onPressed: () {
                                                            if (textValue
                                                                .isEmpty) {
                                                              showDialog<void>(
                                                                  context: ctx,
                                                                  //print("EMPTY");
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      title: Text(
                                                                          'Please Enter A Board Name'),
                                                                      actions: <
                                                                          Widget>[
                                                                        TextButton(
                                                                          child:
                                                                              Text('Ok'),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                        ),
                                                                      ],
                                                                    );
                                                                  });
                                                            } else {
                                                              print(
                                                                  "Running new board fct");
                                                              String pin =
                                                                  data['id'];
                                                              String type = data[
                                                                          'type'] ==
                                                                      'business'
                                                                  ? 'Business'
                                                                  : 'Product';
                                                              String deftype = data[
                                                                          'type'] !=
                                                                      'business'
                                                                  ? 'Business'
                                                                  : 'Product';
                                                              FirebaseDatabase
                                                                  .instance
                                                                  .reference()
                                                                  .child(
                                                                      'Customers/$user_ID/Boards/$textValue/$type')
                                                                  .set({
                                                                '$pin': 'true'
                                                              });
                                                              FirebaseDatabase
                                                                  .instance
                                                                  .reference()
                                                                  .child(
                                                                      'Customers/$user_ID/Boards/$textValue/$deftype')
                                                                  .set({
                                                                'default':
                                                                    'true'
                                                              });
                                                              textValue = "";
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              setState(() {
                                                                fetchUserInfo1();
                                                              });
                                                            }
                                                          }),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                }
                              },
                            );
                          } else {
                            //fetchUserInfo1();
                            return Container(width: 0.0, height: 0.0);
                            //print("SKIPPING?");
                          }
                        })
                    : Container(width: 0.0, height: 0.0),

                backgroundColor: Colors.red,
              )
            ],
          ),
        ]));
    //}
  }

  Future initially() async {
    return this._memoizer.runOnce(() async {
      if (await FirebaseAuth.instance.currentUser != null) {
        print("1.RUNNING?!");
        var userID = FirebaseAuth.instance.currentUser.uid;
        loGGED_IN = true;

        var refer = FirebaseDatabase.instance
            .reference()
            .child('Customers/$userID/Following/');
        await refer.once().then((DataSnapshot snapshot) async {
          dbResultSet = snapshot.value.keys.cast<String>().toList();
          setState(() {
            fol_len = dbResultSet.length;
          });
        });
        print("1.2.RUNNING?!");
        var ref = await FirebaseDatabase.instance
            .reference()
            .child('Customers/$userID/Searches/');
        ref.once().then((DataSnapshot snapshot) async {
          dbResultSet = snapshot.value.keys.cast<String>().toList();
          db_length = dbResultSet.length;
          print(db_length);
          if (db_length > 1) {
            print("1.4.RUNNING?!");
            await FirebaseFirestore.instance
                .collection("Products")
                .where('Keys', arrayContainsAny: dbResultSet)
                .get()
                .then((querySnapshot) => {
                      for (int i = 0; i < querySnapshot.docs.length; i++)
                        {
                          //tempSearchStore.add(querySnapshot.docs.elementAt(i).data()),
                          setState(() {
                            discoverStore
                                .add(querySnapshot.docs.elementAt(i).data());
                            //print("From:");
                            //print(discoverStore[i]);
                          })
                        }
                    });

            await FirebaseFirestore.instance
                .collection("Businesses")
                .where('SearchKey', arrayContainsAny: dbResultSet)
                .get()
                .then((querySnapshot) => {
                      for (int i = 0; i < querySnapshot.docs.length; i++)
                        {
                          //tempSearchStore.add(querySnapshot.docs.elementAt(i).data()),
                          setState(() {
                            discoverStore
                                .add(querySnapshot.docs.elementAt(i).data());
                            //print("From:");
                            //print(discoverStore[i]);
                          })
                        }
                    });
          } else {
            print("2.RUNNING?!");
            await FirebaseFirestore.instance
                .collection("Products")
                .get()
                .then((querySnapshot) => {
                      print("3.RUNNING?!"),
                      for (int i = 0; i < querySnapshot.docs.length; i++)
                        {
                          //tempSearchStore.add(querySnapshot.docs.elementAt(i).data()),
                          print(querySnapshot.docs
                              .elementAt(i)
                              .data()
                              .toString()),
                          setState(() {
                            discoverStore
                                .add(querySnapshot.docs.elementAt(i).data());
                            //print("From:");
                            //print(discoverStore[i]);
                          })
                        }
                    });

            await FirebaseFirestore.instance
                .collection("Businesses")
                .get()
                .then((querySnapshot) => {
                      print("4.RUNNING?!"),
                      for (int i = 0; i < querySnapshot.docs.length; i++)
                        {
                          //tempSearchStore.add(querySnapshot.docs.elementAt(i).data()),
                          print(querySnapshot.docs
                              .elementAt(i)
                              .data()
                              .toString()),
                          setState(() {
                            discoverStore
                                .add(querySnapshot.docs.elementAt(i).data());
                            //print("From:");
                            //print(discoverStore[i]);
                          })
                        }
                    });
          }
        });
      } else {
        print("2.RUNNING?!");
        await FirebaseFirestore.instance
            .collection("Products")
            .get()
            .then((querySnapshot) => {
                  print("3.RUNNING?!"),
                  for (int i = 0; i < querySnapshot.docs.length; i++)
                    {
                      //tempSearchStore.add(querySnapshot.docs.elementAt(i).data()),
                      print(querySnapshot.docs.elementAt(i).data().toString()),
                      setState(() {
                        discoverStore
                            .add(querySnapshot.docs.elementAt(i).data());
                        //print("From:");
                        //print(discoverStore[i]);
                      })
                    }
                });

        await FirebaseFirestore.instance
            .collection("Businesses")
            .get()
            .then((querySnapshot) => {
                  print("4.RUNNING?!"),
                  for (int i = 0; i < querySnapshot.docs.length; i++)
                    {
                      //tempSearchStore.add(querySnapshot.docs.elementAt(i).data()),
                      print(querySnapshot.docs.elementAt(i).data().toString()),
                      setState(() {
                        discoverStore
                            .add(querySnapshot.docs.elementAt(i).data());
                        //print("From:");
                        //print(discoverStore[i]);
                      })
                    }
                });
      }
    });
  }

  Future getPageInfo() async {
    //return this._memoizer.runOnce(() async
    //{
    print(_selections[0]);
    print(_selections[1]);
    tempSearchStore = [];
    followStore = [];
    allUsers = [];
    allUsersName = [];
    //bool loggedIn = false;
    var user_ID;
    if (await FirebaseAuth.instance.currentUser != null) {
      loGGED_IN = true;
      user_ID = FirebaseAuth.instance.currentUser.uid;
    }

    if (_selections[0] && db_length > 1 && loGGED_IN) {
      discoverStore = [];
      var ref = await FirebaseDatabase.instance
          .reference()
          .child('Customers/$user_ID/Searches/');
      ref.once().then((DataSnapshot snapshot) async {
        dbResultSet = snapshot.value.keys.cast<String>().toList();

        await FirebaseFirestore.instance
            .collection("Products")
            .where('Keys', arrayContainsAny: dbResultSet)
            .get()
            .then((querySnapshot) => {
                  for (int i = 0; i < querySnapshot.docs.length; i++)
                    {
                      //tempSearchStore.add(querySnapshot.docs.elementAt(i).data()),
                      setState(() {
                        title = "Discover";
                        discoverStore
                            .add(querySnapshot.docs.elementAt(i).data());
                        //print("From:");
                        //print(discoverStore[i]);
                      })
                    }
                });

        await FirebaseFirestore.instance
            .collection("Businesses")
            .where('SearchKey', arrayContainsAny: dbResultSet)
            .get()
            .then((querySnapshot) => {
                  for (int i = 0; i < querySnapshot.docs.length; i++)
                    {
                      //tempSearchStore.add(querySnapshot.docs.elementAt(i).data()),
                      setState(() {
                        discoverStore
                            .add(querySnapshot.docs.elementAt(i).data());
                        //print("From:");
                        //print(discoverStore[i]);
                      })
                    }
                });
      });
    } else if (_selections[1] && loGGED_IN) {
      discoverStore = [];
      print("FOLLOWING PAGE RUNNING");
      var ref = FirebaseDatabase.instance
          .reference()
          .child('Customers/$user_ID/Following/');
      await ref.once().then((DataSnapshot snapshot) async {
        dbResultSet = snapshot.value.keys.cast<String>().toList();
        fol_len = dbResultSet.length;
        print("GOT FOLLOWERS");

        var reff = FirebaseDatabase.instance.reference().child('Customers/');
        await reff.once().then((DataSnapshot snapshot) async {
          List<String> all = snapshot.value.keys.cast<String>().toList();
          for (int index = 0; index < fol_len; index++) {
            if (all.contains(dbResultSet[index]))
              all.remove(dbResultSet[index]);
          }

          if (all.contains(user_ID)) all.remove(user_ID);

          setState(() {
            allUsers = all;
          });

          for (int ind = 0; ind < all.length; ind++) {
            await FirebaseFirestore.instance
                .collection("Users")
                .doc(all[ind])
                .get()
                .then((querySnapshot) => {
                      print("CURRent:" + querySnapshot.data().toString()),
                      //tempSearchStore.add(querySnapshot.data()),

                      setState(() {
                        allUsersName.add(querySnapshot.data());
                      })
                    });
          }
          print("CURRENTLY:" + allUsersName[1]['Name']);

          if (fol_len > 1) {
            for (int i = 0; i < fol_len; i++) {
              var currfol = dbResultSet[i];
              print("CURR FOLLOWER:" + currfol);
              var ref1 = FirebaseDatabase.instance
                  .reference()
                  .child('Customers/$currfol/Boards/');
              await ref1.once().then((DataSnapshot snapshot) async {
                var dbResultSetBoards =
                    snapshot.value.keys.cast<String>().toList();
                var num_boards = dbResultSetBoards.length;
                print("GOT BOARDS");

                for (int j = 0; j < num_boards; j++) {
                  var currBoard = dbResultSetBoards[j];
                  print("CURR BOARD:" + currBoard);
                  var ref2 = FirebaseDatabase.instance
                      .reference()
                      .child('Customers/$currfol/Boards/$currBoard/Product');
                  print("CURR REF:" + ref1.toString());
                  await ref2.once().then((DataSnapshot snapshot) async {
                    print("PRODS:" + snapshot.value.keys.toString());
                    var dbResultSetProds =
                        snapshot.value.keys.cast<String>().toList();
                    var num_pins = dbResultSetProds.length;
                    print("GOT PROD PINS");

                    //tempSearchStore = [];
                    for (int k = 0; k < num_pins; k++) {
                      print("Current try:" + dbResultSetProds[k]);
                      if (dbResultSetProds[k] != "default") {
                        await FirebaseFirestore.instance
                            .collection("Products")
                            .doc(dbResultSetProds[k])
                            .get()
                            .then((querySnapshot) => {
                                  print("CURR PROD:" +
                                      querySnapshot.data().toString()),
                                  //tempSearchStore.add(querySnapshot.data()),
                                  setState(() {
                                    title = "Folllowing";
                                    discoverStore.add(querySnapshot.data());
                                    //print("From:");
                                    //print(discoverStore[k]);
                                  })
                                });
                      }
                    }
                    //tempSearchStore = [];
                  });

                  var ref3 = FirebaseDatabase.instance
                      .reference()
                      .child('Customers/$currfol/Boards/$currBoard/Business');
                  await ref3.once().then((DataSnapshot snapshot) async {
                    print("BUS:" + snapshot.value.keys.toString());
                    var dbResultSetProds =
                        snapshot.value.keys.cast<String>().toList();
                    var num_pins = dbResultSetProds.length;
                    print("GOT BUS PINS");

                    for (int k = 0; k < num_pins; k++) {
                      print("Current try:" + dbResultSetProds[k]);
                      if (dbResultSetProds[k] != "default") {
                        await FirebaseFirestore.instance
                            .collection("Businesses")
                            .doc(dbResultSetProds[k])
                            .get()
                            .then((querySnapshot) => {
                                  print("CURR PROD:" +
                                      querySnapshot.data().toString()),
                                  //tempSearchStore.add(querySnapshot.data()),
                                  setState(() {
                                    discoverStore.add(querySnapshot.data());
                                    //print("From:");
                                    //print(discoverStore[k]);
                                  })
                                });
                      }
                    }
                    //tempSearchStore = [];
                  });
                }
              });
            }
          }
        });
      });
    } else {
      await FirebaseFirestore.instance
          .collection("Products")
          .get()
          .then((querySnapshot) => {
                print("3.RUNNING?!"),
                for (int i = 0; i < querySnapshot.docs.length; i++)
                  {
                    //tempSearchStore.add(querySnapshot.docs.elementAt(i).data()),
                    print(querySnapshot.docs.elementAt(i).data().toString()),
                    setState(() {
                      discoverStore.add(querySnapshot.docs.elementAt(i).data());
                      //print("From:");
                      //print(discoverStore[i]);
                    })
                  }
              });

      await FirebaseFirestore.instance
          .collection("Businesses")
          .get()
          .then((querySnapshot) => {
                print("4.RUNNING?!"),
                for (int i = 0; i < querySnapshot.docs.length; i++)
                  {
                    //tempSearchStore.add(querySnapshot.docs.elementAt(i).data()),
                    print(querySnapshot.docs.elementAt(i).data().toString()),
                    setState(() {
                      discoverStore.add(querySnapshot.docs.elementAt(i).data());
                      //print("From:");
                      //print(discoverStore[i]);
                    })
                  }
              });
    }
  }

  Widget _followingBar() {
    print("FOLLOWING RUN");
    //if (fol_len!=0 && _selections[1])
    //{
    print("FOLLOWING RUN123");
    return Column(children: [
      Text('Follow Suggestions:',
          textAlign: TextAlign.left,
          style: TextStyle(
              decorationStyle: TextDecorationStyle.double,
              fontWeight: FontWeight.w300,
              fontSize: 20)),
      Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.all(2),
          padding: EdgeInsets.all(2),
          height: 120,
          child: ListView.builder(
              shrinkWrap: true,
              //itemCount: 10,
              scrollDirection: Axis.horizontal,
              itemCount: allUsersName.length,
              itemBuilder: (context, int i) {
                print(i);
                return new Card(
                    clipBehavior: Clip.antiAlias,
                    child: new Row(children: <Widget>[
                      new OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Follow(
                                  followID: allUsers[i],
                                  followName: allUsersName[i]['Name'])));
                        },
                        child: new ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                          child: new Image(
                            image: AssetImage('assets/user.png'),
                            height: 40.0,
                            width: 30.0,
                            //height: 315,
                            //width: 3150,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      new Text(allUsersName[i]['Name'],
                          softWrap: true,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 22))
                    ]));
              })
          //.toList())
          )
    ]);
    //}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(20),
            child: ToggleButtons(
              children: <Widget>[
                Icon(Icons.public),
                Icon(Icons.person),
              ],
              isSelected: _selections,
              onPressed: (int index) {
                setState(() {
                  for (int buttonIndex = 0;
                      buttonIndex < _selections.length;
                      buttonIndex++) {
                    if (buttonIndex == index) {
                      print(buttonIndex);
                      _selections[buttonIndex] = true;
                    } else {
                      print(buttonIndex);
                      _selections[buttonIndex] = false;
                    }
                  }
                  getPageInfo();
                });
              },
            ),
          ),
          (fol_len != 0 && _selections[1])
              ? Container(height: 150, child: _followingBar())
              : Container(width: 0.0, height: 0.0),
          (_selections[1] && loGGED_IN && fol_len == 1)
              ? Card(
                  clipBehavior: Clip.antiAlias,
                  child: Text('Add Followers To See Their Pins Displayed Here',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20)))
              : (_selections[1] && !loGGED_IN)
                  ? Card(
                      clipBehavior: Clip.antiAlias,
                      child: Text('Make An Account To Use This Page',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20)))
                  : FutureBuilder(
                      future: initially(),
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            discoverStore.isNotEmpty) {
                          return Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.all(2),
                              padding: EdgeInsets.all(2),
                              child: GridView.count(
                                  padding:
                                      EdgeInsets.only(left: 4.0, right: 4.0),
                                  crossAxisCount: 1,
                                  crossAxisSpacing: 4.0,
                                  mainAxisSpacing: 4.0,
                                  primary: false,
                                  shrinkWrap: true,
                                  children: discoverStore.map((element) {
                                    return buildResultCard(element);
                                  }).toList()));
                        } //else {
                        return Center(child: CircularProgressIndicator());
                        //}
                      }),
        ],
      ),
    );
  }
}
