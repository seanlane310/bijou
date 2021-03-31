import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';

Future<void> userSearches(String searchString) async {
  var length;
  var rng = new Random();
  var rand_val;
  var user_ID;
  var histtemp;
  int randomnum = rng.nextInt(10);

  if (FirebaseAuth.instance.currentUser != null) {
    user_ID = FirebaseAuth.instance.currentUser.uid;
    print(user_ID);
    var ref0 = FirebaseDatabase.instance
        .reference()
        .child('Customers/$user_ID/Searches/');
    await ref0.once().then((DataSnapshot snapshot) async {
      histtemp = snapshot.value.keys.cast<String>().toList();
      length = histtemp.length;
    });
    if (searchString != null && length < 10) {
      print(length);
      await FirebaseDatabase.instance
          .reference()
          .child(
              'Customers/$user_ID/Searches/') //the numbers need to be user email when working
          .update({searchString: 'true'});
      print('Worked?');
    } else if (searchString != null) {
      rand_val = histtemp[randomnum];
      print("RANDOM VAL:" + rand_val);
      await FirebaseDatabase.instance
          .reference()
          .child('Customers/$user_ID/Searches/$rand_val')
          .remove();
      await FirebaseDatabase.instance
          .reference()
          .child(
              'Customers/$user_ID/Searches/') //the numbers need to be user email when working
          .update({searchString: 'true'});
    }
  }
  return;
}
