import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';

Future<void> userSearches(String searchString) async {
  var length;
  var rng = new Random();
  var rand_val;
  int randomnum = rng.nextInt(10);
  var ref0 = FirebaseDatabase.instance
      .reference()
      .child('Customers/1234567890/Searches/');
  await ref0.once().then((DataSnapshot snapshot) async {
    var histtemp = snapshot.value.keys.cast<String>().toList();
    rand_val = histtemp[randomnum];
    length = histtemp.length;
  });
  if (searchString != null && length < 10) {
    print(length);
    FirebaseDatabase.instance
        .reference()
        .child(
            'Customers/1234567890/Searches/') //the numbers need to be user email when working
        .update({searchString: 'true'});
    print('Worked?');
  } else if (searchString != null) {
    print("RANDOM VAL:" + rand_val);
    await FirebaseDatabase.instance
        .reference()
        .child('Customers/1234567890/Searches/$rand_val')
        .remove();
    await FirebaseDatabase.instance
        .reference()
        .child(
            'Customers/1234567890/Searches/') //the numbers need to be user email when working
        .update({searchString: 'true'});
  }
  return;
}
