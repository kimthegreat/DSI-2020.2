import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

final favlist = <WordPair>{};

class saved extends StatefulWidget {
  @override
  _savedState createState() => _savedState();
}

class _savedState extends State<saved> {
  final _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    final tiles = favlist.map(
      (WordPair pair) {
        return ListTile(title: Text(pair.asPascalCase, style: _biggerFont));
      },
    );
    final divided = tiles.isNotEmpty
        ? ListTile.divideTiles(context: context, tiles: tiles).toList()
        : <Widget>[];
    return Scaffold(
      appBar: AppBar(title: Text('Saved Suggestions')),
      body: ListView(children: divided),
    );
  }
}
