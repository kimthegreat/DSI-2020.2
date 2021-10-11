import 'package:startup_name/edit_page.dart';
import 'package:startup_name/saved.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

final suggestions = <WordPair>[];
int indexofpair = 0;

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Startup Name Generator'), actions: [
          IconButton(
              icon: Icon(Icons.list),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => saved()));
              }),
        ]),
        body: _buildSuggestions());
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (BuildContext _context, int i) {
        if (i.isOdd) {
          return Divider();
        }
        final int index = i ~/ 2;
        if (index >= suggestions.length) {
          suggestions.addAll(generateWordPairs().take(10));
        }
        final item = suggestions[index];
        return Dismissible(
          key: ValueKey(item),
          onDismissed: (direction) {
            setState(() {
              if (favlist.contains(suggestions[index])) {
                favlist.remove(suggestions[index]);
              }
              suggestions.removeAt(index);
            });
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('$item dismissed')));
          },
          background: Container(color: Colors.red),
          child: _buildRow(index, suggestions[index]),
        );
      },
    );
  }

  Widget _buildRow(index, WordPair pair) {
    final alreadySaved = favlist.contains(pair);
    return ListTile(
        title: Text(pair.asPascalCase, style: _biggerFont),
        trailing: IconButton(
          icon: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border,
              color: alreadySaved ? Colors.red : null),
          onPressed: () {
            setState(() {
              if (alreadySaved) {
                favlist.remove(pair);
              } else {
                favlist.add(pair);
              }
            });
          },
        ),
        onTap: () {
          setState(() {
            indexofpair = index;
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => editName()));
          });
        });
  }
}
