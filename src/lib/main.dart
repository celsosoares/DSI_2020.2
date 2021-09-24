import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.purple,
      ),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);
  late WordPair _wordPair;

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
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

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
          return _buildRow(_suggestions[index], index);
        });
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Startup Name Generator'), actions: [
        IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
      ]),
      body: _buildSuggestions(),
    );
  }

  Widget _buildRow(WordPair pair, int index) {
    final alreadySaved = _saved.contains(pair);

    return Dismissible(
      background: Container(
        color: Colors.black,
      ),
      onDismissed: (direction){
        setState(() {
          _suggestions.remove(pair);
        });
      },
      key: Key(pair.hashCode.toString()),
      child: ListTile(
            title: Text(pair.asPascalCase, style: _biggerFont),
            trailing: IconButton(
              icon: alreadySaved ? Icon(Icons.favorite) : Icon(
                  Icons.favorite_border),
              color: alreadySaved ? Colors.red : null,
              onPressed: () {
                setState(() {
                  if (alreadySaved) {
                    Icon(Icons.favorite_border, color: null,);
                    _saved.remove(pair);
                  } else {
                    Icon(Icons.favorite, color: Colors.red,);
                    _saved.add(pair);
                  }
                });
              },
            ),
            onTap: () => _toEditon(context, pair, index)
        ),
    );
  }

  _toEditon(context, pair, int index) {
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (BuildContext context) {
              _wordPair = pair;
              return Scaffold(
                appBar: AppBar(
                  title: Text('Edit item'),),
                body: Container(
                    color: Colors.white,
                    child: _buildForm(context, pair, index)),
              );
            }
        )
    );
  }

  _buildForm(context, pair, int index) {
    String first = '';
    String second = '';
    return Form(
      child: Wrap(
        alignment: WrapAlignment.center,
        runSpacing: 16.0,
        children: <Widget>[
          TextField(
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(labelText: 'First word'),
            onChanged: (newValue) {
              first = newValue;
            },
          ),
          TextField(
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(labelText: 'Second word'),
            onChanged: (value) {
              second = value;
            },
          ),
          SizedBox(
            width: double.infinity,
          ),
          ElevatedButton(
            onPressed: () => _save(context, index, first, second),
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _save(BuildContext context, int index, first, second) {
    setState(() {
      _wordPair = WordPair(first, second);
      _suggestions[index] = _wordPair;
    });
  }
}
