// quiz_form.dart
import 'package:flutter/material.dart';
import 'package:quiz_backoffice/model/quiz.dart';
import 'package:quiz_backoffice/api/quizapi.dart';

class AddQuizForm extends StatefulWidget {
  @override
  _AddQuizFormState createState() => _AddQuizFormState();
}

class _AddQuizFormState extends State<AddQuizForm> {
  final _formKey = GlobalKey<FormState>();
  final _quiz = Map<String, dynamic>();

  bool _hidden = false;
  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      // Assuming createQuiz returns a Future indicating success
      bool quizAdded = await ApiService.createQuiz(_quiz);

      if (quizAdded) {
        // Show a success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Quiz Added'),
              content: Text('The quiz has been successfully added.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Show an error dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to add the quiz. Please try again.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Category'),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter the category';
              }
              return null;
            },
            onSaved: (value) {
              _quiz['category'] = value;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Type'),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter the type';
              }
              return null;
            },
            onSaved: (value) {
              _quiz['type'] = value;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Difficulty'),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter the difficulty';
              }
              return null;
            },
            onSaved: (value) {
              _quiz['difficulty'] = value;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Question'),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter the question';
              }
              return null;
            },
            onSaved: (value) {
              _quiz['question'] = value;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Correct Answer'),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter the correct answer';
              }
              return null;
            },
            onSaved: (value) {
              if (value != null) {
                _quiz['correct_answer'] = value;
              }
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Incorrect Answer 1'),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter the incorrect answer 1';
              }
              return null;
            },
            onSaved: (value) {
              if (value != null) {
                _quiz['incorrect_answers'] = [value, '', ''];
              }
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Incorrect Answer 2'),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter the incorrect answer 2';
              }
              return null;
            },
            onSaved: (value) {
              if (value != null) {
                _quiz['incorrect_answers'][1] = value;
              }
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Incorrect Answer 3'),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter the incorrect answer 3';
              }
              return null;
            },
            onSaved: (value) {
              if (value != null) {
                _quiz['incorrect_answers'][2] = value;
              }
            },
          ),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text('Add Quiz'),
          ),
        ],
      ),
    );
  }
}
