import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'models/question_model.dart';

class Network {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String uid;
  Future signInAnon() async {
    try {
      UserCredential userCred = await _auth.signInAnonymously();
      uid = userCred.user.uid;
      return userCred.user;
    } catch (e) {
      print(e.toString());
    }
  }

  List<Question> list;

  getQuestionsFromFirebase() async {
    if (list != null) {
      return list;
    }
    await signInAnon();
    CollectionReference collRef =
        await FirebaseFirestore.instance.collection("questions");
    Stream<QuerySnapshot> stream = collRef.snapshots();

    QuerySnapshot qs = await stream.first;

    try {
      list = qs.docs.map((e) {
        print("question");
        print(e.data());
        return Question.fromJson(e.data()); // e.data()
      }).toList();
    } catch (e) {
      print(e.toString());
    }

    return list;
  }
}
