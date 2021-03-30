//this is just a copy of businesspage we can work off of

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class businesspage extends StatefulWidget {
  var business;

  businesspage({Key key, @required this.business}) : super(key: key);

  @override
  _businesspageState createState() => _businesspageState(business);
}

class _businesspageState extends State<businesspage> {
  var business;
  var count;
  _businesspageState(this.business);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(business['Name']),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 175,
                child: Image(
                  image: NetworkImage(business['Image']),
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    business['Name'],
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )),
              SizedBox(
                height: 5,
              ),
              Divider(
                color: Colors.black,
                height: 10,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Bio: ${business['Description']}',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Divider(
                color: Colors.black,
                height: 10,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Address: ${business['Address']['Line 1']}, \r\n ${business['Address']['City']}, ${business['Address']['State']}, ${business['Address']['Zip Code']} ',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Divider(
                color: Colors.black,
                height: 10,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: new InkWell(
                  child: new Text(
                    'Business Website',
                    style: TextStyle(fontSize: 20, color: Colors.pinkAccent),
                  ),
                  onTap: () => launch(business['Website']),
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.symmetric(vertical: 20.0),
                height: 150.0,
                child: SizedBox(
                  child: new ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: business['ImageCount'],
                    itemBuilder: (BuildContext context, int index) =>
                        new Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Image(
                          image: NetworkImage(
                              business['Image${(index + 1).toString()}'])),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}