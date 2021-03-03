import 'package:flutter/material.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/widgets/options.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

class Quiz extends StatefulWidget {
  Quiz({this.questions, this.connectionChange});

  List<Question> questions;
  Map connectionChange;
  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  bool showAnswer = false;
  List selectedAnswers = [];
  String ansVal;
  int qIndex = 0;
  bool connected = true;
  connectionChanged(isconnect) {
    print("in quiz widget");
    connectionFail = !isconnect;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.connectionChange["internet"] = connectionChanged;
  }

  bool connectionFail = false;
  @override
  Widget build(BuildContext context) {
    print(widget.questions.length);
    return !connected
        ? Center(child: Text("Connect to internet to continue"))
        : Column(
            children: [
              Flexible(
                  flex: 4,
                  child: Center(
                      child: Text(
                    widget.questions[qIndex].q,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ))),
              Flexible(
                fit: FlexFit.tight,
                flex: 5,
                child: Options(
                  items: widget.questions[qIndex].options.split(', '),
                  selectedItems: selectedAnswers,
                  multiSelect: false,
                  showAnswer: showAnswer,
                  ansVal: ansVal,
                ),
              ),
              Flexible(
                flex: 1,
                child: RaisedButton(
                  color: Colors.grey[800],
                  child: Text(
                    showAnswer ? "Next" : "Submit",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (showAnswer) {
                      //next button
                      qIndex++;
                      showAnswer = false;
                      selectedAnswers = [];
                    } else {
                      //submit button
                      bool connected =
                          await DataConnectionChecker().hasConnection;
                      if (connected) {
                        connectionFail = false;
                        showAnswer = true;
                        ansVal = widget.questions[qIndex].options
                            .split(", ")[widget.questions[qIndex].ans - 1];
                      } else {
                        connectionFail = true;
                      }
                    }
                    setState(() {});
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Flexible(
                child: selectedAnswers.length > 0 && !connectionFail
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            selectedAnswers[0] == ansVal ? "CORRECT" : "WRONG",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: selectedAnswers[0] == ansVal
                                    ? Colors.green
                                    : Colors.red),
                          ),
                          Icon(
                            selectedAnswers[0] == ansVal
                                ? Icons.check
                                : Icons.error,
                            color: selectedAnswers[0] == ansVal
                                ? Colors.green
                                : Colors.red,
                          )
                        ],
                      )
                    : connectionFail
                        ? Text(
                            "Check internet connection",
                            style: TextStyle(color: Colors.red),
                          )
                        : SizedBox(),
              )
            ],
          );
  }
}
