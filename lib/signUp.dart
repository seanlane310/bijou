import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/outline_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:bijou/nav.dart';
//Potentially needs to be removed
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_database/firebase_database.dart';

class GlobalVariables {
  String _userFirestoreDocumentID = "";
}

class SignUp extends StatelessWidget {
  SignUp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Login App",
      theme: ThemeData(accentColor: Colors.orange, primarySwatch: Colors.blue),
      home: SelectLoginScreen(),
    );
  }
}

//SELECT CUSTOMER OR BUSINESS FOR SIGNUP
class SelectLoginScreen extends StatefulWidget {
  @override
  _SelectLoginScreenState createState() => _SelectLoginScreenState();
}

class _SelectLoginScreenState extends State<SelectLoginScreen> {
  //Widgets
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlineButton(
              borderSide: BorderSide(
                color: Colors.purple,
              ),
              child: new Text("Business Owner"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BusinessLoginScreen()));
              },
            ),
            OutlineButton(
              borderSide: BorderSide(
                color: Colors.purple,
              ),
              child: new Text("Customer"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CustomerLoginScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

//BUSINESS SIGN UP PAGE
class BusinessLoginScreen extends StatefulWidget {
  @override
  _BusinessLoginScreenState createState() => _BusinessLoginScreenState();
}

class _BusinessLoginScreenState extends State<BusinessLoginScreen> {
  String _email = "";
  String _password = "";
  String _description = "";
  String _bizName = "";
  String _website = "";
  String _addy1 = "";
  String _addy2 = "";
  String _city = "";
  String _state = "";
  String _zip = "";
  String _businessFirestoreDocumentID = "";
  double _long, _lat;
  bool _blackOwned = false;
  bool _womanOwned = false;
  bool _sustainable = false;
  final auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    setState(() {
      firestoreInstance.collection("BusinessesTest").doc().set({
        "useful": "no",
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: SizedBox.expand(
        child: DraggableScrollableSheet(
          builder: (BuildContext context, ScrollController scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              //color: Colors.blue[100],
              child: Column(
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
                    decoration:
                        InputDecoration(hintText: "Buisiness Description"),
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
                  /*
                  TextField(
                    decoration:
                        InputDecoration(hintText: "GeoLocation Longitude"),
                    onChanged: (value) {
                      setState(() {
                        var _long = double.parse(value);
                        assert(_long is double);
                      });
                    },
                  ),
                  TextField(
                    decoration:
                        InputDecoration(hintText: "GeoLocation Latitude"),
                    onChanged: (value) {
                      setState(() {
                        var _lat = double.parse(value);
                        assert(_lat is double);
                      });
                    },
                  ),
                  */
                  Text("Select All That Apply"),
                  //Contains the Buttons for all the options of badges
                  Row(
                    children: [
                      RaisedButton(
                          child: Text("Black Owned"),
                          onPressed: () {
                            _blackOwned = true;
                          }),
                      RaisedButton(
                          child: Text("Woman Owned"),
                          onPressed: () {
                            _womanOwned = true;
                          }),
                      RaisedButton(
                          child: Text("Eco-Friendly"),
                          onPressed: () {
                            _sustainable = true;
                          }),
                    ],
                  ),
                  Row(
                    children: [
                      RaisedButton(
                          child: Text("Sign Up"),
                          onPressed: () async {
                            auth.createUserWithEmailAndPassword(
                                email: _email, password: _password);

                            //Add Business Information
                            //var firebaseUser = FirebaseAuth.instance.currentUser;
                            firestoreInstance
                                .collection("BusinessesTest")
                                .doc(auth.currentUser.uid)
                                .set({
                              "Description": _description,
                              "Name": _bizName,
                              "Website": _website,
                              "Address": {
                                "Line 1": _addy1,
                                "Line 2": _addy2,
                                "City": _city,
                                "State": _state,
                                "Zip Code": _zip,
                              },
                              "Tags": [],
                              "SearchKey": [],
                              "Blackowned": _blackOwned,
                              "Womanowned": _womanOwned,
                              "Ecofriendly": _sustainable,
                              "iD": auth.currentUser.uid,
                            }).then((value) {
                              print("WRITTEN");
                            });

                            FirebaseDatabase.instance
                                .reference()
                                .child('Customers' +
                                    '/' +
                                    auth.currentUser.uid +
                                    '/Boards/Bijou Favorites/Business')
                                .set({'Jre5332CuksbCc6gBYYW': 'true'});

                            FirebaseDatabase.instance
                                .reference()
                                .child('Customers' +
                                    '/' +
                                    auth.currentUser.uid +
                                    '/Boards/Bijou Favorites/Products')
                                .set({'WtbPhlMYCSvga34e9Xlr': 'true'});

                            FirebaseDatabase.instance
                                .reference()
                                .child('Customers' +
                                    '/' +
                                    auth.currentUser.uid +
                                    '/Searches')
                                .set({'Bijou': 'true'});

                            FirebaseDatabase.instance
                                .reference()
                                .child('Customers' +
                                    '/' +
                                    auth.currentUser.uid +
                                    '/Following')
                                .set({'lnlIpcV2MYWyhIg7eGSMTnIiszX2': 'true'});

                            //Return to the discover page
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BusinessPhotoUploadScreen(
                                          businessFirestoreDocumentID:
                                              auth.currentUser.uid,
                                          currbizName: _bizName,
                                        )));
                          })
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

//Logging Products for a Business Registering
class LogProductsScreen extends StatefulWidget {
  String currbizName;

  LogProductsScreen({@required this.currbizName});

  @override
  _LogProductsScreenState createState() => _LogProductsScreenState(currbizName);
}

class _LogProductsScreenState extends State<LogProductsScreen> {
  //Variable Declaration
  String _productName = "";
  final firestoreInstance = FirebaseFirestore.instance;
  List<String> _keys;
  String currbizName;

  _LogProductsScreenState(this.currbizName);

  //Widgets
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                  "Optional: Please Input The Products Your Business Carries:"),
              TextField(
                decoration: InputDecoration(hintText: "Product Name"),
                onChanged: (value) {
                  setState(() {
                    _productName = value.trim();
                  });
                },
              ),
              Row(
                children: [
                  OutlineButton(
                      borderSide: BorderSide(
                        color: Colors.purple,
                      ),
                      child: new Text("Enter"),
                      onPressed: () {
                        print(currbizName);

                        firestoreInstance.collection("Products").add({
                          "Name": _productName,
                          "Type": "Product",
                          "Keys": [],
                          "Business Name": currbizName,
                        }).then(
                          (value) {
                            firestoreInstance
                                .collection("Products")
                                .doc(value.id)
                                .set({
                              "iD": value.id,
                            }, SetOptions(merge: true)).then((_) {
                              print("success");
                            });
                          },
                        );
                      }),
                  OutlineButton(
                      borderSide: BorderSide(
                        color: Colors.purple,
                      ),
                      child: new Text("Finished"),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Nav())); //Literally fix this
                      })
                ],
              ),
            ]),
      ),
    );
  }
}

//UPLOADING PHOTOS FOR A BUSINESS

class BusinessPhotoUploadScreen extends StatefulWidget {
  String businessFirestoreDocumentID;
  String currbizName;

  BusinessPhotoUploadScreen(
      {@required this.businessFirestoreDocumentID, @required this.currbizName});

  @override
  _BusinessPhotoUploadScreenState createState() =>
      _BusinessPhotoUploadScreenState(businessFirestoreDocumentID, currbizName);
}

class _BusinessPhotoUploadScreenState extends State<BusinessPhotoUploadScreen> {
  String businessFirestoreDocumentID;
  //Variables
  File _image; // Used only if you need a single picture
  final firestoreInstance = FirebaseFirestore.instance;
  GlobalVariables globals;
  String _uploadedFileURL;
  String currbizName;

//Functions
  _BusinessPhotoUploadScreenState(
      this.businessFirestoreDocumentID, this.currbizName);

  Future<void> saveImages(List<File> _images, DocumentReference ref) async {
    _images.forEach((image) async {
      String imageURL = await uploadFile(image);
      ref.update({
        "images": FieldValue.arrayUnion([imageURL])
      });
    });
  }

  Future<File> getImage(bool gallery) async {
    //PickedFile pickedFile;
    File pickedFile;
    // Let user select photo from gallery
    if (gallery) {
      pickedFile = await ImagePicker.pickImage(
        source: ImageSource.gallery,
      );
    }
    // Otherwise open camera to get new photo
    else {
      pickedFile = await ImagePicker.pickImage(
        source: ImageSource.camera,
      );
    }

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path); // Use if you only need a single picture
      } else {
        print('No image selected.');
      }
    });

    return pickedFile;
  }

  Future uploadFile(File _image) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference imageRef = storage
        .ref()
        .child("Users/" + businessFirestoreDocumentID + "/profileImage");
    UploadTask uploadTask = imageRef.putFile(_image);
    var imageUrl = await (await uploadTask).ref.getDownloadURL();
    var url = imageUrl.toString();
    print(url);

    //write URL of profile photo to user's document in firebase

    //write URL of profile photo to business's document in firebase
    firestoreInstance
        .collection("BusinessTest")
        .doc(businessFirestoreDocumentID)
        .set({
      "ImageCount": 1,
      "ImageURL": url,
    });

    return url;
  }

  //Upload photos for a business page
  //Widgets

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Business Image Upload'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text('Select an Image of Your Business'),
            _image != null
                ? Image.file(
                    _image,
                    height: 150,
                  )
                : Container(height: 150),
            _image == null
                ? RaisedButton(
                    child: Text('Choose Image'),
                    onPressed: () async {
                      _image = await getImage(true);
                    },
                    color: Colors.cyan,
                  )
                : Container(),
            _image == null
                ? RaisedButton(
                    child: Text('Take Photo'),
                    onPressed: () async {
                      _image = await getImage(false);
                    },
                    color: Colors.cyan,
                  )
                : Container(),
            _image != null
                ? RaisedButton(
                    child: Text('Upload File'),
                    onPressed: () async {
                      uploadFile(_image);

                      print(currbizName);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LogProductsScreen(
                                    currbizName: currbizName,
                                  )));
                    },
                    color: Colors.cyan,
                  )
                : Container(),
            /*
            Text('Uploaded Image'),
            _uploadedFileURL != null
                ? Image.network(
                    _uploadedFileURL,
                    height: 150,
                  )
                : Container(),
                */
          ],
        ),
      ),
    );
  }
}

//CUSTOMER SIGNUP PAGE
class CustomerLoginScreen extends StatefulWidget {
  @override
  _CustomerLoginScreenState createState() => _CustomerLoginScreenState();
}

class _CustomerLoginScreenState extends State<CustomerLoginScreen> {
  //Variable Declarations
  String _email = "";
  String _password = "";
  String _name = "";
  final auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  String _userFirestoreDocumentID;

  @override
  void initState() {
    super.initState();
    setState(() {
      firestoreInstance.collection("BusinessesTest").doc().set({
        "useful": "no",
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: SizedBox.expand(
        child: DraggableScrollableSheet(
          builder: (BuildContext context, ScrollController scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              //color: Colors.blue[100],
              child: Column(
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
                    decoration: InputDecoration(hintText: "Display Name"),
                    onChanged: (value) {
                      setState(() {
                        _name = value.trim();
                      });
                    },
                  ),
                  Row(
                    children: [
                      RaisedButton(
                          child: Text("Sign Up"),
                          onPressed: () async {
                            //Authenticate the User
                            auth.createUserWithEmailAndPassword(
                                email: _email, password: _password);

                            firestoreInstance
                                .collection("Users")
                                .doc(auth.currentUser.uid)
                                .set({
                              "Name": _name,
                              "iD": auth.currentUser.uid,
                            }).then((value) {
                              print("WRITTEN");
                            });

                            await FirebaseDatabase.instance
                                .reference()
                                .child('Customers' +
                                    '/' +
                                    auth.currentUser.uid +
                                    '/Boards')
                                .set({'default': 'true'});

                            await FirebaseDatabase.instance
                                .reference()
                                .child('Customers' +
                                    '/' +
                                    auth.currentUser.uid +
                                    '/Searches')
                                .set({'Bijou': 'true'});

                            await FirebaseDatabase.instance
                                .reference()
                                .child('Customers' +
                                    '/' +
                                    auth.currentUser.uid +
                                    '/Following')
                                .set({'lnlIpcV2MYWyhIg7eGSMTnIiszX2': 'true'});

                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProfilePhotoUploadScreen(
                                          email: _email,
                                          currUserId: auth.currentUser.uid,
                                        )));
                          })
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

//PROFILE PICTURE UPLOAD
class ProfilePhotoUploadScreen extends StatefulWidget {
  var email;
  String currUserId;

  ProfilePhotoUploadScreen(
      {Key key, @required this.email, @required this.currUserId})
      : super(key: key);

  @override
  _ProfilePhotoUploadScreenState createState() =>
      _ProfilePhotoUploadScreenState(email, currUserId);
}

class _ProfilePhotoUploadScreenState extends State<ProfilePhotoUploadScreen> {
  //Allow Users to upload a profile photo
  //Variables
  File _image; // Used only if you need a single picture
  final picker = ImagePicker();
  final firestoreInstance = FirebaseFirestore.instance;
  GlobalVariables globals;
  String _uploadedFileURL;
  var userFirestoreDocumentID;
  var email;
  var loading;
  String currUserId;

  _ProfilePhotoUploadScreenState(this.email, this.currUserId);

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
      print("User ID: " + currUserId);
      loading = false;
      //createDocument(email);
    });
  }

/*
  createDocument(email) {
    DocumentReference ref =
        FirebaseFirestore.instance.collection('Users').doc();
    ref.set({
      "Business ID": "no",
      "Email": email,
      "DocID": ref.id,
    }).then((value) {
      setState(() {
        userFirestoreDocumentID = ref.id;
        loading = false;
      });
    });
  }
  */

//Functions
  // Future<void> saveImages(List<File> _images, DocumentReference ref) async {
  //   _images.forEach((image) async {
  //     String imageURL = await uploadFile(image, );
  //     ref.update({
  //       "images": FieldValue.arrayUnion([imageURL])
  //     });
  //   });
  // }

  Future<File> getImage(bool gallery) async {
    //PickedFile pickedFile;
    File pickedFile;
    // Let user select photo from gallery
    if (gallery) {
      pickedFile = await ImagePicker.pickImage(
        source: ImageSource.gallery,
      );
    }
    // Otherwise open camera to get new photo
    else {
      pickedFile = await ImagePicker.pickImage(
        source: ImageSource.camera,
      );
    }

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path); // Use if you only need a single picture
      } else {
        print('No image selected.');
      }
    });

    return pickedFile;
  }

  // Future uploadFile(File _image, userDocID) async {
  Future uploadFile(File _image) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference imageRef =
        storage.ref().child("Users/" + currUserId + "/profileImage");
    UploadTask uploadTask = imageRef.putFile(_image);
    var imageUrl = await (await uploadTask).ref.getDownloadURL();
    var url = imageUrl.toString();
    print(url);

    //write URL of profile photo to user's document in firebase
  }

//Widgets

  @override
  Widget build(BuildContext context) {
    if (loading)
      return CircularProgressIndicator();
    else
      return Scaffold(
        appBar: AppBar(
          title: Text('Profile Photo'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text('Selected Image'),
              _image != null
                  ? Image.file(
                      _image,
                      height: 150,
                    )
                  : Container(height: 150),
              _image == null
                  ? RaisedButton(
                      child: Text('Choose Image'),
                      onPressed: () async {
                        _image = await getImage(true);
                      },
                      color: Colors.pinkAccent,
                    )
                  : Container(),
              _image == null
                  ? RaisedButton(
                      child: Text('Take Photo'),
                      onPressed: () async {
                        _image = await getImage(false);
                      },
                      color: Colors.pinkAccent,
                    )
                  : Container(),
              _image != null
                  ? RaisedButton(
                      child: Text('Upload File'),
                      onPressed: () async {
                        print(userFirestoreDocumentID);
                        // uploadFile(_image, userFirestoreDocumentID);
                        uploadFile(_image);

                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Nav()));
                      },
                      color: Colors.pinkAccent,
                    )
                  : Container(),
            ],
          ),
        ),
      );
  }
}
