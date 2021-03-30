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
                          onPressed: () {
                            auth.createUserWithEmailAndPassword(
                                email: _email, password: _password);

                            //Add Business Information
                            //var firebaseUser = FirebaseAuth.instance.currentUser;
                            firestoreInstance.collection("BusinessesTest").add({
                              "Description": _description,
                              "Name": _bizName,
                              "Website": _website,
                              "Address": {
                                "Line 1": _addy1,
                                "Line 2": _addy2,
                                "City": _city,
                                "State": _state,
                                "Zip Code": _zip,
                                "Location": LatLng(_lat, _long),
                              },
                              "Blackowned": _blackOwned,
                              "Womanowned": _womanOwned,
                              "Ecofriendly": _sustainable,
                            }).then((value) {
                              _businessFirestoreDocumentID = value.id;
                              firestoreInstance
                                  .collection("BusinessesTest")
                                  .doc(value.id)
                                  .set({
                                "iD": value.id,
                              }, SetOptions(merge: true)).then((_) {
                                print("success!");
                              });
                            });

                            //Add User Information
                            firestoreInstance.collection("Users").add({
                              "Business ID": _businessFirestoreDocumentID,
                              "Search History": [],
                              "Email": _email,
                              "Type": "Business"
                            }).then((value) {
                              firestoreInstance
                                  .collection("Users")
                                  .doc(value.id)
                                  .set({
                                "iD": value.id,
                              }, SetOptions(merge: true)).then((_) {
                                print("success");
                              });
                            });

                            //Return to the discover page
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BusinessPhotoUploadScreen(
                                            businessFirestoreDocumentID:
                                                _businessFirestoreDocumentID)));
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
  @override
  _LogProductsScreenState createState() => _LogProductsScreenState();
}

class _LogProductsScreenState extends State<LogProductsScreen> {
  //Variable Declaration
  String _productName = "";
  final firestoreInstance = FirebaseFirestore.instance;
  List<String> _keys;

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
                        firestoreInstance.collection("Products").add({
                          "Name": _productName,
                          "Type": "Product",
                          "Keys": [],
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
                            });
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

  BusinessPhotoUploadScreen({@required this.businessFirestoreDocumentID});

  @override
  _BusinessPhotoUploadScreenState createState() =>
      _BusinessPhotoUploadScreenState(businessFirestoreDocumentID);
}

class _BusinessPhotoUploadScreenState extends State<BusinessPhotoUploadScreen> {
  String businessFirestoreDocumentID;
  //Variables
  File _image; // Used only if you need a single picture
  final firestoreInstance = FirebaseFirestore.instance;
  GlobalVariables globals;
  String _uploadedFileURL;

//Functions
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

  Future<String> uploadFile(File _image) async {
    Future<String> _url;
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref =
        storage.ref().child("Users/" + businessFirestoreDocumentID + "/");
    UploadTask uploadTask = ref.putFile(_image);
    uploadTask.then((res) {
      _url = res.ref.getDownloadURL();
    });

    //write URL of profile photo to business's document in firebase
    firestoreInstance
        .collection("BusinessTest")
        .doc(businessFirestoreDocumentID)
        .set({
      "ImageCount": 1,
      "ImageURL": _url,
    });

    return _url;
  }

  _BusinessPhotoUploadScreenState(businessFirestoreDocumentID);

  //Upload photos for a business page
  //Widgets

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore File Upload'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text('Selected Image'),
            _image != null
                ? Image.asset(
                    _image.path,
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
                      _uploadedFileURL = await uploadFile(_image);
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
  final auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  String _userFirestoreDocumentID;

  @override
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
                  Row(
                    children: [
                      RaisedButton(
                          child: Text("Sign Up"),
                          onPressed: () {
                            //Authenticate the User
                            auth.createUserWithEmailAndPassword(
                                email: _email, password: _password);

                            //ADD USER TO FIREBASE
                            firestoreInstance.collection("Users").add({
                              "Business ID": "no",
                              "Search History": [],
                              "Email": _email,
                            }).then((value) {
                              _userFirestoreDocumentID = value.id;
                              firestoreInstance
                                  .collection("Users")
                                  .doc(value.id)
                                  .set({
                                "iD": value.id,
                              }, SetOptions(merge: true)).then((_) {
                                print("success");
                              });
                            });
                            //Return to the discover page
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProfilePhotoUploadScreen(
                                            userFirestoreDocumentID:
                                                _userFirestoreDocumentID)));
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
  String userFirestoreDocumentID;

  ProfilePhotoUploadScreen({@required this.userFirestoreDocumentID});

  @override
  _ProfilePhotoUploadScreenState createState() =>
      _ProfilePhotoUploadScreenState(userFirestoreDocumentID);
}

class _ProfilePhotoUploadScreenState extends State<ProfilePhotoUploadScreen> {
  //Allow Users to upload a profile photo
  //Variables
  File _image; // Used only if you need a single picture
  final firestoreInstance = FirebaseFirestore.instance;
  GlobalVariables globals;
  String _uploadedFileURL;
  String userFirestoreDocumentID;

  _ProfilePhotoUploadScreenState(this.userFirestoreDocumentID);

//Functions
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

  Future<String> uploadFile(File _image) async {
    Future<String> _url;
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage
        .ref()
        .child("Users/" + userFirestoreDocumentID + "/profileImage");
    UploadTask uploadTask = ref.putFile(_image);
    uploadTask.then((res) {
      _url = res.ref.getDownloadURL();
    });
    return _url;

    //write URL of profile photo to user's document in firebase
  }

//Widgets

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore File Upload'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text('Selected Image'),
            _image != null
                ? Image.asset(
                    _image.path,
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
                      _uploadedFileURL = await uploadFile(_image);
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
