import 'package:flutter/material.dart';
import 'package:http/http.dart';
import './urls.dart';
import './home.dart';
import './note.dart';
import './functions.dart';

class CreatePage extends StatefulWidget {
  static const routeName = '/create';

  final Client client;
  final List<Note> notes;
  final bool hasError;
  const CreatePage({
    Key? key,
    required this.client,
    required this.notes,
    required this.hasError,
  }) : super(key: key);

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  TextEditingController _controller = TextEditingController();

  final _formKey = new GlobalKey<FormState>();

  InputDecoration _buildInputDecoration(String hint, String iconPath) {
    return InputDecoration(
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(252, 252, 252, 1))),
        hintText: hint,
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(151, 151, 151, 1))),
        hintStyle: TextStyle(color: Color.fromRGBO(252, 252, 252, 1)),
        icon: iconPath != ''
            ? Image.asset(
                iconPath,
                width: 50.0,
                fit: BoxFit.contain,
              )
            : null,
        errorStyle: TextStyle(color: Color.fromRGBO(248, 218, 87, 1)),
        errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(248, 218, 87, 1))),
        focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(248, 218, 87, 1))));
  }

  Widget _buildTodo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        style: TextStyle(
          color: Color.fromRGBO(0, 0, 0, 1),
        ),
        decoration:
            _buildInputDecoration("Enter a todo", 'assets/icons/edit.png'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildTodo(),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await widget.client
                      .post(createUrl, body: {'body': _controller.text});

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Todo has been created')));
                }
              },
              child: Text("Submit"),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
