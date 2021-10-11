import 'package:startup_name/startup_names.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class editName extends StatefulWidget {
  @override
  _editNameState createState() => _editNameState();
}

class _editNameState extends State<editName> {
  final _text = TextEditingController();
  final _text2 = TextEditingController();

  void editpair(index, first, second) {
    return suggestions.insert(index, WordPair(first, second));
  }

  void _cleanup() {
    _text.clear();
    _text2.clear();
  }

  void _namevalidator(index, first, second) {
    suggestions.removeAt(index);
    editpair(index, first, second);
    _cleanup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Edit')),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                  controller: _text,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter the new name',
                      labelText: 'Startup first name')),
              TextField(
                  controller: _text2,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter the new name',
                      labelText: 'Startup second name')),
              TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.grey,
                      elevation: 4,
                      shadowColor: Colors.white),
                  child: Text('Rename',
                      style: TextStyle(color: Colors.black54, fontSize: 30)),
                  onPressed: () {
                    if (_text.text != '' && _text2.text != '') {
                      setState(() {
                        _namevalidator(indexofpair, _text.text, _text2.text);
                      });
                      Navigator.pop(context);
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                              content: Text(
                                  'A field is empty! Please input a name'));
                        },
                      );
                    }
                  }),
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: Colors.grey),
                child: Text('Cancel',
                    style: TextStyle(color: Colors.black54, fontSize: 25)),
                onPressed: () {
                  _cleanup();
                  Navigator.pop(context);
                },
              )
            ]));
  }
}
