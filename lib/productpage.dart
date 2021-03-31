import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class productpage extends StatefulWidget {
  var product;

  productpage({Key key, @required this.product}) : super(key: key);

  @override
  _productpageState createState() => _productpageState(product);
}

class _productpageState extends State<productpage> {
  var product;
  _productpageState(this.product);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(product['Name']),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 300,
                child: Image(
                  image: NetworkImage(product['Image']),
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    product['Name'],
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
                  'You can find this product at: ${product['Business Name']}',
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
                    'Product Website',
                    style: TextStyle(fontSize: 20, color: Colors.pinkAccent),
                  ),
                  onTap: () => launch(product['website']),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
