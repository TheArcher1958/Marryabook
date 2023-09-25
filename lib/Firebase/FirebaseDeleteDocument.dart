import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marryabook/Models/FirebaseResponseObject.dart';
import 'package:marryabook/Models/PersonModel.dart';

CollectionReference users = FirebaseFirestore.instance.collection('user');

Future<FirebaseResponseObject?> deleteDocument(object) async {
  if(object.runtimeType == Person) {
    return await deletePerson(object);
    // print('person type');
    // DocumentReference documentRef = FirebaseFirestore.instance.collection('user').doc(object.parentUser.id).collection('people').doc(object.id);
    // documentRef
    //     .delete()
    //     .then((value)  {
    //       return FirebaseResponseObject('Success', 'Deletion was a success!');
    //       })
    //     .catchError((error) {
    //       return FirebaseResponseObject('Failure', error);
    // });
  } else if (object.runtimeType == int) { // todo change this later to Event type
    return FirebaseResponseObject('Failure', 'Recieved unexpected object type: ${object.runtimeType}');
  }
  return null;
}

Future<FirebaseResponseObject> deletePerson(person) async {
  try {
    DocumentReference documentRef = FirebaseFirestore.instance.collection('user').doc(person.parentUser.id).collection('people').doc(person.id);
    var deletion = documentRef.delete();
    print(deletion);
    return FirebaseResponseObject('Success', 'Deletion was a success!');
  } catch (err) {
    return FirebaseResponseObject('Failure', err);
    // rethrow;
  }
  // DocumentReference documentRef = FirebaseFirestore.instance.collection('user').doc(person.parentUser.id).collection('people').doc(person.id);
  // documentRef
  //     .delete()
  //     .then((value)  {
  //   return FirebaseResponseObject('Success', 'Deletion was a success!');
  // })
  //     .catchError((error) {
  //   return FirebaseResponseObject('Failure', error);
  // });
  // rethrow
}

