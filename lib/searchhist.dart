import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> userSearches(String searchString) async {
  // FirebaseAuth auth = FirebaseAuth.instance;
  // String uid = auth.currentUser.uid.toString();
  //CollectionReference users = FirebaseFirestore.instance.collection('Users');
  //CollectionReference users = FirebaseFirestore.instance.collection('Users').where('UserID', isEqualTo: uid);
  CollectionReference users = FirebaseFirestore.instance
      .collection('Users')
      .where('Display Name', isEqualTo: 'Shaq');
  users.add({'SearchHist': searchString});
  print('Worked?');
  return;
}
