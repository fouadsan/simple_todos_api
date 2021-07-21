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

  _showCreateNoteModal() async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        backgroundColor: Theme.of(context).canvasColor,
        builder: (ctx) {
          return CreatePage(
            client: client,
            notes: notes,
            hasError: hasError,
          );
        });
    _retrieveNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            color: Color.fromRGBO(43, 61, 66, 1),
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 6.0,
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
                  : Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(8.0),
                            height: MediaQuery.of(context).size.height * 0.68,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: ListView.builder(
                                itemCount: notes.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.0),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          width: 1.0,
                                          color: Color.fromRGBO(
                                              180, 180, 186, 0.4),
                                        ),
                                      ),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        notes[index].body,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
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
                                      trailing: OutlinedButton.icon(
                                        onPressed: () =>
                                            _deleteNote(notes[index].id),
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.indigo.shade500,
                                        ),
                                        label: Text(
                                          'Delete',
                                          style: TextStyle(
                                            color: Colors.indigo.shade500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width * 1 / 2,
                            child: OutlinedButton(
                              onPressed: () => _showCreateNoteModal(),
                              child: Text(
                                'Add Todo',
                              ),
                              style: OutlinedButton.styleFrom(
                                primary: Color.fromRGBO(43, 61, 66, 1),
                                textStyle: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                elevation: 0,
                                side: BorderSide(
                                  color: Colors.indigo.shade200,
                                  width: 4,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
