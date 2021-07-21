import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import './note.dart';
import './urls.dart';
import './create.dart';
import './update.dart';
import './functions.dart';

class MyHomePage extends StatefulWidget {
  static const routeName = '/home';

  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _isInit = true;
  var _isLoading = false;
  var hasError = false;

  Client client = http.Client();
  List<Note> notes = [];

  @override
  void initState() {
    _isLoading = true;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {});
      _retrieveNotes().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  _retrieveNotes() async {
    notes = [];
    await getNotes(client, notes, retrieveUrl, hasError);
    setState(() {});
  }

  Future _deleteNote(int id) async {
    await client.delete(deleteUrl(id));
    await _retrieveNotes();
  }

  Future _showCreateNoteModal() async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) {
          return CreatePage(
            client: client,
            notes: notes,
            hasError: hasError,
          );
        });
    await _retrieveNotes();
    setState(() {
      getNotes(client, [], retrieveUrl, hasError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: _isLoading
          ? Padding(
              padding: const EdgeInsets.only(top: 300.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                _retrieveNotes();
              },
              child: hasError
                  ? Center(
                      child: Text('Oops, somthing went wrong'),
                    )
                  : Column(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height * 0.75,
                          child: ListView.builder(
                              itemCount: notes.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        width: 2.0,
                                        color: Colors.redAccent.shade700,
                                      ),
                                    ),
                                  ),
                                  child: ListTile(
                                    title: Text(notes[index].body),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => UpdatePage(
                                                  client: client,
                                                  id: notes[index].id,
                                                  body: notes[index].body,
                                                )),
                                      );
                                    },
                                    trailing: IconButton(
                                      onPressed: () =>
                                          _deleteNote(notes[index].id),
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        ElevatedButton(
                          onPressed: () => _showCreateNoteModal(),
                          child: Text('Add Todo'),
                        ),
                      ],
                    ),
            ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _showCreateNoteModal();
      //   },
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
