import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:async/async.dart';
import 'package:bijou/productpage.dart';
import 'package:bijou/businesspagedisc.dart';
import 'package:firebase_auth/firebase_auth.dart';
//when connect auth:
//final FirebaseUser user = await _firebaseAuth.currentUser();
//return await FirebaseDatabase.instance.reference().child('user').equalTo(user.uid);

class Boards extends StatefulWidget {
  Boards({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _BoardsState createState() => _BoardsState();
}

class _BoardsState extends State<Boards> {
  bool start = true;
  List<bool> _selections = List.generate(2, (int index) => !(index==1));
  List<String> dbResultSet;
  List<String> boards;
  List<String> products;
  List<String> businesses;
  var numPins = [];
  int index = -1;
  bool loggedIn = false;
  
  //var tempSearchStore = [];
  var discoverStore = [];
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  Widget buildResultCard(data) {
  //List<String> boards;
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  final _formKey = GlobalKey<FormState>();
  var textValue = "";
  
  print("DATA:"+data.toString());
  //for (int i = 0; i<boards.length; i++)
  return Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                Text(data,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                OutlinedButton(
                  onPressed: () {},
                  child:
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
                    child: Image.network(data['Image'],
                        //height: 315,
                        //width: 3150,
                        fit:BoxFit.contain,
                    ),
                ),
            )
          ]
      ));          
}


  Future initially() async 
  {
    return this._memoizer.runOnce(() async 
    {
      if (await FirebaseAuth.instance.currentUser != null) 
      {
        var userID = FirebaseAuth.instance.currentUser.uid;
        loggedIn = true;

        var ref0 = FirebaseDatabase.instance.reference().child('Customers/$userID/Boards/');
        print("IS THIS RUNNING?");
        await ref0.once().then((DataSnapshot snapshot) async 
        {
          var boardsTemp = snapshot.value.keys.cast<String>().toList();
          print("IS THIS RUNNING?");
          setState(() {
            print("IS THIS RUNNING?");
            print(snapshot.value.keys);
            boards = boardsTemp;
            print("BOARDS123:"+ boards.toString());
          });
        });

        print("BOARDS:"+ boards.toString());

        for (int i = 0; i< boards.length; i++)
        {
          var curr_board = boards[i];
          setState(() {
            products = [];
            businesses = [];
          });
          
          var ref = FirebaseDatabase.instance.reference().child('Customers/$userID/Boards/$curr_board/Product');
          await ref.once().then((DataSnapshot snapshot) async 
          {
            var prodTemp = snapshot.value.keys.cast<String>().toList();
            if (prodTemp.contains("default"))
              prodTemp.remove("default");
            setState(() {
              products = prodTemp;
            });
          });

          print("PRODUCTS:"+ products.toString());

          var ref1 = FirebaseDatabase.instance.reference().child('Customers/$userID/Boards/$curr_board/Business');
          await ref1.once().then((DataSnapshot snapshot) async 
          {
            print("RUNNING??");
            List<String> busTemp = snapshot.value.keys.cast<String>().toList();
            if (busTemp.contains("default"))
              busTemp.remove("default");
            setState(() {
              businesses = busTemp;
              print("HELLO:" + businesses.toString());
              print("HELLO123:" + busTemp.length.toString());
              int numpins = products.length.toInt() + busTemp.length.toInt();
              print(numpins);
              numPins.add(numpins);
              //print("NUMPINS:"+ numPins.);
            });
          });

          print("BUS:"+ businesses.toString());

          for (int j = 0; j<products.length; j++)
          {
             if (products[j] != "default")
              {
                await FirebaseFirestore.instance.collection("Products").doc(products[j]).get().then((querySnapshot) => 
                {
                  print("CURR PROD:" + querySnapshot.data().toString() ),
                  setState(() {
                    discoverStore.add(querySnapshot.data());
                  })
                });
              }
          }

          for (int k = 0; k<businesses.length; k++)
          {
             if (businesses[k] != "default")
              {
                await FirebaseFirestore.instance.collection("Businesses").doc(businesses[k]).get().then((querySnapshot) => 
                {
                  print("CURR BUS:" + querySnapshot.data().toString() ),
                  setState(() {
                    discoverStore.add(querySnapshot.data());
                    print(discoverStore.toString());
                  })
                });
              }
          }
         


        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boards'),
      ),
      body: ListView(children: <Widget>[
        Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(20),
            child:
              Text('Your Boards',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
                          
        ),
      FutureBuilder(
      future: initially(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && discoverStore.isNotEmpty) {
          //for (int i=0; i<boards.length; i++)
          //{
            //var currBoard = boards[i];
            return Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(2),
                padding: EdgeInsets.all(2),
                child:ListView.builder(
                  //scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 4.0, right: 4.0),
                  itemCount: boards.length,
                  primary: false,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int ind) {
                  var currBoard = boards[ind];
                   return Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.all(2),
                    padding: EdgeInsets.all(2),
                    height:270,
                    child:
                    Column(
                      children: [
                    Text('$currBoard', textAlign: TextAlign.left, style: TextStyle(decorationStyle: TextDecorationStyle.double,fontWeight: FontWeight.w300, fontSize: 20)),
                    Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.all(2),
                    padding: EdgeInsets.all(2),
                    height:230,
                    child:
                    ListView.builder(
                      shrinkWrap: true,
                      //itemCount: 10,
                      scrollDirection: Axis.horizontal,
                      itemCount: numPins[ind],
                      itemBuilder: (context, int i) {
                        print("RUNNING?!:"+ i.toString());
                        print("NUMPINS:"+ numPins[ind].toString());
                        //print(discoverStore.sublist(index, (index+numPins[ind]-1) ).toString());
                        //setState(() => {
                        //(discoverStore.sublist(index, (index+numPins[ind]-1) )).map((element) {
                          //print(element.toString());
                          // index needs to be incremented
                          index = index + 1; 
                          print("CURR_INDEX:"+ index.toString());
                          //print("CURR_BOARD:"+ boards[ind]);
                          //return List.generate(numPins[ind], (index) {
                            return /*new Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.all(2),
                              padding: EdgeInsets.all(2),
                                child:*/
                                new Card(
                                clipBehavior: Clip.antiAlias,
                                child: new Column(
                                  children: <Widget>[
                                    new OutlinedButton(
                                      onPressed: () {
                                        if (discoverStore[index]['type'] == 'business')
                                        {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => businesspagedisc( business: discoverStore[index])));   
                                        }
                                        else if (discoverStore[index]['type'] == 'product')
                                        {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => productpage( product: discoverStore[index]))); 
                                        }
                                      },
                                      child:
                                      new ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8.0),
                                          topRight: Radius.circular(8.0),
                                        ),
                                        child: new Image.network(discoverStore[index]['Image'],
                                            height: 218.0,
                                            width: 230.0,
                                            //height: 315,
                                            //width: 3150,
                                            fit:BoxFit.contain,
                                        ),
                                    ),
                                  )
                                ])
                              );
                            })
                          //.toList())
                    )])
                    );
                  })
                );
        }
                 
          //}//else {
          return Center(
            child: CircularProgressIndicator()
          );
        //}
      }),
      ],)
  );
}
}

