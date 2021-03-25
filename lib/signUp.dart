import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/outline_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

//None of this is done

class SignUp extends StatelessWidget {
  SignUp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Login App",
      theme: ThemeData(accentColor: Colors.orange, primarySwatch: Colors.blue),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email, _password, _description, _bizName, _website;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(hintText: "Email"),
            onChanged: (value) {
              setState(() {
                _email = value.trim();
              });
            },
          ),
          TextField(
            decoration: InputDecoration(hintText: "Password"),
            onChanged: (value) {
              setState(() {
                _password = value.trim();
              });
            },
          ),
          TextField(
            decoration: InputDecoration(hintText: "Business Name"),
            onChanged: (value) {
              setState(() {
                _bizName = value.trim();
              });
            },
          ),
          TextField(
            decoration: InputDecoration(hintText: "Buisiness Description"),
            onChanged: (value) {
              setState(() {
                _description = value.trim();
              });
            },
          ),
          TextField(
            decoration: InputDecoration(hintText: "Website URL"),
            onChanged: (value) {
              setState(() {
                _website = value.trim();
              });
            },
          ),
          Row(
            children: [
              RaisedButton(
                  child: Text("Sign In"),
                  onPressed: () {
                    auth.signInWithEmailAndPassword(
                        email: _email, password: _password);
                    //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()))
                  }),
              RaisedButton(
                  child: Text("Sign Up"),
                  onPressed: () {
                    auth.createUserWithEmailAndPassword(
                        email: _email, password: _password);
                    //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()))
                  })
            ],
          )
        ],
      ),
    );
  }
}
