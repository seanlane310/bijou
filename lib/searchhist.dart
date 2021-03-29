import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

Future<void> userSearches(String searchString) async {
  if (searchString != null) {
    FirebaseDatabase.instance
        .reference()
        .child(
            'Customers/1234567890/Searches/') //the numbers need to be user email when working
        .update({searchString: 'true'});
    print('Worked?');
  }
  return;
}
