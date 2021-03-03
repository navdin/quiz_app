import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/connection_state_mgmt.dart';
import 'package:quiz_app/network.dart';
import 'package:quiz_app/widgets/quiz_widget.dart';

import 'models/question_model.dart';

Function onConnectionFail;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(
          title: "Quiz",
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool isConnected = true;
  Network network;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    network = Network();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Map connectionChange = {"internet": null};
  // Map mapAtQ = {"atQIndex": 0, "showAnswer": false, "selectedAnswers": []};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: _connectionStatus == "fail"
            ? Center(child: Text("Connect to internet to continue."))
            : FutureBuilder(
                future: network.getQuestionsFromFirebase(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Column(
                        children: [
                          Center(
                              child: Text(snapshot.data.toString() +
                                  " Check internet connection.")),
                        ],
                      );
                    }
                    return Quiz(
                      questions: snapshot.data,
                      connectionChange: connectionChange,
                    );
                  } else {
                    return Container(
                      color: Colors.white,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(
                              width: 5,
                            ),
                            Center(
                                child: Text(
                              "Loading questions..",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.bold),
                            )),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ));
  }

  getDataFromFireBase() {
    CollectionReference collRef =
        FirebaseFirestore.instance.collection("questions");
  }

  submitAnswer(int index, bool isCorrect) async {
    CollectionReference collRef =
        FirebaseFirestore.instance.collection("report");
    await collRef.doc("q" + index.toString()).set({
      "isCorrect": isCorrect,
    }).catchError((error) {});
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    bool connected = await DataConnectionChecker().hasConnection;
    if (connectionChange["internet"] != null) {
      connectionChange["internet"](connected);
      return;
    }
    if (!connected) {
      {
        _connectionStatus = "fail";
        setState(() {});
      }
      // setState(() {});
    } else {
      _connectionStatus = "active";

      setState(() {});
    }
  }
}
