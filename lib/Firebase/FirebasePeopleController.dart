import 'package:cloud_firestore/cloud_firestore.dart';

CollectionReference users = FirebaseFirestore.instance.collection('user');

Future<void> getUser(userId) async {

  FirebaseFirestore.instance
      .collection('user').doc(userId)
      .get()
      .then((value) {
      print(value.data()?["name"]);
  });
  var doc = await FirebaseFirestore.instance
      .collection('user').doc(userId)
      .get();

  print(doc.data());

}
