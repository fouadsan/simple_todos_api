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
            borderSide: BorderSide(
          color: Colors.indigo,
        )),
        hintText: hint,
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
          color: Color.fromRGBO(180, 180, 186, 0.4),
        )),
        hintStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.3)),
        icon: iconPath != ''
            ? Image.asset(
                iconPath,
                width: 50.0,
                fit: BoxFit.contain,
              )
            : null,
        errorStyle: TextStyle(color: Colors.red),
        errorBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        focusedErrorBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)));
  }

  Widget _buildTodo() {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildTodo(),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.indigo,
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await widget.client
                        .post(createUrl, body: {'body': _controller.text});

                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Todo has been created')));
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  "Submit",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
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
