import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);
  final _text = TextEditingController();
  final _text2 = TextEditingController();

  @override
  void dispose() {
    // limpa o controller quando for liberado
    _text.dispose();
    super.dispose();
  }

//update dos itens
  void editpair(index, first, second) {
    return _suggestions.insert(index, WordPair(first, second));
  }

// Tela de edição em construção
  void pushedit(index) {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text('Edit')),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: _text,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter the new name',
                    labelText: 'Startup first name'),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: _text2,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter the new name',
                    labelText: 'Startup second name'),
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 130, vertical: 30),
                child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.pink,
                        elevation: 4,
                        shadowColor: Colors.black),
                    child: Text(
                      'Rename',
                      style: TextStyle(color: Colors.black54, fontSize: 30),
                    ),
                    onPressed: () {
                      if (_text.text != '' && _text2.text != '') {
                        setState(() {
                          _suggestions.removeAt(index);
                          editpair(index, _text.text, _text2.text);
                        });
                        _text.clear();
                        _text2.clear();
                        Navigator.pop(context);
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content:
                                  Text('A field is empty! Please input a name'),
                            );
                          },
                        );
                      }
                    })),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 145, vertical: 0),
                child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: Colors.grey),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black54, fontSize: 25),
                  ),
                  onPressed: () {
                    _text.clear();
                    _text2.clear();
                    Navigator.pop(context);
                  },
                ))
          ],
        ),
      );
    }));
  }

  //redireciona para fav
  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final tiles = _saved.map(
            (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(context: context, tiles: tiles).toList()
              : <Widget>[];
          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Startup Name Generator'),
          actions: [
            IconButton(
              icon: Icon(Icons.list),
              onPressed: _pushSaved,
            )
          ],
        ),
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
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        final item = _suggestions[index];
        return Dismissible(
          key: ValueKey(item),
          onDismissed: (direction) {
            setState(() {
              if (_saved.contains(_suggestions[index])) {
                _saved.remove(_suggestions[index]);
              }
              _suggestions.removeAt(index);
            });
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('$item dismissed')));
          },
          background: Container(color: Colors.red),
          child: _buildRow(index, _suggestions[index]),
        );
      },
    );
  }

  Widget _buildRow(index, WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
        title: Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
        trailing: IconButton(
          icon: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border,
              color: alreadySaved ? Colors.red : null),
          onPressed: () {
            setState(() {
              if (alreadySaved) {
                _saved.remove(pair);
              } else {
                _saved.add(pair);
              }
            });
          },
        ),
        onTap: () {
          pushedit(index);
        });
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.pink,
      ),
      home: RandomWords(),
    );
  }
}
