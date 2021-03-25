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
  String _email,
      _password,
      _description,
      _bizName,
      _website,
      _addy1,
      _addy2,
      _city,
      _state,
      _zip;
  final auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;

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
          TextField(
            decoration: InputDecoration(hintText: "Address Line 1"),
            onChanged: (value) {
              setState(() {
                _addy1 = value.trim();
              });
            },
          ),
          TextField(
            decoration: InputDecoration(hintText: "Address Line 2"),
            onChanged: (value) {
              setState(() {
                _addy2 = value.trim();
              });
            },
          ),
          TextField(
            decoration: InputDecoration(hintText: "City/Town"),
            onChanged: (value) {
              setState(() {
                _city = value.trim();
              });
            },
          ),
          TextField(
            decoration: InputDecoration(hintText: "State"),
            onChanged: (value) {
              setState(() {
                _state = value.trim();
              });
            },
          ),
          TextField(
            decoration: InputDecoration(hintText: "Zip Code"),
            onChanged: (value) {
              setState(() {
                _zip = value.trim();
              });
            },
          ),
          RaisedButton(
            child: Text("Select All That Apply"),
            onPressed: () => _showReportDialog(),
          ),
          Row(
            children: [
              RaisedButton(
                  child: Text("Sign Up"),
                  onPressed: () {
                    auth.createUserWithEmailAndPassword(
                        email: _email, password: _password);

                    //Add Business Information
                    //var firebaseUser = FirebaseAuth.instance.currentUser;
                    firestoreInstance.collection("Businesses").add({
                      "Description": _description,
                      "Name": _bizName,
                      "Wesbite": _website,
                      "Address": (_addy1 + _addy2 + _city + _state + _zip),
                    }).then((value) {
                      print("success!");
                      print(value.id);
                    });
                  }

                  //Add User Information

                  //Will need to create a business doc in firebase for them

                  //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()))
                  )
            ],
          )
        ],
      ),
    );
  }
}

//Code for Creating the Select Menu
class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  MultiSelectChip(this.reportList);
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  String selectedChoice =
      ""; // this function will build and return the choice list
  _buildChoiceList() {
    List<Widget> choices = List();
    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: selectedChoice == item,
          onSelected: (selected) {
            setState(() {
              selectedChoice = item;
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}

List<String> reportList = ["Black Owned", "Woman Owned", "EcoFriendly"];

_showReportDialog() {
  showDialog(
      //context: context,
      builder: (BuildContext context) {
    //Here we will build the content of the dialog
    return AlertDialog(
      title: Text("Report Video"),
      content: MultiSelectChip(reportList),
      actions: <Widget>[
        FlatButton(
          child: Text("Report"),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  });
}
