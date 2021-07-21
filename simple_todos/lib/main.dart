import 'package:flutter/material.dart';

import './home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        accentColor: Colors.redAccent,
        canvasColor: Color.fromRGBO(243, 243, 251, 1),
        fontFamily: 'Poppins',
        textTheme: TextTheme(
          bodyText1: TextStyle(
            fontSize: 16.0,
            color: Color.fromRGBO(43, 61, 66, 1),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: MyHomePage(title: 'Django Todo'),
      routes: {
        MyHomePage.routeName: (ctx) => MyHomePage(
              title: "home",
            ),
      },
    );
  }
}
