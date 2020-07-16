import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:quizzler/quiz_brain.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() => runApp(Quizzler());

Quizbrain quizBrain = Quizbrain();

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.redAccent,
          title: Text('Quizzler'),
          centerTitle: true,
        ),
        backgroundColor: Colors.blueGrey,
        body: SafeArea(
          child: QuizPage(),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Widget> _scoreKeeper = [];

  //bool _endOfQuiz = null;

  _resetAtEnd(context) {

    Alert(
      style: AlertStyle(
          isOverlayTapDismiss: false, animationType: AnimationType.fromTop),
      context: context,
      title: 'Quiz Completed!',
      desc: 'Quiz will be restarted',
      type: AlertType.success,
      buttons: [
        DialogButton(
          child: Text('OK'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ).show();
    _scoreKeeper = [];
    quizBrain.resetQuiz();
  }

  void checkClose(bool value) {
    final player = AudioCache();
    if (quizBrain.getQuestionAnswer() == value) {
      player.play('1.wav');
      _scoreKeeper.add(Icon(Icons.check, color: Colors.green));
    } else {
      player.play('2.wav');
      _scoreKeeper.add(Icon(Icons.close, color: Colors.red));
    }
    setState(() {
      //go to next question and if there is no question nextQuestion will return false
      if (quizBrain.nextQuestion() == false) {
        // if at end then show end and reset alert
        _resetAtEnd(context);
        player.play('finish.wav');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 8,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black54,
              ),
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Center(
                      child: Text(
                        quizBrain.getQuestionText(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          '?',
                          style: TextStyle(
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                    color: Colors.green,
                                    blurRadius: 3,
                                    offset: Offset.fromDirection(2))
                              ],
                              fontSize: 70,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              textColor: Colors.white,
              color: Colors.green,
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () => checkClose(true),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.deepOrange,
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () => checkClose(false),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(6)),
              child: Row(
                children: _scoreKeeper,
              ),
            ),
          ),
        )
      ],
    );
  }
}

/*
question1: 'You can lead a cow down stairs but not up stairs.', false,
question2: 'Approximately one quarter of human bones are in the feet.', true,
question3: 'A slug\'s blood is green.', true,
*/
