import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Band Names',
      theme: ThemeData(
        primaryColor: Colors.purple,
      ),
      home: MyHomePage(title: 'Band Names'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  final documents = DocumentSnapshot;

  Widget _buildListItem(BuildContext context,  DocumentSnapshot documents) {
    return ListTile(
      title: Row(
        children: [
          Expanded(child: Text(
            documents['Name'],
            style: Theme.of(context).textTheme.headline3,
            )
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xffddddff)
            ),
            padding: const EdgeInsets.all(10.0),
            child: Text(
              documents['Votes'].toString(),
              style: Theme.of(context).textTheme.headline3,
            ),
          )
        ],
      ),
      onTap: () {
        print("Should increase votes here.");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: StreamBuilder <QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('bandnames').snapshots(),
        builder: (context, snapshots){
          if (!snapshots.hasData) return const Text('Loading...');{
            var doc = DocumentSnapshot;
            return ListView.builder(
              itemExtent: 80.0,
              itemCount: snapshots.data!.docs.length,
              itemBuilder: (context, index) =>
                _buildListItem(context, snapshots.data!.docs[index]),
            );
          }
        }
      ),
    );
  }
}